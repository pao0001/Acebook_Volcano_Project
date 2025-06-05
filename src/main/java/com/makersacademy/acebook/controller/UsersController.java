package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import com.makersacademy.acebook.service.AuthenticatedUserService;
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

    @Autowired
    AuthenticatedUserService authenticatedUserService;

    @GetMapping("/users/after-login")
    public RedirectView afterLogin() {
        User user = authenticatedUserService.getAuthenticatedUser();

        // Ensure user exists or create new one if not
        userRepository.findUserByAuthId(user.getAuthId())
                .orElseGet(() -> userRepository.save(user));

        return new RedirectView("/");
    }

    @GetMapping("/friends")
    public ModelAndView viewFriends() {
        User currentUser = authenticatedUserService.getAuthenticatedUser();

        // Get friends
        Set<User> friends = currentUser.getFriends();

        // Pass friends to the view named "friends"
        ModelAndView mav = new ModelAndView("friends");
        mav.addObject("friends", friends);
        return mav;
    }
}