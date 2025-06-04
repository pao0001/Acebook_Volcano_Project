package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.oidc.user.DefaultOidcUser;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.view.RedirectView;

import java.util.Set;

@RestController
public class UsersController {
    @Autowired
    UserRepository userRepository;

    @GetMapping("/users/after-login")
    public RedirectView afterLogin() {
        Object principalObj = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (!(principalObj instanceof OAuth2User principal)) {
            throw new RuntimeException("Expected OAuth2User but got: " + principalObj.getClass().getName());
        }

        String username = (String) principal.getAttributes().get("email");  // from Auth0
        String authId = principal.getName(); // this gives "auth0|userId"

        userRepository
                .findByAuthId(authId)
                .orElseGet(() -> {
                    User newUser = new User(username, authId, true);
                    return userRepository.save(newUser);
                });

        return new RedirectView("/posts");
    }

    @GetMapping("/friends")
    public ModelAndView viewFriends() {
        DefaultOidcUser principal = (DefaultOidcUser) SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getPrincipal();
        String username = (String) principal.getAttributes().get("email");

        // Find the user by username
        User currentUser = userRepository.findUserByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // Get friends
        Set<User> friends = currentUser.getFriends();

        // Pass friends to the view named "friends"
        ModelAndView mav = new ModelAndView("friends");
        mav.addObject("friends", friends);
        return mav;
    }
}