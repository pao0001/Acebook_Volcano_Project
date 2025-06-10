package com.makersacademy.acebook.model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.sql.Date;
import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

//If @Data is required later, add annotations separately to avoid issues:
//@Getter, @Setter, @ToString, @EqualsAndHashCode, @RequiredArgsConstructor

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
    private String profile_image_src;
    private String gender;
    private String pronouns;
    private String currentCity;
    private String hometown;
    private String job;
    private String school;
    private String relationshipStatus;
    private String sexualOrientation;
    private String politicalViews;
    private String religion;
    private LocalDate dob;

    @ManyToMany
    @JoinTable(
            name = "friends",
            joinColumns = @JoinColumn(name = "user_id"),
            inverseJoinColumns = @JoinColumn(name = "friend_id")
    )

    // Using hashset to store friends to prevent duplicates and lets us do faster access/search
    private Set<User> friends = new HashSet<>();

    public User() {
    }

    public User(String username, boolean enabled, String authId) {
        this.username = username;
        this.authId = authId;
        this.enabled = enabled;
    }

    public User(String username, boolean enabled) {
        this.username = username;
        this.enabled = enabled;
    }

    public User(String username, boolean enabled, String authId, String description, String forename, String surname, String profile_image_src) {
        this.username = username;
        this.authId = authId;
        this.description = null;
        this.enabled = enabled;
    }

    public User(String username, boolean enabled, String authId, String description) {
        this.username = username;
        this.authId = authId;
        this.description = description;
        this.forename = forename;
        this.surname = surname;
        this.profile_image_src = profile_image_src;
    }
}
