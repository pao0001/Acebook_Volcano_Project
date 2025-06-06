package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import com.makersacademy.acebook.service.AuthenticatedUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.view.RedirectView;

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
}