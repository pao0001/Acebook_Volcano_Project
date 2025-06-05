package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import com.makersacademy.acebook.service.AuthenticatedUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.stereotype.Controller;

import java.io.File;
import java.io.IOException;

@Controller
public class UploadController {

    private final String UPLOAD_DIR = "src/main/resources/static/uploads/profile/";

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
        String newFileName = user.getAuthId() + "." + extension;

        File uploadDir = new File(UPLOAD_DIR);

        File destination = new File(uploadDir, newFileName);
        image.transferTo(destination);

        user.setProfile_image_src("/uploads/profile/" + newFileName);
        userRepository.save(user);

        return "redirect:/myProfile";
    }

    private String getFileExtension(String filename) {
        int dotIndex = filename.lastIndexOf(".");
        return (dotIndex != -1) ? filename.substring(dotIndex + 1) : "";
    }
}
