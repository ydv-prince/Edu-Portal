package com.elearn.controller;

import com.elearn.dto.CourseCreateDto;
import com.elearn.model.*;
import com.elearn.service.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/teacher")
@PreAuthorize("hasRole('TEACHER')")
@RequiredArgsConstructor
public class TeacherController {

    private final UserService userService;
    private final CourseService courseService;
    private final ModuleService moduleService;
    private final LessonService lessonService;
    private final EnrollmentService enrollmentService;
    private final QuizService quizService;
    private final AssignmentService assignmentService;
    private final PaymentService paymentService;
    private final CategoryService categoryService;

    // ── Global Attributes ──
    @ModelAttribute
    public void addGlobalAttributes(Model model, @AuthenticationPrincipal UserDetails ud) {
        if (ud != null) {
            User teacher = userService.getUserByEmail(ud.getUsername());
            model.addAttribute("teacher", teacher);
        }
    }

    private User getCurrentUser(UserDetails ud) {
        return userService.getUserByEmail(ud.getUsername());
    }

    // ── 1. Dashboard ──
    @GetMapping("/dashboard")
    public String dashboard(@AuthenticationPrincipal UserDetails ud, Model model) {
        User teacher = getCurrentUser(ud);
        List<Course> courses = courseService.getCoursesByTeacher(teacher);
        long totalStudents = enrollmentService.getTotalStudentsForTeacher(teacher.getId());
        BigDecimal earnings = paymentService.getTeacherEarnings(teacher);

        model.addAttribute("courses", courses);
        model.addAttribute("totalCourses", courses.size());
        model.addAttribute("totalStudents", totalStudents);
        model.addAttribute("earnings", (earnings != null) ? earnings : BigDecimal.ZERO);
        return "teacher/dashboard";
    }

    // ── 2. Course Management ──
    @GetMapping("/courses")
    public String manageCourses(@AuthenticationPrincipal UserDetails ud, Model model) {
        User teacher = getCurrentUser(ud);
        model.addAttribute("courses", courseService.getCoursesByTeacher(teacher));
        return "teacher/manage-courses";
    }

    @GetMapping("/courses/add")
    public String addCoursePage(Model model) {
        model.addAttribute("courseDto", new CourseCreateDto());
        model.addAttribute("categories", categoryService.getAllCategories());
        return "teacher/add-course";
    }

    @PostMapping("/courses/save")
    public String saveOrUpdateCourse(@ModelAttribute CourseCreateDto dto, @AuthenticationPrincipal UserDetails ud, RedirectAttributes ra) {
        try {
            Course course = courseService.createCourse(dto, ud.getUsername());
            ra.addFlashAttribute("successMsg", "Course saved! Add your modules now.");
            return "redirect:/teacher/courses/" + course.getId() + "/modules";
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Error: " + e.getMessage());
            return "redirect:/teacher/courses/add";
        }
    }

    @GetMapping("/courses/edit/{courseId}")
    public String editCoursePage(@PathVariable Long courseId, Model model) {
        Course course = courseService.getCourseById(courseId);
        model.addAttribute("course", course);
        model.addAttribute("categories", categoryService.getAllCategories());
        return "teacher/add-course";
    }

    @PostMapping("/courses/delete/{courseId}")
    public String deleteCourse(@PathVariable Long courseId, @AuthenticationPrincipal UserDetails ud, RedirectAttributes ra) {
        try {
            courseService.deleteCourse(courseId, getCurrentUser(ud));
            ra.addFlashAttribute("successMsg", "Course deleted.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Failed: " + e.getMessage());
        }
        return "redirect:/teacher/courses";
    }

    // ── 3. Curriculum (Modules & Lessons) ──
    @GetMapping("/courses/{courseId}/modules")
    public String modulesPage(@PathVariable Long courseId, Model model) {
        model.addAttribute("course", courseService.getCourseById(courseId));
        model.addAttribute("modules", moduleService.getModulesByCourse(courseId));
        return "teacher/add-module-lesson";
    }

