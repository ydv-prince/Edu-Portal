package com.elearn.repository;

import com.elearn.model.Course;
import com.elearn.model.Enrollment;
import com.elearn.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface EnrollmentRepository extends JpaRepository<Enrollment, Long> {

    // ── Student & Course Queries ──
    
    // Student ka specific course mein enrollment dhundhne ke liye
    Optional<Enrollment> findByStudentAndCourse(User student, Course course);

    // Check karne ke liye ki student already enrolled hai ya nahi
    boolean existsByStudentAndCourse(User student, Course course);

    // Student ID aur Course ID se direct fetch karne ke liye
    Optional<Enrollment> findByStudentIdAndCourseId(Long studentId, Long courseId);

    // ── Student List Queries ──

    // Student ke saare enrollments fetch karne ke liye
    List<Enrollment> findByStudent(User student);

    // Sirf wahi enrollments jo student ne complete kar liye hain
    List<Enrollment> findByStudentAndCompletedTrue(User student);

    // ── Course & Instructor Queries ──

    // Ek specific course ke saare enrolled students ki list
    List<Enrollment> findByCourse(Course course);

    // Course ki total enrollments count karne ke liye
    long countByCourse(Course course);

    // Enrollment -> Course -> Instructor (User) relationship se find karna
    List<Enrollment> findByCourse_Instructor(User instructor);

    // ── Custom Count Queries (JPQL) ──

    // Teacher ke saare courses mein total kitne students hain
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.course.instructor.id = :teacherId")
    long countByTeacherId(@Param("teacherId") Long teacherId);

    // Direct SQL/JPQL count for Teacher Dashboard
    @Query("SELECT COUNT(e) FROM Enrollment e WHERE e.course.instructor.id = :teacherId")
    long countTotalStudentsByTeacherId(@Param("teacherId") Long teacherId);
}