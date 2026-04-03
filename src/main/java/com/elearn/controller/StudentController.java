package com.elearn.controller;

import com.elearn.dto.PaymentDto;
import com.elearn.dto.ReviewDto;
import com.elearn.model.*;
import com.elearn.service.*;
import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/student")
@PreAuthorize("hasRole('STUDENT')")
@RequiredArgsConstructor
public class StudentController {

    private final UserService userService;
    private final CourseService courseService;
    private final EnrollmentService enrollmentService;
    private final ProgressService progressService;
    private final PaymentService paymentService;
    private final QuizService quizService;
    private final ReviewService reviewService;
    private final CertificateService certificateService;
    private final AssignmentService assignmentService;

    // ── Helper: Get Current User ──
    private User getCurrentUser(UserDetails ud) {
        return userService.getUserByEmail(ud.getUsername());
    }

    // ── Dashboard ──
    @GetMapping("/dashboard")
    public String dashboard(@AuthenticationPrincipal UserDetails ud, Model model) {
        User student = getCurrentUser(ud);
        List<Enrollment> enrollments = enrollmentService.getStudentEnrollments(student);
        model.addAttribute("student", student);
        model.addAttribute("enrollments", enrollments);
        model.addAttribute("totalEnrolled", enrollments.size());
        model.addAttribute("completedCourses", enrollments.stream().filter(Enrollment::isCompleted).count());
        model.addAttribute("certificates", certificateService.getCertificatesByUser(student));
        return "student/dashboard";
    }

    @GetMapping("/my-courses")
    public String myCourses(@AuthenticationPrincipal UserDetails ud, Model model) {
        model.addAttribute("enrollments", enrollmentService.getStudentEnrollments(getCurrentUser(ud)));
        return "student/my-courses";
    }

    // ── Course Detail ──
    @GetMapping("/course-detail/{courseId}")
    public String courseDetail(@PathVariable Long courseId, @AuthenticationPrincipal UserDetails ud, Model model) {
        User student = getCurrentUser(ud);
        Course course = courseService.getCourseById(courseId);
        model.addAttribute("course", course);
        model.addAttribute("isEnrolled", enrollmentService.isEnrolled(student, course));
        model.addAttribute("avgRating", reviewService.getAverageRating(courseId));
        model.addAttribute("reviews", reviewService.getCourseReviews(courseId));
        return "student/course-detail";
    }

    // ── Payment & Free Enrollment ──
    @GetMapping("/payment/{courseId}")
    public String paymentPage(@PathVariable Long courseId, @AuthenticationPrincipal UserDetails ud, Model model) {
        User student = getCurrentUser(ud);
        Course course = courseService.getCourseById(courseId);
        if (enrollmentService.isEnrolled(student, course)) return "redirect:/student/learn/" + courseId;
        model.addAttribute("course", course);
        model.addAttribute("student", student);
        return "student/payment";
    }

    @PostMapping("/payment/process")
    public String processPayment(@ModelAttribute PaymentDto dto, @AuthenticationPrincipal UserDetails ud, RedirectAttributes ra) {
        try {
            paymentService.processPayment(getCurrentUser(ud), dto);
            ra.addFlashAttribute("successMsg", "Payment successful!");
            return "redirect:/student/learn/" + dto.getCourseId();
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", e.getMessage());
            return "redirect:/student/payment/" + dto.getCourseId();
        }
    }

    @PostMapping("/enroll/free/{courseId}")
    public String enrollFree(@PathVariable Long courseId, @AuthenticationPrincipal UserDetails ud, RedirectAttributes ra) {
        try {
            enrollmentService.enrollStudent(getCurrentUser(ud).getId(), courseId);
            ra.addFlashAttribute("successMsg", "Enrolled successfully!");
            return "redirect:/student/learn/" + courseId;
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", e.getMessage());
            return "redirect:/student/course-detail/" + courseId;
        }
    }

