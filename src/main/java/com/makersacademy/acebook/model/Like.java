package com.makersacademy.acebook.model;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import lombok.Data;

@Data
@Entity
@Table(name = "likes", uniqueConstraints = {
        @UniqueConstraint(columnNames = {"user_id", "liked_type", "liked_id"})
})
public class Like {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "liked_type", nullable = false)
    private String likedType;

    @Column(name = "liked_id", nullable = false)
    private Long likedId;

    @Column(name = "created_at")
    private LocalDateTime createdAt = LocalDateTime.now();

    public Like() {}

    public Like(Long userId, String likedType, Long likedId) {
        this.userId = userId;
        this.likedType = likedType;
        this.likedId = likedId;
    }
}