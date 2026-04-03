package com.elearn.repository;

import com.elearn.model.Payment;
import com.elearn.model.User;
import com.elearn.model.enums.PaymentStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Repository
public interface PaymentRepository extends JpaRepository<Payment, Long> {

    List<Payment> findByUser(User user);

    List<Payment> findByStatus(PaymentStatus status);

    Optional<Payment> findByTransactionId(String transactionId);

    List<Payment> findByPaidAtBetween(LocalDateTime start, LocalDateTime end);

    // ✅ CourseId use kar raha hai (Perfect!)
    Optional<Payment> findByUserAndCourseIdAndStatus(User user, Long courseId, PaymentStatus status);

    boolean existsByUserAndCourseIdAndStatus(User user, Long courseId, PaymentStatus status);

    @Query("SELECT SUM(p.amount) FROM Payment p WHERE p.status = 'COMPLETED'")
    BigDecimal calculateTotalRevenue();

    @Query("SELECT MONTH(p.paidAt), SUM(p.amount) FROM Payment p " +
           "WHERE p.status = 'COMPLETED' AND YEAR(p.paidAt) = :year " +
           "GROUP BY MONTH(p.paidAt)")
    List<Object[]> getMonthlyRevenue(@Param("year") int year);
    
 // ✅ 'teacher' ko wapas 'instructor' kar diya gaya hai
    @Query("SELECT SUM(p.amount) FROM Payment p " +
           "WHERE p.course.instructor.id = :teacherId " +
           "AND p.status = 'COMPLETED'")
    BigDecimal calculateRevenueByTeacher(@Param("teacherId") Long teacherId);

    // ✅ Yahan bhi 'instructor' kar diya gaya hai
    @Query("SELECT p FROM Payment p " +
           "WHERE p.course.instructor.id = :teacherId " +
           "AND p.status = 'COMPLETED'")
    List<Payment> findByTeacherId(@Param("teacherId") Long teacherId);
}