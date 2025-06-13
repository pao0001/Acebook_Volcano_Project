package com.makersacademy.acebook.model;

import jakarta.persistence.*;
import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

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
        private String forename;
        private String surname;


        public Comment() {}

        public Comment(String username, String commentContent,
                       Integer postID, LocalDateTime timeStamp, String forename, String surname) {
            this.username = username;
            this.commentContent = commentContent;
            this.postID = postID;
            this.timeStamp = timeStamp;
            this.forename = forename;
            this.surname = surname;
        }
    public String getFormattedTimestamp() {
        if (timeStamp == null) return "No Time Stamp";
        return timeStamp.format(DateTimeFormatter.ofPattern("dd MMM yyyy HH:mm"));

    }
}
