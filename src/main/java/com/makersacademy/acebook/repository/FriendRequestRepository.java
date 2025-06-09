package com.makersacademy.acebook.repository;

import com.makersacademy.acebook.model.FriendRequest;
import com.makersacademy.acebook.model.User;
import org.springframework.data.repository.CrudRepository;

public interface FriendRequestRepository extends CrudRepository<FriendRequest, Long> {
    boolean existsBySenderAndReceiverAndPendingTrue(User sender, User receiver);
    FriendRequest findBySenderAndReceiverAndPendingTrue(User sender, User receiver);
    Iterable<FriendRequest> findByReceiverAndPendingTrue(User receiver);
    FriendRequest findBySenderAndReceiverAndPendingFalse(User sender, User receiver);
}
