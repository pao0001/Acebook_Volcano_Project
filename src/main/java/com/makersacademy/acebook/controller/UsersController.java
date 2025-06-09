package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.service.AuthenticatedUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.view.RedirectView;

@RestController
public class UsersController {
    @Autowired
    AuthenticatedUserService authenticatedUserService;

    @GetMapping("/users/after-login")
    public RedirectView afterLogin() {
        authenticatedUserService.getAuthenticatedUser();
        return new RedirectView("/checkDetails");
    }
}