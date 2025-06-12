package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.Post;
import com.makersacademy.acebook.repository.PostRepository;
import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import com.makersacademy.acebook.service.AuthenticatedUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.stereotype.Controller;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Controller
public class UploadController {


    @Value("${upload.profile}")
    String profileUploadDir;

    @Value("${upload.posts}")
    String postsUploadDir;

    @Value("${upload.banner}")
    String bannerUploadDir;

    @Autowired
    UserRepository userRepository;

    @Autowired
    PostRepository postRepository;

    @Autowired
    AuthenticatedUserService authenticatedUserService;

    @PostMapping("/uploadProfileImage")
    public String handleProfileImageUpload(
            @RequestParam("image") MultipartFile image)
            throws IOException {

        if (image.isEmpty()) {
            return "redirect:/myProfile?error=empty";
        }

        // Use AuthenticatedUserService to get the current authenticated user
        User user = authenticatedUserService.getAuthenticatedUser();

        // Rename file: authId.extension
        String extension = getFileExtension(image.getOriginalFilename());
        String sanitizedId = user.getAuthId().replaceAll("[^a-zA-Z0-9_-]", "_");
        String profileFileName = sanitizedId + "." + extension;


        // Create upload directory if it doesn't exist
        Path uploadPath = Paths.get(profileUploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Delete old image if it exists
        if (user.getProfile_image_src() != null && !user.getProfile_image_src().isEmpty()) {
            String oldFileName = user.getProfile_image_src().replace("/uploads/profile/", "");
            Path oldImagePath = uploadPath.resolve(oldFileName);
            try {
                Files.deleteIfExists(oldImagePath);
            } catch (IOException e) {
                // Log the error but continue with new upload
                System.err.println("Failed to delete old profile image: " + e.getMessage());
            }
        }

        // Save new image
        Path destination = uploadPath.resolve(profileFileName);
        image.transferTo(destination.toFile());

        // Update user with new image path (web-accessible path)
        user.setProfile_image_src("/uploads/profile/" + profileFileName);
        userRepository.save(user);

        return "/uploads/profile/" + profileFileName;
    }

    @PostMapping("/uploadPostImage")
    public String handlePostImageUpload(
            @RequestParam("postId") Long postId,
            @RequestParam("image") MultipartFile image)
            throws IOException {

        if (image.isEmpty()) {
            return "redirect:/myProfile?error=empty";
        }

        // Post Repository redirect if post is NULL
        Post savedPost = postRepository.findById(postId).orElse(null);
        if (savedPost == null) {
            return "redirect:/myProfile?error=notfound";
        }

        // Sanitize timestamp (e.g., "2024-06-09T15:30:00" => "20240609_153000")
        String safeTimestamp = savedPost.getFormattedTimestamp()
                .replaceAll("[:\\-T]", "")
                .replaceAll("\\s+", "_");

        // Rename file: post_postId.extension
        String extension = getFileExtension(image.getOriginalFilename());
        String postFileName = "post_" + savedPost.getId() + "_" + safeTimestamp + "." + extension;

        // Create upload directory if it doesn't exist
        Path uploadPath = Paths.get(postsUploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Delete old image if it exists
        if (savedPost.getPost_image_src() != null && !savedPost.getPost_image_src().isEmpty()) {
            String oldFileName = savedPost.getPost_image_src().replace("/uploads/posts/", "");
            Path oldImagePath = uploadPath.resolve(oldFileName);
            try {
                Files.deleteIfExists(oldImagePath);
            } catch (IOException e) {
                // Log the error but continue with new upload
                System.err.println("Failed to delete old posts image: " + e.getMessage());
            }
        }

        // Save new image
        Path destination = uploadPath.resolve(postFileName);
        image.transferTo(destination.toFile());

        // Save post_image_src to repository
        savedPost.setPost_image_src("/uploads/posts/" + postFileName);
        postRepository.save(savedPost);
        return "redirect:/";
    }
    @PostMapping("/uploadBannerImage")
    public String handleBannerImageUpload(
            @RequestParam("image") MultipartFile image) throws IOException {

        if (image.isEmpty()) {
            return "redirect:/myProfile?error=empty";
        }

        // Use AuthenticatedUserService to get the current authenticated user
        User user = authenticatedUserService.getAuthenticatedUser();

        // Rename file: authId.extension
        String extension = getFileExtension(image.getOriginalFilename());
        String sanitizedId = user.getAuthId().replaceAll("[^a-zA-Z0-9_-]", "_");
        String bannerFileName = sanitizedId + "_banner." + extension;

        // Create upload directory if it doesn't exist
        Path uploadPath = Paths.get(bannerUploadDir); // Define this as @Value("${upload.banner}") String bannerUploadDir;
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        // Delete old banner image if it exists
        if (user.getBanner_image_src() != null && !user.getBanner_image_src().isEmpty()) {
            String oldFileName = user.getBanner_image_src().replace("/uploads/banner/", "");
            Path oldImagePath = uploadPath.resolve(oldFileName);
            try {
                Files.deleteIfExists(oldImagePath);
            } catch (IOException e) {
                System.err.println("Failed to delete old banner image: " + e.getMessage());
            }
        }

        // Save new banner image
        Path destination = uploadPath.resolve(bannerFileName);
        image.transferTo(destination.toFile());

        // Update user with new banner image path (web-accessible path)
        user.setBanner_image_src("/uploads/banner/" + bannerFileName);
        userRepository.save(user);

        return "/uploads/banner/" + bannerFileName;
    }

    private String getFileExtension(String filename) {
        int dotIndex = filename.lastIndexOf(".");
        return (dotIndex != -1) ? filename.substring(dotIndex + 1) : "";
    }
}
