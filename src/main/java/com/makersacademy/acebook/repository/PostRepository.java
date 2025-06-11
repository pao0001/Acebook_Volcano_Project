package com.makersacademy.acebook.repository;

import com.makersacademy.acebook.model.Post;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface PostRepository extends CrudRepository<Post, Long> {
    @Query(
            value = """
        SELECT p.*
        FROM posts p
        WHERE p.user_id = :currentUserId
           OR p.user_id IN (
                 SELECT friend_id
                 FROM friends
                 WHERE user_id = :currentUserId
             )
        """,
            nativeQuery = true
    )
    List<Post> findFeedNative(@Param("currentUserId") Long currentUserId);
}

