package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.FriendRequestRepository;
import com.makersacademy.acebook.repository.UserRepository;
import com.makersacademy.acebook.service.AuthenticatedUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class ProfileController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AuthenticatedUserService authenticatedUserService;

    @Autowired
    private FriendRequestRepository friendRequestRepository;

    @GetMapping("/myProfile")
    public String showMyProfile(Model model) {
        User user = authenticatedUserService.getAuthenticatedUser();
        model.addAttribute("user", user);

        // Test data for navigating between profiles (optional)
        Iterable<User> users = userRepository.findAll();
        model.addAttribute("users", users);

        return "myProfile";
    }

    @GetMapping("/profile/{id}")
    public String showUserProfile(@PathVariable Long id, Model model) {
        User profileUser = userRepository.findUserById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));

        User currentUser = authenticatedUserService.getAuthenticatedUser();

        boolean isAlreadyFriends = currentUser.getFriends().contains(profileUser);
        boolean hasPendingRequest = friendRequestRepository
                .existsBySenderAndReceiverAndPendingTrue(currentUser, profileUser);
        boolean isSelfProfile = currentUser.equals(profileUser);

        model.addAttribute("user", profileUser);
        model.addAttribute("isAlreadyFriends", isAlreadyFriends);
        model.addAttribute("hasPendingRequest", hasPendingRequest);
        model.addAttribute("isSelfProfile", isSelfProfile);

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
            case "gender" -> user.setGender(updatedUser.getGender());
            case "pronouns" -> user.setPronouns(updatedUser.getPronouns());
            case "current_city" -> user.setCurrentCity(updatedUser.getCurrentCity());
            case "hometown" -> user.setHometown(updatedUser.getHometown());
            case "job" -> user.setJob(updatedUser.getJob());
            case "school" -> user.setSchool(updatedUser.getSchool());
            case "relationship_status" -> user.setRelationshipStatus(updatedUser.getRelationshipStatus());
            case "sexual_orientation" -> user.setSexualOrientation(updatedUser.getSexualOrientation());
            case "political_views" -> user.setPoliticalViews(updatedUser.getPoliticalViews());
            case "religion" -> user.setReligion(updatedUser.getReligion());
        }

        userRepository.save(user);
        return "redirect:/myProfile";
    }
}
