package com.makersacademy.acebook.model;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Entity
@NoArgsConstructor
@Table(name="REC_FRIENDS")
public class RecFriend {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @ManyToOne
    @JoinColumn(name = "rec_friend_id", nullable = false)
    private User recFriend;

    @Column(name = "mutuals")
    private Integer mutuals;

    public RecFriend(User user, User recFriend, Integer mutuals) {
        this.user = user;
        this.recFriend = recFriend;
        this.mutuals = mutuals;
    }
}
