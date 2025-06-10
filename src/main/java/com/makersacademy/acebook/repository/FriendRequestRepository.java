package com.makersacademy.acebook.repository;

import com.makersacademy.acebook.model.FriendRequest;
import com.makersacademy.acebook.model.User;
import org.springframework.data.repository.CrudRepository; // CHANGED: Using JpaRepository
import org.springframework.stereotype.Repository;

import java.util.Set; // ADDED: Import Set

@Repository
public interface FriendRequestRepository extends CrudRepository<FriendRequest, Long> { // CHANGED: Extend JpaRepository
    boolean existsBySenderAndReceiverAndPendingTrue(User sender, User receiver);
    boolean existsByReceiverAndSenderAndPendingTrue(User receiver, User sender);
    FriendRequest findBySenderAndReceiverAndPendingTrue(User sender, User receiver);
    Set<FriendRequest> findByReceiverAndPendingTrue(User receiver);
    Set<FriendRequest> findBySenderAndPendingTrue(User sender);
}