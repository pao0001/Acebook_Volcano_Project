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
        Object principalObj = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (!(principalObj instanceof OAuth2User principal)) {
            throw new RuntimeException("Unexpected principal type: " + principalObj.getClass().getName());
        }

        String authId = principal.getName(); // This should be "auth0|userId"
        System.out.println("Auth ID: " + authId);

        User user = userRepository
                .findByAuthId(authId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        model.addAttribute("user", user);
        return "posts/profile";
    }
}
