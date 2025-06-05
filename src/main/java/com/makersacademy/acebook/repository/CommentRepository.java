package com.makersacademy.acebook.repository;

import com.makersacademy.acebook.model.Comment;
import com.makersacademy.acebook.model.User;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface CommentRepository extends CrudRepository<Comment, Integer> {
    public Optional<Comment> findCommentByUsername(String username);
    public Optional<Comment> findCommentByPostID(int postID);

}
