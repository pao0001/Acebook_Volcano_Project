package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.FriendRequest;
import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.FriendRequestRepository;
import com.makersacademy.acebook.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.oidc.user.DefaultOidcUser;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import java.util.Set;

//SEE IF YOU CAN GET THE AUTHENTICATION METHOD TO REMOVE REPETITION!!!!1!

@RestController
public class FriendsController {
    @Autowired
    UserRepository userRepository;

    @Autowired
    FriendRequestRepository friendRequestRepository;

    @GetMapping("/friends")
    public ModelAndView viewFriends() {
        DefaultOidcUser principal = (DefaultOidcUser) SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getPrincipal();
        String username = (String) principal.getAttributes().get("email");

        User currentUser = userRepository.findUserByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        Set<User> friends = currentUser.getFriends();

        // Fetch incoming friend requests where the current user is the receiver and pending is true
        Iterable<FriendRequest> incomingRequests = friendRequestRepository.findByReceiverAndPendingTrue(currentUser);

        ModelAndView mav = new ModelAndView("friends");
        mav.addObject("friends", friends);
        mav.addObject("friendsCount", friends.size());
        mav.addObject("incomingRequests", incomingRequests);
        return mav;
    }


    @PostMapping("/friend-requests/send")
    public ModelAndView sendFriendRequest(@RequestParam("receiverId") Long receiverId) {
        DefaultOidcUser principal = (DefaultOidcUser) SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getPrincipal();
        String currentUsername = (String) principal.getAttributes().get("email");

        User sender = userRepository.findUserByUsername(currentUsername)
                .orElseThrow(() -> new RuntimeException("User not found"));

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
        DefaultOidcUser principal = (DefaultOidcUser) SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getPrincipal();
        String currentUsername = (String) principal.getAttributes().get("email");

        User sender = userRepository.findUserByUsername(currentUsername)
                .orElseThrow(() -> new RuntimeException("User not found"));

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
    public ModelAndView removeFriend(@RequestParam Long friendId) {
        DefaultOidcUser principal = (DefaultOidcUser) SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getPrincipal();
        String currentUsername = (String) principal.getAttributes().get("email");

        User currentUser = userRepository.findUserByUsername(currentUsername)
                .orElseThrow(() -> new RuntimeException("User not found"));

        User friend = userRepository.findById(friendId)
                .orElseThrow(() -> new RuntimeException("Friend not found"));

        currentUser.getFriends().remove(friend);
        friend.getFriends().remove(currentUser);

        userRepository.save(currentUser);
        userRepository.save(friend);

        return new ModelAndView("redirect:/friends");
    }
}
