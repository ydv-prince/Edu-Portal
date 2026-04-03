package com.elearn.repository;

import com.elearn.model.Assignment;
import com.elearn.model.AssignmentSubmission;
import com.elearn.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AssignmentSubmissionRepository extends JpaRepository<AssignmentSubmission, Long> {

    // ── 1. Check if student has already submitted (Service Error Fix) ──
    // Ye method Object-based check karta hai
    boolean existsByAssignmentAndStudent(Assignment assignment, User student);

    // ── 2. Teacher ke liye saari submissions fetch karein ──
    // Path: Submission -> Assignment -> Module -> Course -> Instructor
    List<AssignmentSubmission> findByAssignment_Module_Course_Instructor(User instructor);

    // ── 3. ID based Queries (For specific lookups) ──
    List<AssignmentSubmission> findByAssignmentId(Long assignmentId);
    
    List<AssignmentSubmission> findByStudentId(Long studentId);
    
    Optional<AssignmentSubmission> findByAssignmentIdAndStudentId(Long assignmentId, Long studentId);

    // ── 4. Grading Status Queries ──
    List<AssignmentSubmission> findByAssignmentIdAndGradedFalse(Long assignmentId);
    
    // Check by IDs if needed
    boolean existsByAssignmentIdAndStudentId(Long assignmentId, Long studentId);
}