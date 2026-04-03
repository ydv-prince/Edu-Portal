package com.elearn.repository;

import com.elearn.model.Review;
import com.elearn.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReviewRepository extends JpaRepository<Review, Long> {

    List<Review> findByCourseId(Long courseId);

    // ← Fix: ReviewService mein findByCourse() call tha
    List<Review> findByCourse_Id(Long courseId);

    Optional<Review> findByUserAndCourseId(User user, Long courseId);

    // ← Fix: existsByUserAndCourse → existsByUserIdAndCourseId
    boolean existsByUserIdAndCourseId(Long userId, Long courseId);

    @Query("SELECT AVG(r.rating) FROM Review r WHERE r.course.id = :courseId")
    Double findAverageRatingByCourseId(@Param("courseId") Long courseId);

    long countByCourseId(Long courseId);

    @Query("SELECT r.rating, COUNT(r) FROM Review r " +
           "WHERE r.course.id = :courseId GROUP BY r.rating")
    List<Object[]> getRatingDistribution(@Param("courseId") Long courseId);
}