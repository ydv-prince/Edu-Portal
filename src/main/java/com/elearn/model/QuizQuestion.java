package com.elearn.model;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "quiz_questions")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class QuizQuestion {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String questionText;

    @Column(nullable = false)
    private String optionA;
    
    @Column(nullable = false)
    private String optionB;
    
    @Column(nullable = false) // Options C aur D ko bhi mandatory rakha hai
    private String optionC;
    
    @Column(nullable = false)
    private String optionD;

    @Column(nullable = false)
    private String correctOption; // "correctAnswer" ko form ke mutabik rename kiya hai

    @Builder.Default
    private Integer marks = 1;

    // --- IMPORTANT CHANGE ---
    // Ab ye 'Quiz' ki jagah 'Assignment' se link hoga, 
    // kyunki hamara naya Quiz Builder assignment table ka use kar raha hai.
    @ToString.Exclude
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "assignment_id", nullable = false)
    private Assignment assignment;
}