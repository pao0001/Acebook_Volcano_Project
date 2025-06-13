package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.FriendRequest;
import com.makersacademy.acebook.model.RecFriend;
import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.FriendRequestRepository;
import com.makersacademy.acebook.repository.UserRepository;
import com.makersacademy.acebook.service.AuthenticatedUserService;
import com.makersacademy.acebook.service.RecFriendService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;
import jakarta.servlet.http.HttpServletRequest;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@RestController
public class FriendsController {
    @Autowired
    UserRepository userRepository;

    @Autowired
    FriendRequestRepository friendRequestRepository;

    @Autowired
    AuthenticatedUserService authenticatedUserService;

    @Autowired
    RecFriendService recFriendService;

    @GetMapping("/friends")
    public ModelAndView viewFriends() {
        User currentUser =  authenticatedUserService.getAuthenticatedUser();
        recFriendService.generateAndStoreRecommendations();
        Set<User> allFriends = currentUser.getFriends();
        Iterable<FriendRequest> incomingRequests = friendRequestRepository.findByReceiverAndPendingTrue(currentUser);
        List<RecFriend> recommendedFriends = recFriendService.getRecommendationsForCurrentUser();

        ModelAndView mav = new ModelAndView("friends");
        List<User> limitedFriendsForSidebar = new ArrayList<>(allFriends);
        limitedFriendsForSidebar = limitedFriendsForSidebar.stream()
                .limit(5)
                .collect(Collectors.toList());
        mav.addObject("friendsCount", allFriends.size());
        mav.addObject("incomingRequests", incomingRequests);
        mav.addObject("recommendedFriends", recommendedFriends);
        mav.addObject("sidebarFriends", limitedFriendsForSidebar);
        mav.addObject("currentUser", currentUser);
        mav.addObject("allFriends", allFriends);
        return mav;
    }

    @PostMapping("/friend-requests/send")
    public ModelAndView sendFriendRequest(@RequestParam("receiverId") Long receiverId) {
        User sender = authenticatedUserService.getAuthenticatedUser();
        User receiver = userRepository.findById(receiverId)
                .orElseThrow(() -> new RuntimeException("Receiver not found"));

        FriendRequest request = new FriendRequest();
        request.setSender(sender);
        request.setReceiver(receiver);
        request.setPending(true);

        friendRequestRepository.save(request);

        return new ModelAndView("redirect:/profile/" + receiverId);
    }

    @PostMapping("/friend-requests/withdraw")
    public ModelAndView withdrawFriendRequest(@RequestParam("receiverId") Long receiverId) {
        User sender = authenticatedUserService.getAuthenticatedUser();
        User receiver = userRepository.findById(receiverId)
                .orElseThrow(() -> new RuntimeException("Receiver not found"));

        FriendRequest request = friendRequestRepository
                .findBySenderAndReceiverAndPendingTrue(sender, receiver);

        if (request != null) {
            friendRequestRepository.delete(request);
        }

        return new ModelAndView("redirect:/profile/" + receiverId);
    }

    @PostMapping("/friend-requests/accept")
    public ModelAndView acceptFriendRequest(@RequestParam Long requestId) {
        FriendRequest request = friendRequestRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Friend request not found"));

        User sender = request.getSender();
        User receiver = request.getReceiver();

        sender.getFriends().add(receiver);
        receiver.getFriends().add(sender);

        userRepository.save(sender);
        userRepository.save(receiver);

        request.setPending(false);
        friendRequestRepository.save(request);

        return new ModelAndView("redirect:/friends");
    }

    @PostMapping("/friend-requests/decline")
    public ModelAndView declineFriendRequest(@RequestParam Long requestId) {
        FriendRequest request = friendRequestRepository.findById(requestId)
                .orElseThrow(() -> new RuntimeException("Friend request not found"));

        friendRequestRepository.delete(request);
        return new ModelAndView("redirect:/friends");
    }

    @PostMapping("/friends/remove")
    public ModelAndView removeFriend(@RequestParam Long friendId, HttpServletRequest request) {
        User currentUser = authenticatedUserService.getAuthenticatedUser();
        User friend = userRepository.findById(friendId)
                .orElseThrow(() -> new RuntimeException("Friend not found"));

        currentUser.getFriends().remove(friend);
        friend.getFriends().remove(currentUser);

        userRepository.save(currentUser);
        userRepository.save(friend);

        // Get the Referer header (the previous page URL)
        String referer = request.getHeader("Referer");
        if (referer == null || referer.isEmpty()) {
            // Fallback if no referer present
            referer = "/friends";
        }

        return new ModelAndView("redirect:" + referer);
    }
}