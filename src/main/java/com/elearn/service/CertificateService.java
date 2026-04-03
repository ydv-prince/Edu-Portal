package com.elearn.service;

import com.elearn.model.*;
import com.elearn.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Transactional
public class CertificateService {

    private final CertificateRepository certificateRepository;
    private final UserRepository userRepository;
    private final CourseRepository courseRepository;
    private final EmailService emailService;

    @Value("${app.base-url}")
    private String baseUrl;

    public Certificate generateCertificate(Long userId, Long courseId) {
        // 1. Fetch User and Course first to use objects in repository
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Course course = courseRepository.findById(courseId)
                .orElseThrow(() -> new RuntimeException("Course not found"));

        // 2. Check if certificate already exists using Objects
        if (certificateRepository.existsByUserAndCourse(user, course)) {
            return certificateRepository
                    .findByUserAndCourse(user, course)
                    .orElseThrow(() -> new RuntimeException("Certificate not found even after exist check"));
        }

        // 3. Generate unique certificate number
        String certNumber = generateCertificateNumber();

        // 4. Create and Save Certificate
        Certificate cert = new Certificate();
        cert.setUser(user);
        cert.setCourse(course);
        cert.setCertificateNumber(certNumber);
        
        // ✅ FIXED: Using issueDate instead of issuedAt to match Model
        cert.setIssueDate(LocalDateTime.now());

        certificateRepository.save(cert);

        // 5. Send Professional Email
        String fullCertificateUrl = baseUrl + "/certificates/" + certNumber;
        
        emailService.sendCertificateEmail(
                user.getEmail(),
                user.getFullName(),
                course.getTitle(),
                fullCertificateUrl
        );

        return cert;
    }

    @Transactional(readOnly = true)
    public List<Certificate> getCertificatesByUser(User user) {
        // ✅ FIXED: Using findByUser instead of findByUserId
        return certificateRepository.findByUser(user);
    }

    @Transactional(readOnly = true)
    public List<Certificate> getUserCertificates(Long userId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return certificateRepository.findByUser(user);
    }

    @Transactional(readOnly = true)
    public Optional<Certificate> verifyCertificate(String certNumber) {
        return certificateRepository.findByCertificateNumber(certNumber);
    }

    private String generateCertificateNumber() {
        String year = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy"));
        String unique = String.valueOf(System.currentTimeMillis()).substring(8);
        return "CERT-" + year + "-" + unique;
    }
}