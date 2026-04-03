package com.elearn.repository;

import com.elearn.model.Lesson;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LessonRepository extends JpaRepository<Lesson, Long> {

    // Module ke saare lessons order se
    List<Lesson> findByModuleIdOrderByOrderIndexAsc(Long moduleId);

    // Free preview lessons (Non-enrolled students ke liye)
    List<Lesson> findByModuleIdAndFreePreviewTrue(Long moduleId);

    // Course ki saari lessons (module ke through)
    @Query("SELECT l FROM Lesson l WHERE l.module.course.id = :courseId " +
           "ORDER BY l.module.orderIndex ASC, l.orderIndex ASC")
    List<Lesson> findAllByCourseId(@Param("courseId") Long courseId);

    // Total lessons count for a course
    @Query("SELECT COUNT(l) FROM Lesson l WHERE l.module.course.id = :courseId")
    long countByCourseId(@Param("courseId") Long courseId);

    // Module ke andar total duration
    @Query("SELECT SUM(l.durationMinutes) FROM Lesson l WHERE l.module.id = :moduleId")
    Integer getTotalDurationByModule(@Param("moduleId") Long moduleId);
}