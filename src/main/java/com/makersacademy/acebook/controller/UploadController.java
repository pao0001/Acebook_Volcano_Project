package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import com.makersacademy.acebook.service.AuthenticatedUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.stereotype.Controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

@Controller
public class UploadController {


    @Value("${upload.profile}")
    String profileUploadDir;

    @Autowired
    UserRepository userRepository;

    @Autowired
    AuthenticatedUserService authenticatedUserService;

    @PostMapping("/uploadProfileImage")
    public String handleImageUpload(@RequestParam("image") MultipartFile image) throws IOException {
        if (image.isEmpty()) {
            return "redirect:/myProfile?error=empty";
        }

        // Use AuthenticatedUserService to get the current authenticated user
        User user = authenticatedUserService.getAuthenticatedUser();

        // Rename file: authId.extension
        String extension = getFileExtension(image.getOriginalFilename());
        String sanitizedId = user.getAuthId().replaceAll("[^a-zA-Z0-9_-]", "_");
        String newFileName = sanitizedId + "." + extension;


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
        Path destination = uploadPath.resolve(newFileName);
        image.transferTo(destination.toFile());

        // Update user with new image path (web-accessible path)
        user.setProfile_image_src("/uploads/profile/" + newFileName);
        userRepository.save(user);

        return "redirect:/myProfile";
    }

    private String getFileExtension(String filename) {
        int dotIndex = filename.lastIndexOf(".");
        return (dotIndex != -1) ? filename.substring(dotIndex + 1) : "";
    }
}
