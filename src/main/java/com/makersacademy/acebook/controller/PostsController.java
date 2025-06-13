package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.Comment;
import com.makersacademy.acebook.model.Post;
import com.makersacademy.acebook.model.RecFriend;
import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.CommentRepository;
import com.makersacademy.acebook.repository.PostRepository;
import com.makersacademy.acebook.repository.RecFriendRepository;
import com.makersacademy.acebook.repository.LikeRepository;
import com.makersacademy.acebook.service.AuthenticatedUserService;
import com.makersacademy.acebook.service.RecFriendService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.view.RedirectView;

import java.io.IOException;
import java.sql.SQLOutput;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;

@Controller
public class PostsController {

    @Autowired
    PostRepository postRepository;

    @Autowired
    CommentRepository commentRepository;

    @Autowired
    UploadController uploadController;

    @Autowired
    LikeRepository likeRepository;

    @Autowired
    private AuthenticatedUserService authenticatedUserService;

    @Autowired
    RecFriendRepository recFriendRepository;

    @Autowired
    RecFriendService recFriendService;

//    @GetMapping("/globalfeed")
//    public String index(Model model) {
//        List<Post> recentSortedPosts = StreamSupport.stream(postRepository.findAll().spliterator(), false)
//                .filter(post -> post.getTimeStamp() != null &&
//                        post.getTimeStamp().isAfter(LocalDateTime.now().minusSeconds(3000)))
//                .sorted(Comparator.comparing(Post::getTimeStamp).reversed())
//                .toList();
//
//        List<Comment> comments = (List<Comment>) commentRepository.findAll();
//        Map<Long, List<Comment>> commentsByPostId = comments.stream()
//                .filter(comment -> comment.getTimeStamp() != null &&
//                        comment.getTimeStamp().isAfter(LocalDateTime.now().minusSeconds(600)))
//                .sorted(Comparator.comparing(Comment::getTimeStamp).reversed())
//                .collect(Collectors.groupingBy(comment -> comment.getPostID().longValue()));
//
//        model.addAttribute("commentsByPostId", commentsByPostId);
//        model.addAttribute("posts", recentSortedPosts);
//        model.addAttribute("post", new Post());
//
//        // For posts
//        Map<Long, Long> postLikeCounts = new HashMap<>();
//        for (Post post : recentSortedPosts) {
//            long count = likeRepository.countByLikedTypeAndLikedId("post", post.getId());
//            postLikeCounts.put(post.getId(), count);
//        }
//        model.addAttribute("likeCountsByPostId", postLikeCounts);
//
//        // For comments
//        Map<Long, Long> commentLikeCounts = new HashMap<>();
//        for (Comment comment : comments) {
//            long count = likeRepository.countByLikedTypeAndLikedId("comment", comment.getId());
//            commentLikeCounts.put(comment.getId(), count);
//        }
//        model.addAttribute("likeCountsByCommentId", commentLikeCounts);
//
//        // Adding attribute comments
//        model.addAttribute("comments", comments);
//        model.addAttribute("comment", new Comment());
//
//        // Adding attribute current user
//        User currentUser = authenticatedUserService.getAuthenticatedUser();
//        model.addAttribute("currentUser", currentUser);
//
//        // Adding attribute friends
//        Set<User> friends = currentUser.getFriends();
//        model.addAttribute("friends", friends);
//
//        // Add suggested friends
//        List<RecFriend> recommendedFriends = recFriendRepository.findByUser(currentUser);
//        model.addAttribute("recommendedFriends", recommendedFriends);
//
//        Set<User> allFriendsForSidebar = currentUser.getFriends();
//        List<User> limitedFriendsForSidebar = new ArrayList<>(allFriendsForSidebar);
//        limitedFriendsForSidebar.sort(Comparator.comparing(User::getForename).thenComparing(User::getSurname));
//        limitedFriendsForSidebar = limitedFriendsForSidebar.stream()
//                .limit(5)
//                .collect(Collectors.toList());
//        model.addAttribute("sidebarFriends", limitedFriendsForSidebar);
//
//        return "posts/globalfeed";
//    }

