package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import com.makersacademy.acebook.service.AuthenticatedUserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import static org.mockito.Mockito.*;
import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(MockitoExtension.class)
class UploadControllerUnitTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private AuthenticatedUserService authenticatedUserService;

    @InjectMocks
    private UploadController uploadController;

    private final String testUploadDir = "test-uploads";

    @BeforeEach
    void setUp() {
        ReflectionTestUtils.setField(uploadController, "profileUploadDir", testUploadDir);
    }

    @Test
    void handleImageUpload_Success() throws IOException {
        // Create user without builder
        User user = new User();
        user.setAuthId("auth123");
        user.setProfile_image_src(null);

        MultipartFile mockFile = new MockMultipartFile(
                "image",
                "test.png",
                "image/png",
                "test image content".getBytes()
        );

        when(authenticatedUserService.getAuthenticatedUser()).thenReturn(user);
        when(userRepository.save(any(User.class))).thenReturn(user);

        String result = uploadController.handleImageUpload(mockFile);

        assertEquals("redirect:/myProfile", result);
        verify(authenticatedUserService).getAuthenticatedUser();
        verify(userRepository).save(user);

        cleanupTestFiles();
    }

    // Other test methods remain the same...
    private void cleanupTestFiles() throws IOException {
        Path testUploadPath = Paths.get(testUploadDir);
        if (Files.exists(testUploadPath)) {
            Files.walk(testUploadPath)
                    .map(Path::toFile)
                    .forEach(File::delete);
            Files.deleteIfExists(testUploadPath);
        }
    }
}