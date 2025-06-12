package com.makersacademy.acebook.service;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.model.RecFriend;
import com.makersacademy.acebook.repository.RecFriendRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service
public class RecFriendService {

    @Autowired
    private final RecFriendRepository recFriendRepository;

    private final AuthenticatedUserService authenticatedUserService;

    public RecFriendService (AuthenticatedUserService authenticatedUserService,
                                       RecFriendRepository recFriendRepository) {
        this.authenticatedUserService = authenticatedUserService;
        this.recFriendRepository = recFriendRepository;
    }

    public void generateAndStoreRecommendations() {
        User currentUser = authenticatedUserService.getAuthenticatedUser();
        Set<User> currentFriends = currentUser.getFriends();

        Map<User, Integer> mutualCountMap = new HashMap<>();

        for (User friend : currentFriends) {
            for (User friendsFriend : friend.getFriends()) {
                if (friendsFriend.equals(currentUser)) continue;
                if (currentFriends.contains(friendsFriend)) continue;

                mutualCountMap.put(
                        friendsFriend,
                        mutualCountMap.getOrDefault(friendsFriend, 0) + 1
                );
            }
        }

        // Remove old recommendations
        recFriendRepository.deleteByUser(currentUser);

        // Save new ones
        for (Map.Entry<User, Integer> entry : mutualCountMap.entrySet()) {
            RecFriend rec = new RecFriend(currentUser, entry.getKey(), entry.getValue());
            recFriendRepository.save(rec);
        }
    }

    public List<RecFriend> getRecommendationsForCurrentUser() {
        User currentUser = authenticatedUserService.getAuthenticatedUser();
        return recFriendRepository.findByUser(currentUser);
    }
}
