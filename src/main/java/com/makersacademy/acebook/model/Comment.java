package com.makersacademy.acebook.model;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;

@Data
    @Entity
    @Table(name = "comments")


public class Comment {
        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)

        private Long id;
        private String username;
        @Column(name = "comment")
        private String commentContent;
        private Integer postID;
        @Column(name = "time_stamp", updatable = false)
        private LocalDateTime timeStamp;


        public Comment() {}

        public Comment(String username, String commentContent,
                       Integer postID, LocalDateTime timeStamp) {
            this.username = username;
            this.commentContent = commentContent;
            this.postID = postID;
            this.timeStamp = timeStamp;
        }
}
