package com.elearn.dto;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class ReviewDto {

    @NotNull
    private Long courseId;

    @NotNull
    @Min(value = 1, message = "Rating 1 se kam nahi ho sakti")
    @Max(value = 5, message = "Rating 5 se zyada nahi ho sakti")
    private Integer rating;

    @Size(max = 1000, message = "Comment 1000 characters se zyada nahi ho sakta")
    private String comment;
}