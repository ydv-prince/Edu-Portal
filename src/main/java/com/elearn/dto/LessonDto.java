package com.elearn.dto;

import jakarta.validation.constraints.*;
import lombok.*;
import org.springframework.web.multipart.MultipartFile;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class LessonDto {

    @NotBlank(message = "Lesson title required hai")
    @Size(min = 2, max = 200)
    private String title;

    private String content;
    private String videoUrl;
    private Integer durationMinutes;
    private Integer orderIndex;
    private boolean isFreePreview;

    @NotNull(message = "Module ID required hai")
    private Long moduleId;

    private MultipartFile resourceFile;
}