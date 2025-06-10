package com.makersacademy.acebook.config;

import com.makersacademy.acebook.model.Contact;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

@Service
public class ContactMail {

    @Autowired
    private JavaMailSender mailSender;

    public void sendEmail(Contact contact) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo("makersbnbgsai@gmail.com");
        message.setSubject("Acebook Support");
        message.setText(
                "Name: " + contact.getName() + "\n" +
                        "Email: " + contact.getEmail() + "\n" +
                        "Message:\n" + contact.getMessage()
        );
        mailSender.send(message);
    }
}