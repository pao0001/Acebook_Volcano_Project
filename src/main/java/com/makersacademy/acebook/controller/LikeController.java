package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.Like;
import com.makersacademy.acebook.repository.LikeRepository;
import com.makersacademy.acebook.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;

@Controller
public class LikeController {

    @Autowired
    private LikeRepository likeRepository;

    @Autowired
    private UserRepository userRepository;

    @PostMapping("/like")
    public String likeItem(
            Principal principal,
            @RequestParam String likedType,  // "post" or "comment"
            @RequestParam Long likedId,
            @RequestParam String redirectUrl // URL to redirect back to
    ) {
        String userEmail = principal.getName();
        Long userId = userRepository.findUserByAuthId(userEmail)
                .orElseThrow(() -> new RuntimeException("User not found"))
                .getId();

        // Check if user already liked this item to prevent duplicates
        boolean alreadyLiked = likeRepository
                .findByUserIdAndLikedTypeAndLikedId(userId, likedType, likedId)
                .isPresent();

        if (!alreadyLiked) {
            Like like = new Like();
            like.setUserId(userId);
            like.setLikedType(likedType);
            like.setLikedId(likedId);
            likeRepository.save(like);
        }

        return "redirect:" + redirectUrl;
    }
}