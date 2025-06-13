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
    AuthenticatedUserService authenticatedUserService;

    @GetMapping("/users/after-login")
    public RedirectView afterLogin() {
        authenticatedUserService.getAuthenticatedUser();
        return new RedirectView("/completeDetails");
    }

    //used for saving the details of new users after sign up.
    @Autowired
    UserRepository userRepository;
    @PostMapping("/saveNewUserDetails")
    public RedirectView saveNewUserDetails(@ModelAttribute User newUser){
        User user = authenticatedUserService.getAuthenticatedUser();
        user.setForename(newUser.getForename());
        user.setSurname(newUser.getSurname());
        user.setDob(newUser.getDob());
        userRepository.save(user);

        return new RedirectView("/");
    }
}