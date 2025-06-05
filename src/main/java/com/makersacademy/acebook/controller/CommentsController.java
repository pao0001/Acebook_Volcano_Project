package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.Comment;
import com.makersacademy.acebook.repository.CommentRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.servlet.view.RedirectView;

import java.util.Comparator;
import java.util.List;

@Controller
public class CommentsController {

    @Autowired
    CommentRepository repository;

    @GetMapping("/comment")
    public String index(Model model) {
        List<Comment> comments = (List<Comment>) repository.findAll();
        // Sort by timestamp, limit by date
        comments.sort(Comparator.comparing(Comment::getTimeStamp).reversed());
        //
        model.addAttribute("comments", comments);
        model.addAttribute("comment", new Comment());
        return "posts/index";
    }


    @PostMapping("/comment")
    public RedirectView create(@ModelAttribute Comment comment) {
        repository.save(comment);
        return new RedirectView("/");
    }
}
