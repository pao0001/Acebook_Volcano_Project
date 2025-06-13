package com.makersacademy.acebook.repository;

import com.makersacademy.acebook.model.Like;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface LikeRepository extends CrudRepository<Like, Long> {
    Optional<Like> findByUserIdAndLikedTypeAndLikedId(Long userId, String likedType, Long likedId);
    long countByLikedTypeAndLikedId(String likedType, Long likedId);
    void deleteByUserIdAndLikedTypeAndLikedId(Long userId, String likedType, Long likedId);
}