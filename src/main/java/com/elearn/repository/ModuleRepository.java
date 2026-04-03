package com.elearn.repository;

import com.elearn.model.CourseModule;
import com.elearn.model.User;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ModuleRepository
        extends JpaRepository<CourseModule, Long> {

    List<CourseModule> findByCourseIdOrderByOrderIndexAsc(Long courseId);
    
 // Ye method find karega: Module -> Course -> Instructor
    List<CourseModule> findByCourse_Instructor(User instructor);
    
    ;

    long countByCourseId(Long courseId);
}