    @PostMapping("/posts")
    public RedirectView createPost(@ModelAttribute Post post,
                                   @RequestParam(value = "image", required = false)MultipartFile image,
                                   @RequestParam String username, @RequestParam Integer user_id,
                                   @RequestParam String forename, @RequestParam String surname) throws IOException {
        post.setTimeStamp(LocalDateTime.now());
        post.setUsername(username);
        post.setUserID(user_id);
        post.setForename(forename);
        post.setSurname(surname);


        Post savedPost = postRepository.save(post);

        if (image != null && !image.isEmpty()) {
            uploadController.handlePostImageUpload(savedPost.getId(), image);
        }

        return new RedirectView("/");
    }

    @PostMapping("/comment")
    @ResponseBody
    public ResponseEntity<Comment> createComment(@ModelAttribute Comment comment,
                                      @RequestParam String username,
                                      @RequestParam Integer postID,
                                      @RequestParam String forename, @RequestParam String surname) {
        comment.setTimeStamp(LocalDateTime.now());
        comment.setUsername(username);
        comment.setSurname(surname);
        comment.setForename(forename);
        comment.setPostID(postID);
        // You'll need to format the timestamp here or ensure your Comment model has a getter for a formatted one
        // For example: comment.setFormattedTimestamp(LocalDateTime.now().format(DateTimeFormatter.ofPattern("HH:mm - dd/MM/yyyy")));
        Comment savedComment = commentRepository.save(comment);

        // Return the saved comment as JSON. Ensure the Comment object can be serialized to JSON.
        // If your Comment model has a 'formattedTimestamp' field, it will be included in the JSON.
        return ResponseEntity.ok(savedComment);
    }

    @GetMapping("/")
    public String feed(Model model) {

        List<Comment> comments = (List<Comment>) commentRepository.findAll();
        Map<Long, List<Comment>> commentsByPostId = comments.stream()
                .sorted(Comparator.comparing(Comment::getTimeStamp))
                .collect(Collectors.groupingBy(comment -> comment.getPostID().longValue()));

        model.addAttribute("commentsByPostId", commentsByPostId);

        Long myId = authenticatedUserService.getAuthenticatedUser().getId();
        List<Post> feedPosts = postRepository.findFeedNative(myId).stream()
                .sorted(Comparator.comparing(Post::getTimeStamp).reversed())
                .toList();

        model.addAttribute("posts", feedPosts);
        model.addAttribute("post", new Post());

        model.addAttribute("comments", comments);
        model.addAttribute("comment", new Comment());

        User currentUser = authenticatedUserService.getAuthenticatedUser();
        model.addAttribute("currentUser", currentUser);

        Set<User> allFriendsForSidebar = currentUser.getFriends();
        List<User> limitedFriendsForSidebar = new ArrayList<>(allFriendsForSidebar);
        limitedFriendsForSidebar.sort(Comparator.comparing(User::getForename).thenComparing(User::getSurname));
        limitedFriendsForSidebar = limitedFriendsForSidebar.stream()
                .limit(5)
                .collect(Collectors.toList());
        model.addAttribute("sidebarFriends", limitedFriendsForSidebar);

        recFriendService.generateAndStoreRecommendations();
        List<RecFriend> recommendedFriends = recFriendService.getRecommendationsForCurrentUser();
        model.addAttribute("recommendedFriends", recommendedFriends);
        System.out.println("Recommended friends count: " + recommendedFriends.size());

        // like counts for posts
        Map<Long, Long> likeCountsByPostId = new HashMap<>();
        for (Post post : feedPosts) {
            long count = likeRepository.countByLikedTypeAndLikedId("post", post.getId());
            likeCountsByPostId.put(post.getId(), count);
        }
        model.addAttribute("likeCountsByPostId", likeCountsByPostId);

        // likes count for comments
        Map<Long, Long> likeCountsByCommentId = new HashMap<>();
        for (Comment comment : comments) {
            long count = likeRepository.countByLikedTypeAndLikedId("comment", comment.getId());
            likeCountsByCommentId.put(comment.getId(), count);
        }
        model.addAttribute("likeCountsByCommentId", likeCountsByCommentId);

        return "posts/friendsfeed";
    }
}
