package com.elearn.repository;

import com.elearn.model.Assignment;
import com.elearn.model.Course;
import com.elearn.model.User;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AssignmentRepository extends JpaRepository<Assignment, Long> {

    List<Assignment> findByModuleId(Long moduleId);

    // JPA Magic: Assignment -> Module -> Course
    List<Assignment> findByModule_CourseIn(List<Course> courses);
     
    // JPA Magic: Assignment -> Module -> Course -> Instructor
    List<Assignment> findByModule_Course_Instructor(User instructor);
    
}