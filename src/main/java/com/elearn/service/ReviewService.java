package com.elearn.service;

import com.elearn.dto.ReviewDto;
import com.elearn.model.*;
import com.elearn.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
@Transactional
public class ReviewService {

    private final ReviewRepository reviewRepository;
    private final CourseRepository courseRepository;
    private final UserRepository userRepository;
    private final EnrollmentRepository enrollmentRepository;

    // ← StudentController addReview(User, ReviewDto) call karta tha
    public Review addReview(User user, ReviewDto dto) {
        return addReview(dto, user.getEmail());
    }

    public Review addReview(ReviewDto dto, String userEmail) {
        User user = userRepository.findByEmail(userEmail)
                .orElseThrow(() ->
                        new RuntimeException("User not found"));
        Course course = courseRepository
                .findById(dto.getCourseId())
                .orElseThrow(() ->
                        new RuntimeException("Course not found"));

        if (!enrollmentRepository
                .existsByStudentAndCourse(user, course)) {
            throw new RuntimeException(
                    "Sirf enrolled students review de sakte hain");
        }

        if (reviewRepository.existsByUserIdAndCourseId(
                user.getId(), dto.getCourseId())) {
            throw new RuntimeException(
                    "Aap pehle hi review de chuke hain");
        }

        Review review = new Review();
        review.setUser(user);
        review.setCourse(course);
        review.setRating(dto.getRating());
        review.setComment(dto.getComment());

        return reviewRepository.save(review);
    }
 // Admin panel ke liye saare reviews nikalne ka method
    @Transactional(readOnly = true)
    public List<Review> getAllReviews() {
        return reviewRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<Review> getCourseReviews(Long courseId) {
        return reviewRepository.findByCourseId(courseId);
    }

    @Transactional(readOnly = true)
    public Double getAverageRating(Long courseId) {
        Double avg = reviewRepository
                .findAverageRatingByCourseId(courseId);
        return avg != null ? avg : 0.0;
    }

    public void deleteReview(Long reviewId) {
        reviewRepository.deleteById(reviewId);
    }
}