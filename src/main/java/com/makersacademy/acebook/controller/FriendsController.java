package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import com.makersacademy.acebook.service.AuthenticatedUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import java.util.Set;

@RestController
public class FriendsController {
    @Autowired
    UserRepository userRepository;

    @Autowired
    AuthenticatedUserService authenticatedUserService;

    @GetMapping("/friends")
    public ModelAndView viewFriends() {

        // Get Authenticated User (logged-in user)
        User currentUser =  authenticatedUserService.getAuthenticatedUser();

        // List of a user's friends
        Set<User> friends = currentUser.getFriends();

        ModelAndView mav = new ModelAndView("friends");
        mav.addObject("friends", friends);
        mav.addObject("friendsCount", friends.size());
        return mav;
    }
}
