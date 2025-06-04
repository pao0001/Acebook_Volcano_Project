package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;


@Controller
public class ProfileController {

    @Autowired
    UserRepository userRepository;

    @GetMapping("/profile")
    public String showProfile(Model model) {

        // the 'principal' is the currently authenticated user in Spring Security
        // this looks through SecurityContextHolder to find the principal
        Object principalObj = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        // throws an error if the returned principal object is not a 0auth2user
        if (!(principalObj instanceof OAuth2User principal)) {
            throw new RuntimeException("Unexpected principal type: " + principalObj.getClass().getName());
        }

        // extracts the unique id from the principal and saves it as authId
        String authId = principal.getName();

        // creates a user repository and searches the database for a user matching the authId from the principal
        // throws an error if the user does not exist
        User user = userRepository
                .findByAuthId(authId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // adds the user to the model to make it available in the view
        model.addAttribute("user", user);
        return "posts/profile";
    }
}
