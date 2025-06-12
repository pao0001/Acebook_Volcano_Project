package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.Post;
import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.FriendRequestRepository;
import com.makersacademy.acebook.repository.PostRepository;
import com.makersacademy.acebook.repository.UserRepository;
import com.makersacademy.acebook.service.AuthenticatedUserService;
import com.makersacademy.acebook.controller.UploadController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Controller
public class ProfileController {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private AuthenticatedUserService authenticatedUserService;

    @Autowired
    private FriendRequestRepository friendRequestRepository;

    @Autowired
    private PostRepository postRepository;

    @Autowired
    private UploadController uploadController;

    @GetMapping("/myProfile")
    public String showMyProfile(Model model) {

        // Adding authenticated user
        User user = authenticatedUserService.getAuthenticatedUser();
        model.addAttribute("user", user);

        // Test data for navigating between profiles (optional)
        Iterable<User> users = userRepository.findAll();
        model.addAttribute("users", users);

        // Adding attribute friends
        Set<User> userFriends = user.getFriends();
        model.addAttribute("friends", userFriends);
        // Adding redundant attribute to keep friends fragment functional
        model.addAttribute("profileFriends", userFriends);

        // Adding limited friends
        List<User> friendList = new ArrayList<>(userFriends);
        Collections.shuffle(friendList);
        List<User> limitedFriends = friendList.stream()
                .limit(4)
                .collect(Collectors.toList());
        model.addAttribute("friends", limitedFriends);

        // Adding attribute friends
        List<Post> profilePosts = postRepository.findFeedNative(user.getId());
        model.addAttribute("profilePosts", profilePosts);
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

        // Adding attribute friends
        Set<User> currentUserFriends = currentUser.getFriends();
        model.addAttribute("friends", currentUserFriends);

        // Adding attribute friends
        Set<User> profileUserFriends = profileUser.getFriends();
        model.addAttribute("profileFriends", profileUserFriends);

        // Adding limited friends
        List<User> friendList = new ArrayList<>(currentUserFriends);
        Collections.shuffle(friendList);
        List<User> limitedFriends = friendList.stream()
                .limit(4)
                .collect(Collectors.toList());
        model.addAttribute("friends", limitedFriends);

        // Adding attribute friends
        List<Post> profilePosts = postRepository.findFeedNative(profileUser.getId());
        model.addAttribute("profilePosts", profilePosts);

        // Adding current user
        model.addAttribute("currentUser", currentUser);

        return "profile";
    }

    @PostMapping("/myProfile-update")
    public String updateUserProfile(@ModelAttribute User updatedUser,
                                    @RequestParam(value = "profileImage", required = false) MultipartFile profileImage,
                                    @RequestParam(value = "bannerImage", required = false) MultipartFile bannerImage) throws IOException {
        User user = authenticatedUserService.getAuthenticatedUser();

        // Update all editable fields
        user.setForename(updatedUser.getForename());
        user.setSurname(updatedUser.getSurname());
        user.setDescription(updatedUser.getDescription());
        user.setGender(updatedUser.getGender());
        user.setPronouns(updatedUser.getPronouns());
        user.setCurrentCity(updatedUser.getCurrentCity());
        user.setHometown(updatedUser.getHometown());
        user.setJob(updatedUser.getJob());
        user.setSchool(updatedUser.getSchool());
        user.setRelationshipStatus(updatedUser.getRelationshipStatus());
        user.setSexualOrientation(updatedUser.getSexualOrientation());
        user.setPoliticalViews(updatedUser.getPoliticalViews());
        user.setReligion(updatedUser.getReligion());

        // Handle profile image upload
        if (profileImage != null && !profileImage.isEmpty()) {
            String profileImageUrl = uploadController.handleProfileImageUpload(profileImage);
            user.setProfile_image_src(profileImageUrl);
        }

        // Handle banner image upload
        if (bannerImage != null && !bannerImage.isEmpty()) {
            String bannerImageUrl = uploadController.handleBannerImageUpload(bannerImage);
            user.setBanner_image_src(bannerImageUrl);
        }

        userRepository.save(user);
        return "redirect:/myProfile";
    }

}
