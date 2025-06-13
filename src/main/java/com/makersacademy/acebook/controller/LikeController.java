package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.Like;
import com.makersacademy.acebook.repository.LikeRepository;
import com.makersacademy.acebook.repository.UserRepository;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity; // Import for ResponseEntity
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody; // Import for @ResponseBody

import java.security.Principal;
import java.util.HashMap; // Import for HashMap
import java.util.Map;     // Import for Map

@Controller
public class LikeController {

    @Autowired
    private LikeRepository likeRepository;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/like")
    @ResponseBody // This annotation tells Spring to return the object as the response body (e.g., JSON)
    @Transactional
    public ResponseEntity<Map<String, Long>> likeItem( // Change return type to ResponseEntity<Map<String, Long>>
                                                       Principal principal,
                                                       @RequestParam String likedType,
                                                       @RequestParam Long likedId
                                                       // @RequestParam String redirectUrl // This is no longer needed for AJAX
    ) {
        // Prepare a map to hold the response data (e.g., the new like count)
        Map<String, Long> response = new HashMap<>();

        String userEmail = principal.getName();
        Long userId = userRepository.findUserByAuthId(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found"))
                .getId();

        // Check if the user has already liked this item
        boolean alreadyLiked = likeRepository
                .findByUserIdAndLikedTypeAndLikedId(userId, likedType, likedId)
                .isPresent();

        if (alreadyLiked) {
            // If already liked, then "unlike" it (delete the like)
            likeRepository.deleteByUserIdAndLikedTypeAndLikedId(userId, likedType, likedId);
        } else {
            // If not liked, then "like" it (create a new like)
            Like like = new Like();
            like.setUserId(userId);
            like.setLikedType(likedType);
            like.setLikedId(likedId);
            likeRepository.save(like);
        }

        // Get the updated total like count for the item
        long newLikeCount = likeRepository.countByLikedTypeAndLikedId(likedType, likedId);

        // Add the new like count to the response map
        response.put("newLikeCount", newLikeCount);

        // Return the response map as JSON with an HTTP 200 OK status
        return ResponseEntity.ok(response);
    }
}