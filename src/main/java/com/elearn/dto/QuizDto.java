package com.elearn.dto;

import jakarta.validation.constraints.*;
import lombok.*;

import java.util.ArrayList;
import java.util.List;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class QuizDto {

    @NotBlank(message = "Quiz title required hai")
    private String title;

    @NotNull
    @Min(value = 1, message = "Passing score 1 se kam nahi ho sakta")
    @Max(value = 100, message = "Passing score 100 se zyada nahi ho sakta")
    private Integer passingScore = 60;

    @NotNull(message = "Module ID required hai")
    private Long moduleId;

    @NotEmpty(message = "Kam se kam ek question hona chahiye")
    private List<QuestionDto> questions = new ArrayList<>();

    @Getter @Setter
    @NoArgsConstructor @AllArgsConstructor
    public static class QuestionDto {
        @NotBlank
        private String questionText;
        @NotBlank
        private String optionA;
        @NotBlank
        private String optionB;
        private String optionC;
        private String optionD;
        @NotBlank
        private String correctAnswer;
        private Integer marks = 1;
    }
}