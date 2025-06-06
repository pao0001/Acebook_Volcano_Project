package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.Comment;
import com.makersacademy.acebook.model.Post;
import com.makersacademy.acebook.repository.CommentRepository;
import com.makersacademy.acebook.repository.PostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.RedirectView;

import java.sql.SQLOutput;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;

@Controller
public class PostsController {
    @Autowired
    PostRepository postRepository;

    @Autowired
    CommentRepository commentRepository; // Make sure you have this

    @GetMapping("/")
    public String index(Model model) {
        Iterable<Post> posts = postRepository.findAll();
        List<Comment> comments = (List<Comment>) commentRepository.findAll();
//        comments.removeIf(comment -> comment.getTimeStamp() == null);
//        comments.sort(Comparator.comparing(Comment::getTimeStamp).reversed());

        model.addAttribute("posts", posts);
        model.addAttribute("post", new Post());

        model.addAttribute("comments", comments);
        model.addAttribute("comment", new Comment());

        return "posts/index";
    }

    @PostMapping("/posts")
    public RedirectView createPost(@ModelAttribute Post post) {
        postRepository.save(post);
        return new RedirectView("/");
    }

    @PostMapping("/comment")
    public RedirectView createComment(@ModelAttribute Comment comment,
                                      @RequestParam String username,
                                      @RequestParam Integer postID) {
        comment.setTimeStamp(LocalDateTime.now());
        comment.setUsername(username);
        comment.setPostID(postID);
        commentRepository.save(comment);
        return new RedirectView("/");
    }

}
