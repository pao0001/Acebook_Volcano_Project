package com.makersacademy.acebook.service;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.model.RecFriend;
import com.makersacademy.acebook.repository.RecFriendRepository;
import jakarta.transaction.Transactional;
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

    @Transactional
    public void generateAndStoreRecommendations() {
        User currentUser = authenticatedUserService.getAuthenticatedUser();
        Set<User> currentFriends = currentUser.getFriends();
        System.out.println("Current user friends count: " + currentFriends.size());

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
        System.out.println("Current user in generateAndStoreRecommendations: " + currentUser.getUsername());

        for (User friend : currentFriends) {
            for (User friendsFriend : friend.getFriends()) {
                System.out.println("Checking friend-of-friend: " + friendsFriend.getUsername());
                if (friendsFriend.equals(currentUser)) {
                    System.out.println("  Skipping self");
                    continue;
                }
                if (currentFriends.contains(friendsFriend)) {
                    System.out.println("  Skipping existing friend: " + friendsFriend.getUsername());
                    continue;
                }

                mutualCountMap.put(
                        friendsFriend,
                        mutualCountMap.getOrDefault(friendsFriend, 0) + 1
                );
                System.out.println("  Added recommendation candidate: " + friendsFriend.getUsername());
            }
        }
        System.out.println("Recommendation candidates map size: " + mutualCountMap.size());

    }

    public List<RecFriend> getRecommendationsForCurrentUser() {
        User currentUser = authenticatedUserService.getAuthenticatedUser();
        System.out.println("Current user in getRecommendationsForCurrentUser: " + currentUser.getUsername());
        return recFriendRepository.findByUser(currentUser);
    }
}
