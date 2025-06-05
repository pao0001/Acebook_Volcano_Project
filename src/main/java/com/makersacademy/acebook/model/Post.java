package com.makersacademy.acebook.model;

import jakarta.persistence.*;

import lombok.Data;

@Data
@Entity
@Table(name = "POSTS")
public class Post {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String content;
    private String username; // Newly added
    private String post_image_src;

    public Post() {}

    public Post(String content, String username, String post_image_src) {
        this.content = content;
        this.username = username;
        this.post_image_src = post_image_src;
    }

}
