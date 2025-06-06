package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import com.makersacademy.acebook.service.AuthenticatedUserService;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.web.servlet.MockMvc;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.multipart;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("test")
class UploadControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private AuthenticatedUserService authenticatedUserService;

    @MockBean
    private UserRepository userRepository;

    @Value("${upload.profile}")
    private String profileUploadDir;

    private User testUser;

    @BeforeEach
    void setUp() {
        // Create user without builder
        testUser = new User();
        testUser.setAuthId("testAuth123");
        testUser.setProfile_image_src(null);

        when(authenticatedUserService.getAuthenticatedUser()).thenReturn(testUser);
    }

    @Test
    void uploadProfileImage_Success() throws Exception {
        MockMultipartFile mockFile = new MockMultipartFile(
                "image",
                "test.png",
                "image/png",
                "test image content".getBytes()
        );

        mockMvc.perform(multipart("/uploadProfileImage")
                        .file(mockFile))
                .andExpect(status().is3xxRedirection())
                .andExpect(redirectedUrl("/myProfile"));

        verify(authenticatedUserService).getAuthenticatedUser();
        verify(userRepository).save(any(User.class));
    }

    // Other test methods remain the same...
    private void cleanupTestFiles() throws IOException {
        Path testUploadPath = Paths.get(profileUploadDir);
        if (Files.exists(testUploadPath)) {
            Files.walk(testUploadPath)
                    .map(Path::toFile)
                    .forEach(File::delete);
            Files.deleteIfExists(testUploadPath);
        }
    }
}