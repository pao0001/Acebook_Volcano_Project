package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.config.ContactMail;
import com.makersacademy.acebook.model.Contact;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

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
}


