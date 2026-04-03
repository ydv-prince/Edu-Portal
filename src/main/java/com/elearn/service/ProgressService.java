package com.elearn.service;

import com.elearn.model.Enrollment;
import com.elearn.model.Lesson;
import com.elearn.model.Progress;
import com.elearn.model.User;
import com.elearn.model.Course;
import com.elearn.repository.EnrollmentRepository;
import com.elearn.repository.LessonRepository;
import com.elearn.repository.ProgressRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ProgressService {

    private final ProgressRepository progressRepository;
    private final EnrollmentRepository enrollmentRepository;
    private final LessonRepository lessonRepository;
    private final CertificateService certificateService;

    // ← StudentController markLessonComplete(User, Long) call karta tha
    public void markLessonComplete(User student, Long lessonId) {
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() ->
                        new RuntimeException("Lesson not found"));

        Long courseId = lesson.getModule().getCourse().getId();

        Enrollment enrollment = enrollmentRepository
                .findByStudentIdAndCourseId(student.getId(), courseId)
                .orElseThrow(() ->
                        new RuntimeException("Enrollment not found"));

        if (progressRepository.existsByEnrollmentAndLessonId(
                enrollment, lessonId)) return;

        Progress progress = new Progress();
        progress.setEnrollment(enrollment);
        progress.setLesson(lesson);
        progress.setCompleted(true);
        progressRepository.save(progress);

        updateProgressPercentage(enrollment);
    }

    // ← Original method bhi rakhte hain
    public void markLessonComplete(Long enrollmentId, Long lessonId) {
        Enrollment enrollment = enrollmentRepository
                .findById(enrollmentId)
                .orElseThrow(() ->
                        new RuntimeException("Enrollment not found"));
        Lesson lesson = lessonRepository.findById(lessonId)
                .orElseThrow(() ->
                        new RuntimeException("Lesson not found"));

        if (progressRepository.existsByEnrollmentAndLessonId(
                enrollment, lessonId)) return;

        Progress progress = new Progress();
        progress.setEnrollment(enrollment);
        progress.setLesson(lesson);
        progress.setCompleted(true);
        progressRepository.save(progress);

        updateProgressPercentage(enrollment);
    }

    // ← StudentController calculateProgress(User, Course) call karta tha
    public int calculateProgress(User student, Course course) {
        Enrollment enrollment = enrollmentRepository
                .findByStudentIdAndCourseId(
                        student.getId(), course.getId())
                .orElse(null);
        if (enrollment == null) return 0;
        return enrollment.getProgressPercent();
    }

    // ← StudentController getProgressForEnrollment(Enrollment) call karta tha
    public List<Progress> getProgressForEnrollment(
            Enrollment enrollment) {
        return progressRepository
                .findByEnrollmentAndCompletedTrue(enrollment);
    }

    private void updateProgressPercentage(Enrollment enrollment) {
        Long courseId = enrollment.getCourse().getId();
        long totalLessons = lessonRepository.countByCourseId(courseId);

        if (totalLessons == 0) return;

        long completedLessons = progressRepository
                .countCompletedLessons(enrollment.getId());

        int percentage = (int) ((completedLessons * 100) / totalLessons);
        enrollment.setProgressPercent(percentage);

        if (percentage == 100) {
            enrollment.setCompleted(true);
            enrollment.setCompletedAt(LocalDateTime.now());
            certificateService.generateCertificate(
                    enrollment.getStudent().getId(),
                    courseId);
        }
        enrollmentRepository.save(enrollment);
    }

    @Transactional(readOnly = true)
    public boolean isLessonCompleted(Long enrollmentId, Long lessonId) {
        Enrollment enrollment = enrollmentRepository
                .findById(enrollmentId)
                .orElseThrow(() ->
                        new RuntimeException("Enrollment not found"));
        return progressRepository
                .existsByEnrollmentAndLessonId(enrollment, lessonId);
    }
}