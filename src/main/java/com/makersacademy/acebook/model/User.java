package com.makersacademy.acebook.model;

import jakarta.persistence.*;
import lombok.Data;

import java.util.HashSet;
import java.util.Set;

import static java.lang.Boolean.TRUE;

@Data
@Entity
@Table(name = "USERS")
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String username;
    private boolean enabled;

    // need to use @Column to tell JPA to map this field to the database as it has a "unique" qualifier
    @Column(name = "auth0_id", unique = true)
    private String authId;

    // need to tell JPA that this column is TEXT as it auto assumes it will be VARCHAR if it's a string
    @Column(columnDefinition = "TEXT")
    private String description;

    public User() {
        this.enabled = TRUE;
    }

    // Join table to link user ID with friend ID
    @ManyToMany
    @JoinTable(
            name = "friends",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "friend_id")
    )

    // Using hashset to store friends to prevent duplicates and lets us do faster access/search
    private Set<User> friends = new HashSet<>();

    public User(String username) {
        this.username = username;
        this.enabled = TRUE;
    }

    public User(String username, boolean enabled) {
        this.username = username;
        this.enabled = enabled;
    }

    public User(String username, String authId, boolean enabled) {
        this.username = username;
        this.authId = authId;
        this.description = null;
        this.enabled = enabled;
    }

    public User(String username, String authId, String description, boolean enabled) {
        this.username = username;
        this.authId = authId;
        this.description = description;
        this.enabled = enabled;
    }
}
