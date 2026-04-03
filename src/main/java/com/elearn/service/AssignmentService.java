package com.elearn.service;

import com.elearn.model.*;
import com.elearn.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class AssignmentService {

    private final AssignmentRepository assignmentRepository;
    private final AssignmentSubmissionRepository submissionRepository;
    private final ModuleRepository moduleRepository;
    private final UserRepository userRepository;
    private final EnrollmentRepository enrollmentRepository;

    /** ── 1. Create New Assignment ── */
    public Assignment createAssignment(String title, String description, LocalDate dueDate,
                                     Integer maxMarks, Long moduleId, String type) { 
        
        CourseModule module = moduleRepository.findById(moduleId)
                .orElseThrow(() -> new RuntimeException("Module not found"));

        Assignment assignment = Assignment.builder()
                .title(title)
                .description(description)
                .dueDate(dueDate)
                .maxMarks(maxMarks)
                .module(module)
                .type(type)
                .build();

        return assignmentRepository.save(assignment);
    }
    
    /** ── Assignment id se fetch karne ke liye method ── */
    @Transactional(readOnly = true)
    public Assignment getAssignmentById(Long id) {
        return assignmentRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Assignment not found with id: " + id));
    }
    
    /** ── Assignment delete karne ka logic ── */
    public void deleteAssignment(Long assignmentId) {
        if (assignmentRepository.existsById(assignmentId)) {
            assignmentRepository.deleteById(assignmentId);
            System.out.println("✅ Assignment ID " + assignmentId + " deleted successfully.");
        } else {
            throw new RuntimeException("Assignment not found with ID: " + assignmentId);
        }
    }
    
    /** ── Student ke liye assignments fetch karne ka method ── */
    @Transactional(readOnly = true)
    public List<Assignment> getAssignmentsForStudent(User student) {
        List<Course> enrolledCourses = enrollmentRepository.findByStudent(student)
                .stream()
                .map(Enrollment::getCourse)
                .toList();

        if (enrolledCourses.isEmpty()) {
            return List.of(); 
        }

        return assignmentRepository.findByModule_CourseIn(enrolledCourses);
    }

    /** ── 2. Submit Assignment (Text Only) ── */
    public AssignmentSubmission submitAssignment(User student, Long assignmentId, String text) {
        return submitAssignment(assignmentId, student.getEmail(), text, null);
    }

    /** ── 2. Submit Assignment (PDF to DB BLOB) ── */
    public AssignmentSubmission submitAssignment(Long assignmentId, String studentEmail, 
                                                String text, MultipartFile file) {

        Assignment assignment = assignmentRepository.findById(assignmentId)
                .orElseThrow(() -> new RuntimeException("Assignment not found"));
        
        User student = userRepository.findByEmail(studentEmail)
                .orElseThrow(() -> new RuntimeException("Student not found"));

        // Check duplicate submission
        if (submissionRepository.existsByAssignmentAndStudent(assignment, student)) {
            throw new RuntimeException("Assignment already submitted!");
        }

        AssignmentSubmission sub = AssignmentSubmission.builder()
                .assignment(assignment)
                .student(student)
                .submissionText(text)
                .graded(false)
                .build();

        // Convert PDF file to byte array for Database storage
        if (file != null && !file.isEmpty()) {
            try {
                sub.setFileData(file.getBytes()); 
                sub.setFileName(file.getOriginalFilename());
            } catch (IOException e) {
                throw new RuntimeException("Failed to process PDF file: " + e.getMessage());
            }
        }

        return submissionRepository.save(sub);
    }

    /** ── 3. Teacher: Grade Submission ── */
    public void gradeSubmission(Long submissionId, int marks, String feedback) {
        AssignmentSubmission sub = submissionRepository.findById(submissionId)
                .orElseThrow(() -> new RuntimeException("Submission not found"));
        
        if (marks > sub.getAssignment().getMaxMarks()) {
            throw new RuntimeException("Marks cannot exceed " + sub.getAssignment().getMaxMarks());
        }

        sub.setMarksObtained(marks);
        sub.setFeedback(feedback);
        sub.setGraded(true);
        submissionRepository.save(sub);
    }
    

    /** ── 4. Queries for Teacher ── */
    @Transactional(readOnly = true)
    public List<AssignmentSubmission> getSubmissionsByTeacher(User teacher) {
        return submissionRepository.findByAssignment_Module_Course_Instructor(teacher);
    }

    @Transactional(readOnly = true)
    public List<Assignment> getAssignmentsByTeacher(User teacher) {
        // FIXED: Using repository method to find all assignments for courses owned by the teacher
        return assignmentRepository.findByModule_Course_Instructor(teacher);
    }

    @Transactional(readOnly = true)
    public AssignmentSubmission findById(Long id) {
        return submissionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Submission not found"));
    }
}