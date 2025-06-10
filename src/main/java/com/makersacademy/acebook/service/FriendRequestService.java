package com.makersacademy.acebook.service;

import com.makersacademy.acebook.model.FriendRequest;
import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.FriendRequestRepository;
import com.makersacademy.acebook.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional; // For "transactional" operations

import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class FriendRequestService {

    @Autowired
    private FriendRequestRepository friendRequestRepo;

    @Autowired
    private UserRepository userRepository; // Need UserRepository to update User's friends list

    @Transactional
    public void sendFriendRequest(User sender, User receiver) {
        // Stops users from sending requests to themselves
        if (sender.equals(receiver)) {
            throw new IllegalArgumentException("Cannot send a friend request to yourself.");
        }

        // Check if a request already exists in either direction
        if (
                friendRequestRepo.existsBySenderAndReceiverAndPendingTrue(sender, receiver) ||
                        friendRequestRepo.existsBySenderAndReceiverAndPendingTrue(receiver, sender)
        ) {
            return;
        }

        // If they're already friends, do nothign
        if (sender.getFriends().contains(receiver)) {
            return;
        }

        FriendRequest request = new FriendRequest();
        request.setSender(sender);
        request.setReceiver(receiver);
        request.setPending(true); // Explicitly set as pending
        request.setSentAt(LocalDateTime.now()); // Set timestamp

        friendRequestRepo.save(request);
    }

    @Transactional
    public boolean acceptFriendRequest(Long requestId, User acceptingUser) {
        Optional<FriendRequest> optionalRequest = friendRequestRepo.findById(requestId);

        if (optionalRequest.isPresent()) {
            FriendRequest request = optionalRequest.get();

            //Only the receiver can accept the request
            if (!request.getReceiver().equals(acceptingUser)) {
                throw new SecurityException("Only the receiver of the friend request can accept it.");
            }

            //Check the request is actually pending and not already accepte/rejected
            if (!request.isPending()) {
                return false;
            }

            request.setPending(false);

            // Add sender and receiver as friends
            User sender = request.getSender();
            User receiver = request.getReceiver();
            sender.getFriends().add(receiver);
            receiver.getFriends().add(sender);

            userRepository.save(sender);
            userRepository.save(receiver);

            friendRequestRepo.save(request);

            return true;
        }
        return false;
    }

    @Transactional
    public boolean rejectFriendRequest(Long requestId, User rejectingUser) {
        Optional<FriendRequest> optionalRequest = friendRequestRepo.findById(requestId);

        if (optionalRequest.isPresent()) {
            FriendRequest request = optionalRequest.get();

            if (!request.getReceiver().equals(rejectingUser)) {
                throw new SecurityException("Only the receiver of the friend request can reject it.");
            }

            if (!request.isPending()) {
                return false;
            }

            // Removes request from table when rejected
            friendRequestRepo.delete(request);

            return true;
        }
        return false;
    }
}