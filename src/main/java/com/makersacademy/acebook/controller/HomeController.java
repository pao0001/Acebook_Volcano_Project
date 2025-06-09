package com.makersacademy.acebook.controller;//package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.security.Principal;
import java.util.Optional;


@Controller
public class HomeController {
    @GetMapping("/welcome")
    public String welcome() {
        return "welcome"; // This refers to the template "welcome.html"
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
