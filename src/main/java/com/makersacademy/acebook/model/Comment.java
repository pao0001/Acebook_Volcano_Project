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
        private String comment;
        private int postID;
        @Column(name = "time_stamp")
        private LocalDateTime timeStamp;


        public Comment() {}

        public Comment(String username, String comment, int postID, LocalDateTime timeStamp) {
            this.username = username;
            this.comment = comment;
            this.postID = postID;
            this.timeStamp = timeStamp;
        }
}
