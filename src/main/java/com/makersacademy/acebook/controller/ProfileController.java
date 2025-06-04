package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class ProfileController {

    @Autowired
    UserRepository userRepository;

    @GetMapping("/myProfile")
    public String showMyProfile(Model model) {

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
                .findUserByAuthId(authId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // adds the user to the model to make it available in the view
        model.addAttribute("user", user);

        Iterable<User> users = userRepository.findAll(); // this line is just for testing links to user profiles
        model.addAttribute("users", users);  // this line is just for testing links to user profiles

        return "myProfile";
    }

    @GetMapping("/profile/{id}")
    public String showUserProfile(@PathVariable Long id, Model model) {

        User user = userRepository
                .findUserById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));

        model.addAttribute("user", user);
        return "profile";
    }

    @PostMapping("/myProfile")
    public String updateUserProfile(@ModelAttribute User updatedUser,
                                    @RequestParam(name = "field") String field) {

        Object principalObj = SecurityContextHolder.getContext().getAuthentication().getPrincipal();

        if (!(principalObj instanceof OAuth2User principal)) {
            throw new RuntimeException("Unexpected principal type: " + principalObj.getClass().getName());
        }

        // extracts the unique id from the principal and saves it as authId
        String authId = principal.getName();

        User user = userRepository.findUserByAuthId(authId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        switch (field) {
            case "forename" -> user.setForename(updatedUser.getForename());
            case "surname" -> user.setSurname(updatedUser.getSurname());
            case "description" -> user.setDescription(updatedUser.getDescription());
        }

        userRepository.save(user);
        return "redirect:/myProfile";
    }
}
