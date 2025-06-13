package com.makersacademy.acebook.controller;


import com.makersacademy.acebook.config.ContactMail;
import com.makersacademy.acebook.model.Contact;
import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.security.Principal;
import java.util.Optional;


@Controller
public class HomeController {
    @GetMapping("/welcome")
    public String welcome() {
        return "welcome"; // This refers to the template "welcome.html"
    }

    @GetMapping("/contact")
    public String Contact() { return "contact";
    }

    @GetMapping("/privacy")
    public String Privacy() { return "privacy";
    }

    // EMAIL FUNCTION
    @Autowired
    private ContactMail mail;

    @PostMapping("/contact")
    public String submitContactForm(@ModelAttribute Contact contact) {
        mail.sendEmail(contact);
        return "redirect:/contact?success";
    }

    //Everything below is to do with entering name, surname and DOB after signup.
    @Autowired
    private UserRepository userRepository;


    @GetMapping("/completeDetails")
    public String checkDetails(Principal principal, Model model){
        String authID = principal.getName();
        User user = userRepository.findUserByAuthId(authID)
                .orElseThrow(()-> new RuntimeException("User not Found"));
        boolean isIncomplete =
                (user.getForename() == null || user.getForename().isBlank()) ||
                (user.getSurname() == null || user.getSurname().isBlank()) ||
                (user.getDob() == null);

        if (isIncomplete){
            model.addAttribute(user);
            return "completeDetails";
        }
        return "redirect:/";
    }

    @PostMapping("/completeDetails")
    public String completeDetails(@ModelAttribute User userUpdates, Principal principal) {
        String authID = principal.getName();
        User existingUser = userRepository.findUserByAuthId(authID)
                .orElseThrow(() -> new RuntimeException("User not Found"));

        // Update the existing user's details with the submitted form data
        existingUser.setForename(userUpdates.getForename());
        existingUser.setSurname(userUpdates.getSurname());
        existingUser.setDob(userUpdates.getDob());

        userRepository.save(existingUser); // Save the updated user to the database

        return "redirect:/"; // Redirect to the homepage or a confirmation page
    }

//       For friends search bar
    @GetMapping("/friends/search")
    public String searchUser(@RequestParam("query") String query, RedirectAttributes model) {
        Optional<User> user = userRepository.findByUsernameIgnoreCase(query);

        if (!user.isPresent()) {
            user = userRepository.findFirstBySurnameIgnoreCase(query);
        }

        if (user.isPresent()) {
            return "redirect:/profile/" + user.get().getId();
        } else {
            model.addFlashAttribute("searchError", "User not found");
            return "redirect:/friends";
            }
    }


}


