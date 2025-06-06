package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import com.makersacademy.acebook.service.AuthenticatedUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class ProfileController {

    @Autowired
    UserRepository userRepository;

    @Autowired
    AuthenticatedUserService authenticatedUserService;

    @GetMapping("/myProfile")
    public String showMyProfile(Model model) {

        User user = authenticatedUserService.getAuthenticatedUser();

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

        User user = authenticatedUserService.getAuthenticatedUser();

        switch (field) {
            case "forename" -> user.setForename(updatedUser.getForename());
            case "surname" -> user.setSurname(updatedUser.getSurname());
            case "description" -> user.setDescription(updatedUser.getDescription());
        }

        userRepository.save(user);
        return "redirect:/myProfile";
    }
}