    @PostMapping("/courses/{courseId}/modules/add")
    public String addModule(@PathVariable Long courseId, @RequestParam String title, RedirectAttributes ra) {
        try {
            moduleService.createModule(courseId, title);
            ra.addFlashAttribute("successMsg", "Module added!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", e.getMessage());
        }
        return "redirect:/teacher/courses/" + courseId + "/modules";
    }

    @PostMapping("/modules/update/{moduleId}")
    public String updateModule(@PathVariable Long moduleId, @RequestParam String title, @RequestParam Long courseId, RedirectAttributes ra) {
        try {
            moduleService.updateModule(moduleId, title);
            ra.addFlashAttribute("successMsg", "Module updated successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Update failed: " + e.getMessage());
        }
        return "redirect:/teacher/courses/" + courseId + "/modules";
    }

    @PostMapping("/modules/{moduleId}/lessons/add")
    public String addLesson(@PathVariable Long moduleId, @RequestParam String title, @RequestParam int durationMinutes,
                            @RequestParam(required = false) String videoUrl, @RequestParam(required = false) String content,
                            @RequestParam(required = false) MultipartFile videoFile, @RequestParam(required = false) MultipartFile pdfFile,
                            RedirectAttributes ra) {
        try {
            CourseModule module = moduleService.getModuleById(moduleId);
            lessonService.createLessonWithFiles(moduleId, title, durationMinutes, videoUrl, content, videoFile, pdfFile);
            ra.addFlashAttribute("successMsg", "Lesson added successfully!");
            return "redirect:/teacher/courses/" + module.getCourse().getId() + "/modules";
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Upload Error: " + e.getMessage());
            return "redirect:/teacher/courses/" + moduleId + "/modules";
        }
    }

    // ── 4. Assessments Center ──
    @GetMapping("/assignments")
    public String showAssignmentsCenter(Model model, Principal principal) {
        User teacher = userService.getUserByEmail(principal.getName());
        List<Assignment> allTeacherAssignments = new java.util.ArrayList<>();
        List<CourseModule> teacherModules = new java.util.ArrayList<>();
        List<Course> courses = courseService.getCoursesByTeacher(teacher);
        
        for(Course course : courses) {
            List<CourseModule> modules = moduleService.getModulesByCourse(course.getId());
            for(CourseModule module : modules) {
                allTeacherAssignments.addAll(module.getAssignments());
                teacherModules.add(module);
            }
        }
        model.addAttribute("activeAssignments", allTeacherAssignments);
        model.addAttribute("submissions", assignmentService.getSubmissionsByTeacher(teacher));
        model.addAttribute("modules", teacherModules);
        return "teacher/assignments"; 
    }

    @PostMapping("/assignments/save")
    public String saveAssignment(@RequestParam String title, @RequestParam String type, @RequestParam Long moduleId,
                                 @RequestParam Integer maxMarks, @RequestParam String dueDate,
                                 @RequestParam(required = false) String description, RedirectAttributes ra) {
        try {
            Assignment savedAssignment = assignmentService.createAssignment(title, description, java.time.LocalDate.parse(dueDate), maxMarks, moduleId, type);
            ra.addFlashAttribute("successMsg", "Assessment published!");
            if ("QUIZ".equalsIgnoreCase(type)) {
                return "redirect:/teacher/assignments/" + savedAssignment.getId() + "/questions";
            }
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Failed to save: " + e.getMessage());
        }
        return "redirect:/teacher/assignments"; 
    }

    @PostMapping("/assignments/delete/{assignmentId}")
    public String deleteAssignment(@PathVariable Long assignmentId, RedirectAttributes ra) {
        try {
            Assignment assignment = assignmentService.getAssignmentById(assignmentId);
            Long courseId = assignment.getModule().getCourse().getId();
            assignmentService.deleteAssignment(assignmentId);
            ra.addFlashAttribute("successMsg", "Assignment deleted.");
            return "redirect:/teacher/courses/" + courseId + "/modules";
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Failed: " + e.getMessage());
            return "redirect:/teacher/assignments";
        }
    }

