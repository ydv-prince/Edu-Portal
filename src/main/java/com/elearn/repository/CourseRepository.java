package com.elearn.repository;

import com.elearn.model.Course;
import com.elearn.model.User;
import com.elearn.model.enums.CourseLevel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CourseRepository extends JpaRepository<Course, Long> {
	
	List<Course> findByApprovedTrue();

    // Teacher ke saare courses
    List<Course> findByInstructor(User instructor);

    // Sirf published + approved courses (Students browse karenge)
    List<Course> findByPublishedTrueAndApprovedTrue();

    // Category ke basis pe courses
    List<Course> findByCategoryIdAndPublishedTrueAndApprovedTrue(Long categoryId);

    // Level ke basis pe filter
    List<Course> findByLevelAndPublishedTrueAndApprovedTrue(CourseLevel level);

    // Admin ke liye — approve hone waale courses
    List<Course> findByApprovedFalse();

    // Search courses by title or description
    @Query("SELECT c FROM Course c WHERE c.published = true AND c.approved = true " +
           "AND (LOWER(c.title) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
           "OR LOWER(c.description) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<Course> searchCourses(@Param("keyword") String keyword);

    // Top rated courses (Homepage pe dikhane ke liye)
    @Query("SELECT c FROM Course c LEFT JOIN c.reviews r " +
           "WHERE c.published = true AND c.approved = true " +
           "GROUP BY c.id ORDER BY AVG(r.rating) DESC")
    List<Course> findTopRatedCourses();

    // Most enrolled courses
    @Query("SELECT c FROM Course c LEFT JOIN c.enrollments e " +
           "WHERE c.published = true AND c.approved = true " +
           "GROUP BY c.id ORDER BY COUNT(e) DESC")
    List<Course> findMostEnrolledCourses();

    // Teacher ke published courses ki count
    long countByInstructorAndPublishedTrue(User instructor);

    // Category + keyword combo search
    @Query("SELECT c FROM Course c WHERE c.published = true AND c.approved = true " +
           "AND c.category.id = :categoryId " +
           "AND LOWER(c.title) LIKE LOWER(CONCAT('%', :keyword, '%'))")
    List<Course> searchByCategoryAndKeyword(
            @Param("categoryId") Long categoryId,
            @Param("keyword") String keyword);
}