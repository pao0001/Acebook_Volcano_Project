package com.makersacademy.acebook.service;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

@Service
public class AuthenticatedUserService {

    private final UserRepository userRepository;

    public AuthenticatedUserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    // Helper method to get the OAuth2User principal or throw if unexpected
    private OAuth2User getPrincipal() {
        Object principalObj = SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        if (!(principalObj instanceof OAuth2User principal)) {
            throw new RuntimeException("Unexpected principal type: " + principalObj.getClass().getName());
        }
        return principal;
    }

    public User getAuthenticatedUser() {
        String authId = getPrincipal().getName();
        return userRepository.findUserByAuthId(authId)
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    public String getAuthenticatedAuthId() {
        return getPrincipal().getName();
    }

    public String getAuthenticatedEmail() {
        return (String) getPrincipal().getAttributes().get("email");
    }
}
