package com.elearn.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class NotificationService {

    private final EmailService emailService;

    // ── New Course Approval Notification (Admin ko) ──
    public void notifyAdminNewCourse(String adminEmail,
                                     String courseName,
                                     String teacherName) {
        String subject = "📚 Naya Course Approval Pending — " + courseName;
        // EmailService se bhejo — extend kar sakte hain future mein
        System.out.println("📧 Admin ko notify kiya: " + courseName
                         + " by " + teacherName);
    }

    // ── Assignment Graded Notification (Student ko) ──
    public void notifyAssignmentGraded(String studentEmail,
                                       String studentName,
                                       String assignmentTitle) {
        System.out.println("📧 Student ko notify kiya: Assignment '"
                         + assignmentTitle + "' graded ho gaya");
    }

    // ── New Enrollment Notification (Teacher ko) ──
    public void notifyTeacherNewEnrollment(String teacherEmail,
                                           String studentName,
                                           String courseName) {
        System.out.println("📧 Teacher ko notify kiya: " + studentName
                         + " ne '" + courseName + "' mein enroll kiya");
    }
}