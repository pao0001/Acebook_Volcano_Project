package com.makersacademy.acebook.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "FRIEND_REQUESTS")
public class FriendRequest {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "sender_id", nullable = false)
    private User sender;

    @ManyToOne
    @JoinColumn(name = "receiver_id", nullable = false)
    private User receiver;

    private boolean pending;

    @Column(name = "sent_at")
    private LocalDateTime sentAt;

    public FriendRequest() {}

    public FriendRequest(User sender, User receiver, boolean pending, LocalDateTime sentAt) {
        this.sender = sender;
        this.receiver = receiver;
        this.pending = pending;
        this.sentAt = sentAt;
    }
}