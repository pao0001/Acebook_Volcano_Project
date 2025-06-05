package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.oidc.user.DefaultOidcUser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import java.util.Set;

@RestController
public class FriendsController {
    @Autowired
    UserRepository userRepository;

    @GetMapping("/friends")
    public ModelAndView viewFriends() {

        // extracting user's email from authenticator and setting it as "username"
        DefaultOidcUser principal = (DefaultOidcUser) SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getPrincipal();
        String username = (String) principal.getAttributes().get("email");

        // Creates new User object "currentUser" by using an email/user in the database.
        User currentUser = userRepository.findUserByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // List of a user's friends
        Set<User> friends = currentUser.getFriends();

        ModelAndView mav = new ModelAndView("friends");
        mav.addObject("friends", friends);
        mav.addObject("friendsCount", friends.size());
        return mav;
    }
}
