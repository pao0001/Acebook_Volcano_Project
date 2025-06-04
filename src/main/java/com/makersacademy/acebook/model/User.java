package com.makersacademy.acebook.model;

import jakarta.persistence.*;
//import lombok.Data;
import lombok.Getter;
import lombok.Setter;

import java.util.HashSet;
import java.util.Set;

import static java.lang.Boolean.TRUE;

//@Data

@Getter
@Setter
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

    private String forename;
    private String surname;

    // Connects the friends table ot
    @ManyToMany(fetch = FetchType.EAGER)
    @JoinTable(
            name = "friends",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "friend_id")
    )

    // Using hashset to store friends to prevent duplicates and lets us do faster access/search
    private Set<User> friends = new HashSet<>();

    // no arguments constructor
    public User() {
    }

    // constructor for login (extracts username, auth0_id)
    // all other fields set to null until updated by user
    public User(String username, String authId, boolean enabled) {
        this.username = username;
        this.authId = authId;
        this.enabled = enabled;
    }

    // constructor with username and enabled, for testing (no auth0_id required)
    public User(String username, boolean enabled) {
        this.username = username;
        this.enabled = enabled;
    }

    // full constructor, all arguments
    public User(String username, boolean enabled, String authId, String description, String forename, String surname) {
        this.username = username;
        this.authId = authId;
        this.description = null;
        this.enabled = enabled;
    }

    public User(String username, String authId, String description, boolean enabled) {
        this.username = username;
        this.authId = authId;
        this.description = description;
        this.forename = forename;
        this.surname = surname;
    }

    // Equals and hashCode only on id for Hibernate identity
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof User)) return false;
        User other = (User) o;
        return id != null && id.equals(other.getId());
    }

    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 31;
    }
}
