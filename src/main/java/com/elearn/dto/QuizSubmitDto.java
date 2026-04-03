package com.elearn.dto;

import lombok.*;
import java.util.Map;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class QuizSubmitDto {

    private Long quizId;

    // Key: questionId, Value: selected answer ("A","B","C","D")
    private Map<Long, String> answers;
}