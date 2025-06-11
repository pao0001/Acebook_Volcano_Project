package com.makersacademy.acebook.repository;

import com.makersacademy.acebook.model.RecFriend;
import com.makersacademy.acebook.model.User;
import org.springframework.data.repository.CrudRepository;

import java.util.List;

public interface RecFriendRepository extends CrudRepository<RecFriend, Long> {
    List<RecFriend> findByUser(User user);
    void deleteByUser(User user);
}
