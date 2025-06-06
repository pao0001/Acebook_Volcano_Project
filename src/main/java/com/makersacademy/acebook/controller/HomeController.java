package com.makersacademy.acebook.controller;//package com.makersacademy.acebook.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {
    @GetMapping("/welcome")
    public String welcome() {
        return "welcome"; // This refers to the template "welcome.html"
    }
}
