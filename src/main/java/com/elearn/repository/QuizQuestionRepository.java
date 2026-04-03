package com.elearn.repository;

import com.elearn.model.QuizQuestion;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface QuizQuestionRepository extends JpaRepository<QuizQuestion, Long> {

    // Ye line Spring Boot ko batati hai ki Assignment ID se questions dhundhne hain
    List<QuizQuestion> findByAssignmentId(Long assignmentId);
    
    // Agar future mein count chahiye ho toh:
    long countByAssignmentId(Long assignmentId);
}