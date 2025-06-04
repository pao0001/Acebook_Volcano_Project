package com.makersacademy.acebook.controller;//package com.makersacademy.acebook.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.view.RedirectView;

@Controller
public class HomeController {
    @GetMapping("/welcome")
    public String welcome() {
        return "welcome"; // This refers to the template "welcome.html"
    }
}
