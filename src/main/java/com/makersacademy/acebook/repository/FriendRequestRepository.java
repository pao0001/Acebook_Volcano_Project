package com.makersacademy.acebook.repository;

import com.makersacademy.acebook.model.FriendRequest;
import com.makersacademy.acebook.model.User;
import org.springframework.data.repository.CrudRepository;

public interface FriendRequestRepository extends CrudRepository<FriendRequest, Long> {
    // Checks a friend request exists between 2 users
    boolean existsBySenderAndReceiverAndPendingTrue(User sender, User receiver);

    // Finds a friend request based on who sent it
    FriendRequest findBySenderAndReceiverAndPendingTrue(User sender, User receiver);

    // Finds all of a users incoming friend requests
    Iterable<FriendRequest> findByReceiverAndPendingTrue(User receiver);

    // Finds confirmed friend requests
    FriendRequest findBySenderAndReceiverAndPendingFalse(User sender, User receiver);
}