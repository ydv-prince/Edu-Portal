package com.elearn.model;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.CreationTimestamp;
import java.time.LocalDateTime;

@Entity
@Table(name = "assignment_submissions")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class AssignmentSubmission {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    // --- PDF Storage (Database BLOB) ---
    @Lob 
    @Column(name = "file_data", columnDefinition = "LONGBLOB")
    private byte[] fileData; 

    @Column(name = "file_name")
    private String fileName;

    // --- Submission Content ---
    @Column(name = "submission_text", columnDefinition = "TEXT")
    private String submissionText;

    // --- Relationships ---
    @ToString.Exclude
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "assignment_id", nullable = false)
    private Assignment assignment;

    @ToString.Exclude
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "student_id", nullable = false)
    private User student;

    // --- Grading & Feedback ---
    @Column(name = "marks_obtained")
    private Integer marksObtained;

    @Column(columnDefinition = "TEXT")
    private String feedback;

    @Builder.Default // Lombok builder default value fix
    private boolean graded = false;

    @CreationTimestamp
    @Column(name = "submitted_at")
    private LocalDateTime submittedAt;
}