package com.makersacademy.acebook.controller;


import com.makersacademy.acebook.config.ContactMail;
import com.makersacademy.acebook.model.Contact;
import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

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

    // EMAIL FUNCTION
    @Autowired
    private ContactMail mail;

    @PostMapping("/contact")
    public String submitContactForm(@ModelAttribute Contact contact) {
        mail.sendEmail(contact);  // call on the instance, NOT the class
        return "redirect:/contact?success";
    }

    //Everything below is to do with entering name, surname and DOB after signup.
    @Autowired
    private UserRepository userRepository;


    @GetMapping("/checkDetails")
    public String checkDetails(Principal principal, Model model){
        String authID = principal.getName();
        User user = userRepository.findUserByAuthId(authID)
                .orElseThrow(()-> new RuntimeException("User not Found"));
        boolean isIncomplete =
                (user.getForename() == null || user.getForename().isBlank()) ||
                (user.getSurname() == null || user.getSurname().isBlank()) ||
                (user.getDob() == null);

//        if (isIncomplete){
//            model.addAttribute(user);
//            return "completeDetails";
//        }
        return "redirect:/";
    }



}