    // ── Unified Classroom (Learn Page) ──
    @GetMapping("/learn/{courseId}")
    public String learnPage(@PathVariable Long courseId, 
                            @RequestParam(required = false) Long lessonId,
                            @RequestParam(required = false) Long assignmentId,
                            @AuthenticationPrincipal UserDetails ud, Model model) {
        
        User student = getCurrentUser(ud);
        Course course = courseService.getCourseById(courseId);

        if (!enrollmentService.isEnrolled(student, course)) return "redirect:/student/course-detail/" + courseId;

        List<CourseModule> modules = course.getModules();

        if (assignmentId != null) {
            Assignment currentAssignment = null;
            for (CourseModule m : modules) {
                for (Assignment a : m.getAssignments()) {
                    if (a.getId().equals(assignmentId)) { currentAssignment = a; break; }
                }
                if (currentAssignment != null) break;
            }
            // Quiz Logic: Agar title mein Quiz hai toh quizMode true karein
            if (currentAssignment != null && currentAssignment.getTitle().toLowerCase().contains("quiz")) {
                model.addAttribute("quizMode", true);
            }
            model.addAttribute("currentAssignment", currentAssignment);
        } else {
            Lesson currentLesson = null;
            if (lessonId != null) {
                for (CourseModule m : modules) {
                    for (Lesson l : m.getLessons()) {
                        if (l.getId().equals(lessonId)) { currentLesson = l; break; }
                    }
                    if (currentLesson != null) break;
                }
            }
            if (currentLesson == null && !modules.isEmpty() && !modules.get(0).getLessons().isEmpty()) {
                currentLesson = modules.get(0).getLessons().get(0);
            }
            model.addAttribute("currentLesson", currentLesson);
        }

        model.addAttribute("course", course);
        model.addAttribute("modules", modules);
        model.addAttribute("enrollment", enrollmentService.getEnrollment(student, course));
        return "student/learn";
    }

    @PostMapping("/lesson/complete")
    public String markComplete(@RequestParam Long lessonId, @RequestParam Long courseId, @AuthenticationPrincipal UserDetails ud) {
        progressService.markLessonComplete(getCurrentUser(ud), lessonId);
        return "redirect:/student/learn/" + courseId + "?lessonId=" + lessonId;
    }

    @PostMapping("/assignment/submit")
    public String submitAssignment(@RequestParam Long assignmentId, @RequestParam Long courseId, 
                                   @RequestParam("file") MultipartFile file, @AuthenticationPrincipal UserDetails ud, RedirectAttributes ra) {
        try {
            assignmentService.submitAssignment(getCurrentUser(ud), assignmentId, "File: " + file.getOriginalFilename());
            ra.addFlashAttribute("successMsg", "Submitted: " + file.getOriginalFilename());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", e.getMessage());
        }
        return "redirect:/student/learn/" + courseId + "?assignmentId=" + assignmentId;
    }

    // ── Quiz (Based on Assignment ID) ──
    @GetMapping("/quiz/{assignmentId}")
    public String quizPage(@PathVariable Long assignmentId, @AuthenticationPrincipal UserDetails ud, Model model) {
        model.addAttribute("assignment", assignmentService.getAssignmentById(assignmentId));
        model.addAttribute("questions", quizService.getQuestionsByAssignment(assignmentId));
        return "student/quiz"; 
    }

    @PostMapping("/quiz/submit")
    public String submitQuiz(@RequestParam Long assignmentId, @RequestParam Map<String, String> answers, @AuthenticationPrincipal UserDetails ud, RedirectAttributes ra) {
        User student = getCurrentUser(ud);
        try {
            List<QuizQuestion> questions = quizService.getQuestionsByAssignment(assignmentId);
            int score = 0;
            for (QuizQuestion q : questions) {
                if (q.getCorrectOption().equals(answers.get("q_" + q.getId()))) score += q.getMarks();
            }
            assignmentService.submitAssignment(student, assignmentId, "Quiz Score: " + score);
            ra.addFlashAttribute("successMsg", "Quiz submitted! Score: " + score);
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", e.getMessage());
        }
        return "redirect:/student/dashboard";
    }

    // ── Certificates & Profile ──
    @GetMapping("/certificates")
    public String myCertificates(@AuthenticationPrincipal UserDetails ud, Model model) {
        model.addAttribute("certificates", certificateService.getCertificatesByUser(getCurrentUser(ud)));
        return "student/certificates";
    }

    @GetMapping("/profile")
    public String profilePage(@AuthenticationPrincipal UserDetails ud, Model model) {
        User student = getCurrentUser(ud);
        model.addAttribute("student", student);
        model.addAttribute("certificates", certificateService.getCertificatesByUser(student));
        return "student/profile";
    }

    @PostMapping("/profile/update")
    public String updateProfile(@AuthenticationPrincipal UserDetails ud, @RequestParam String fullName, 
                                @RequestParam String bio, @RequestParam String phone, 
                                @RequestParam MultipartFile profileImage, RedirectAttributes ra) {
        try {
            userService.updateProfile(getCurrentUser(ud).getId(), fullName, bio, phone, profileImage);
            ra.addFlashAttribute("successMsg", "Profile updated!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", e.getMessage());
        }
        return "redirect:/student/profile";
    }
}