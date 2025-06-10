package com.makersacademy.acebook.model;

import jakarta.persistence.*;

import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Data
@Entity
@Table(name = "POSTS")
public class Post {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String content;
    private String username;
    private LocalDateTime timeStamp;
    private String post_image_src;
    private Integer user_id;

    public Post() {}

    public Post(String content, String username, LocalDateTime timeStamp, String post_image_src, Integer user_id) {
        this.content = content;
        this.username = username;
        this.post_image_src = post_image_src;
        this.timeStamp = timeStamp;
        this.user_id = user_id;
    }
    public String getFormattedTimestamp() {
        if (timeStamp == null) return "No Time Stamp";
        return timeStamp.format(DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm"));

    }

    public void setUserID(Integer userId) {
    }
}

