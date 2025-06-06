package com.makersacademy.acebook.repository;

import com.makersacademy.acebook.model.Comment;
import com.makersacademy.acebook.model.User;
import org.springframework.data.repository.CrudRepository;

import java.util.Optional;

public interface CommentRepository extends CrudRepository<Comment, Long> {
    public Optional<Comment> findCommentByUsername(String username);
    public Optional<Comment> findCommentByPostID(Integer postID);

}
