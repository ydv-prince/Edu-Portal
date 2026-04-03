package com.elearn.dto;

import jakarta.validation.constraints.*;
import lombok.*;

@Getter @Setter
@NoArgsConstructor @AllArgsConstructor
@Builder
public class ModuleDto {

    @NotBlank(message = "Module title required hai")
    @Size(min = 2, max = 200)
    private String title;

    private String description;

    private Integer orderIndex;

    @NotNull(message = "Course ID required hai")
    private Long courseId;
}