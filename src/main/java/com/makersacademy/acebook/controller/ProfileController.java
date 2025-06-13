package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.Post;
import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.FriendRequestRepository;
import com.makersacademy.acebook.repository.PostRepository;
import com.makersacademy.acebook.repository.UserRepository;
import com.makersacademy.acebook.service.AuthenticatedUserService;
import com.makersacademy.acebook.controller.UploadController;
import com.makersacademy.acebook.model.RecFriend;
import com.makersacademy.acebook.repository.RecFriendRepository;
import com.makersacademy.acebook.service.RecFriendService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.*; // Ensure java.util.Comparator is imported implicitly or explicitly
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

    @Autowired
    private RecFriendRepository recFriendRepository;

    @Autowired
    RecFriendService recFriendService;

    @GetMapping("/myProfile")
    public String showMyProfile(Model model) {
        User currentUser = authenticatedUserService.getAuthenticatedUser();
        model.addAttribute("currentUser", currentUser);
        model.addAttribute("user", currentUser);
        Iterable<User> users = userRepository.findAll();
        model.addAttribute("users", users);

        Set<User> allMyFriends = currentUser.getFriends();
        List<User> limitedFriendsForSidebar = new ArrayList<>(allMyFriends);
        // Sort for consistent display in the sidebar
        limitedFriendsForSidebar.sort(Comparator.comparing(User::getForename).thenComparing(User::getSurname));
        limitedFriendsForSidebar = limitedFriendsForSidebar.stream()
                .limit(5)
                .collect(Collectors.toList());
        model.addAttribute("sidebarFriends", limitedFriendsForSidebar); // Use specific name for sidebar

        model.addAttribute("profileFriends", allMyFriends); // Renamed for clarity in template

        // Recommended friends
        recFriendService.generateAndStoreRecommendations();
        List<RecFriend> recommendedFriends = recFriendService.getRecommendationsForCurrentUser();
        model.addAttribute("recommendedFriends", recommendedFriends);

        // Adding attribute for posts by the current user
        List<Post> profilePosts = postRepository.findFeedNative(currentUser.getId()).stream()
                .sorted(Comparator.comparing(Post::getTimeStamp).reversed())
                .toList();
        model.addAttribute("profilePosts", profilePosts);
        return "myProfile";
    }

    @GetMapping("/profile/{id}")
    public String showUserProfile(@PathVariable Long id, Model model) {
        User profileUser = userRepository.findUserById(id)
                .orElseThrow(() -> new RuntimeException("User not found"));

        User currentUser = authenticatedUserService.getAuthenticatedUser();
        model.addAttribute("currentUser", currentUser);

        model.addAttribute("user", profileUser);

        boolean isAlreadyFriends = currentUser.getFriends().contains(profileUser);
        boolean hasPendingRequest = friendRequestRepository
                .existsBySenderAndReceiverAndPendingTrue(currentUser, profileUser);
        boolean isSelfProfile = currentUser.equals(profileUser);

        model.addAttribute("isAlreadyFriends", isAlreadyFriends);
        model.addAttribute("hasPendingRequest", hasPendingRequest);
        model.addAttribute("isSelfProfile", isSelfProfile);

        Set<User> allMyFriends = currentUser.getFriends();
        List<User> limitedFriendsForSidebar = new ArrayList<>(allMyFriends);
        limitedFriendsForSidebar.sort(Comparator.comparing(User::getForename).thenComparing(User::getSurname));
        limitedFriendsForSidebar = limitedFriendsForSidebar.stream()
                .limit(5)
                .collect(Collectors.toList());
        model.addAttribute("sidebarFriends", limitedFriendsForSidebar);

        Set<User> profileUserFriends = profileUser.getFriends();
        model.addAttribute("profileUserFullFriendsList", profileUserFriends);
        model.addAttribute("profileFriends", profileUserFriends);

        // Recommended friends (for current user)
        List<RecFriend> recommendedFriends = recFriendRepository.findByUser(currentUser);
        model.addAttribute("recommendedFriends", recommendedFriends);

        // Adding attribute for posts by the profile user
        List<Post> profilePosts = postRepository.findFeedNative(profileUser.getId());
        model.addAttribute("profilePosts", profilePosts);

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