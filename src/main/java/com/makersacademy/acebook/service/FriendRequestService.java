package com.makersacademy.acebook.service;

import com.makersacademy.acebook.model.FriendRequest;
import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.FriendRequestRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class FriendRequestService {
    @Autowired
    private FriendRequestRepository friendRequestRepo;

    public void sendFriendRequest(User sender, User receiver) {
        // Avoid duplicates, custom CRUD method in repository
        if (friendRequestRepo.existsBySenderAndReceiverAndPendingTrue(sender, receiver)) return;

        FriendRequest request = new FriendRequest();
        request.setSender(sender);
        request.setReceiver(receiver);
        request.setPending(true);
        request.setSentAt(LocalDateTime.now());

        friendRequestRepo.save(request);
    }
}

