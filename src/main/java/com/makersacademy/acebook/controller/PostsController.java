package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.Comment;
import com.makersacademy.acebook.model.Post;
import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.CommentRepository;
import com.makersacademy.acebook.repository.PostRepository;
import com.makersacademy.acebook.service.AuthenticatedUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.view.RedirectView;

import java.io.IOException;
import java.sql.SQLOutput;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@Controller
public class PostsController {

    @Autowired
    PostRepository postRepository;

    @Autowired
    CommentRepository commentRepository; // Make sure you have this

    @Autowired
    UploadController uploadController;

    @Autowired
    private AuthenticatedUserService authenticatedUserService;

    @GetMapping("/")
    public String index(Model model) {
        List<Post> recentSortedPosts = StreamSupport.stream(postRepository.findAll().spliterator(), false)
                .filter(post -> post.getTimeStamp() != null &&
                        post.getTimeStamp().isAfter(LocalDateTime.now().minusSeconds(3000)))
                .sorted(Comparator.comparing(Post::getTimeStamp).reversed())
                .toList();


        List<Comment> comments = (List<Comment>) commentRepository.findAll();
        Map<Long, List<Comment>> commentsByPostId = comments.stream()
                .filter(comment -> comment.getTimeStamp() != null &&
                        comment.getTimeStamp().isAfter(LocalDateTime.now().minusSeconds(600)))
                .sorted(Comparator.comparing(Comment::getTimeStamp).reversed())
                .collect(Collectors.groupingBy(comment -> comment.getPostID().longValue()));

        model.addAttribute("commentsByPostId", commentsByPostId);
        model.addAttribute("posts", recentSortedPosts);
        model.addAttribute("post", new Post());

        // Adding attribute comments
        model.addAttribute("comments", comments);
        model.addAttribute("comment", new Comment());

        // Adding attribute current user
        User currentUser = authenticatedUserService.getAuthenticatedUser();
        model.addAttribute("current_user", currentUser);

        // Adding attribute friends
        Set<User> friends = currentUser.getFriends();
        model.addAttribute("friends", friends);

        return "posts/index";
    }

    @PostMapping("/posts")
    public RedirectView createPost(@ModelAttribute Post post,
                                   @RequestParam(value = "image", required = false)MultipartFile image,
                                   @RequestParam String username) throws IOException {
        post.setTimeStamp(LocalDateTime.now());
        post.setUsername(username);

        Post savedPost = postRepository.save(post);

        if (image != null && !image.isEmpty()) {
            uploadController.handlePostImageUpload(savedPost.getId(), image);
        }

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
