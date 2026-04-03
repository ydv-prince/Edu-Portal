package com.elearn.repository;

import com.elearn.model.Enrollment;
import com.elearn.model.Progress;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ProgressRepository extends JpaRepository<Progress, Long> {

    // Enrollment ke saare completed lessons
    List<Progress> findByEnrollmentAndCompletedTrue(Enrollment enrollment);

    // Specific lesson complete hai ya nahi
    Optional<Progress> findByEnrollmentAndLessonId(Enrollment enrollment, Long lessonId);

    boolean existsByEnrollmentAndLessonId(Enrollment enrollment, Long lessonId);

    // Ek enrollment mein kitne lessons complete hue
    long countByEnrollmentAndCompletedTrue(Enrollment enrollment);

    // Course progress percentage calculate karna
    @Query("SELECT COUNT(p) FROM Progress p " +
           "WHERE p.enrollment.id = :enrollmentId AND p.completed = true")
    long countCompletedLessons(@Param("enrollmentId") Long enrollmentId);
}