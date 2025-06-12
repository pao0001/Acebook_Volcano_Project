package com.makersacademy.acebook.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class MvcConfiguration implements WebMvcConfigurer {

    @Value("${upload.profile}")
    private String profileUploadDir;

    @Value("${upload.posts}")
    private String postsUploadDir;

    @Value("${upload.banner}")
    private String bannerUploadDir;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/uploads/profile/**")
                .addResourceLocations("file:" + profileUploadDir);
        registry.addResourceHandler("/uploads/posts/**")
                .addResourceLocations("file:" + postsUploadDir);
        registry.addResourceHandler("/uploads/banner/**")
                .addResourceLocations("file:" + bannerUploadDir);
    }
}