    // ── 5. Quiz Builder ──
    @GetMapping("/assignments/{assignmentId}/questions")
    public String showQuizBuilder(@PathVariable Long assignmentId, Model model) {
        Assignment assignment = assignmentService.getAssignmentById(assignmentId);
        model.addAttribute("assignment", assignment);
        model.addAttribute("questions", quizService.getQuestionsByAssignment(assignmentId));
        return "teacher/quiz-builder"; 
    }

    @PostMapping("/assignments/{assignmentId}/questions/add")
    public String addQuizQuestion(@PathVariable Long assignmentId, @RequestParam String questionText,
                                  @RequestParam String optionA, @RequestParam String optionB, @RequestParam String optionC,
                                  @RequestParam String optionD, @RequestParam String correctOption,
                                  @RequestParam Integer marks, RedirectAttributes ra) {
        try {
            quizService.addQuestion(assignmentId, questionText, optionA, optionB, optionC, optionD, correctOption, marks);
            ra.addFlashAttribute("successMsg", "Question added!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Failed: " + e.getMessage());
        }
        return "redirect:/teacher/assignments/" + assignmentId + "/questions";
    }

    @PostMapping("/assignments/{assignmentId}/questions/delete/{questionId}")
    public String deleteQuizQuestion(@PathVariable Long assignmentId, @PathVariable Long questionId, RedirectAttributes ra) {
        try {
            quizService.deleteQuestion(questionId);
            ra.addFlashAttribute("successMsg", "Question deleted.");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Error deleting.");
        }
        return "redirect:/teacher/assignments/" + assignmentId + "/questions";
    }

    // ── 6. Grading & Students ──
    @PostMapping("/assignments/grade/{submissionId}")
    public String gradeAssignment(@PathVariable Long submissionId, @RequestParam int marks, @RequestParam String feedback, RedirectAttributes ra) {
        assignmentService.gradeSubmission(submissionId, marks, feedback);
        ra.addFlashAttribute("successMsg", "Graded!");
        return "redirect:/teacher/assignments";
    }

    @GetMapping("/courses/students")
    public String viewAllStudents(@AuthenticationPrincipal UserDetails ud, Model model) {
        User teacher = getCurrentUser(ud);
        model.addAttribute("enrollments", enrollmentService.getEnrollmentsByTeacher(teacher));
        return "teacher/enrolled-students";
    }

    // ── 7. Revenue & Profile ──
    // ✅ FIX: Changed from "/revenue" to "/earnings" to perfectly match sidebar.jsp link
    @GetMapping("/earnings")   
    public String detailedEarnings(@AuthenticationPrincipal UserDetails ud, Model model) {
        User teacher = getCurrentUser(ud);
        model.addAttribute("transactions", paymentService.getTeacherPayments(teacher));
        model.addAttribute("totalEarnings", paymentService.getTeacherEarnings(teacher));
        return "teacher/revenue"; // Yeh wahi revenue.jsp open karega
    }

    @GetMapping("/profile")
    public String profilePage() {
        return "teacher/profile";
    }

    // ✅ FIX: Added try-catch and MultipartFile support for Profile image upload
    @PostMapping("/profile/update")
    public String updateProfile(@AuthenticationPrincipal UserDetails ud, 
                                @RequestParam String fullName,
                                @RequestParam(required = false) String bio, 
                                @RequestParam(required = false) String phone,
                                @RequestParam(required = false) MultipartFile profileImage,
                                RedirectAttributes ra) {
        try {
            userService.updateProfile(getCurrentUser(ud).getId(), fullName, bio, phone, profileImage);
            ra.addFlashAttribute("successMsg", "Profile Updated Successfully!");
        } catch (Exception e) {
            ra.addFlashAttribute("errorMsg", "Failed to update profile: " + e.getMessage());
        }
        return "redirect:/teacher/profile";
    }
}