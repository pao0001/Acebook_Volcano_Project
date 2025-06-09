package com.makersacademy.acebook.controller;

import com.makersacademy.acebook.model.User;
import com.makersacademy.acebook.repository.UserRepository;
import com.makersacademy.acebook.service.AuthenticatedUserService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.*;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

class UploadControllerTest {

    @InjectMocks
    private UploadController uploadController;

    @Mock
    private UserRepository userRepository;

    @Mock
    private AuthenticatedUserService authenticatedUserService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);

        // Set the upload directory for testing - you can point to a temp folder or any folder
        uploadController.profileUploadDir = "target/test-uploads/";
    }

    @Test
    void testHandleImageUpload_success() throws IOException {
        // Prepare mock user
        User mockUser = new User();
        mockUser.setAuthId("testUser123");
        when(authenticatedUserService.getAuthenticatedUser()).thenReturn(mockUser);

        // Prepare mock MultipartFile with some content and a filename
        byte[] content = "dummy image content".getBytes();
        MultipartFile mockFile = new MockMultipartFile("image", "profile.png", "image/png", content);

        // Call the method under test
        String result = uploadController.handleProfileImageUpload(mockFile);

        // Verify redirect URL
        assertEquals("redirect:/myProfile", result);

        // Verify userRepository.save() was called once
        verify(userRepository, times(1)).save(mockUser);

        // Verify the profile_image_src was set correctly
        String expectedPath = uploadController.profileUploadDir + "testUser123.png";
        assertEquals(expectedPath, mockUser.getProfile_image_src());

        // Cleanup: delete the test uploaded file
        File uploadedFile = new File(expectedPath);
        if (uploadedFile.exists()) {
            uploadedFile.delete();
        }
    }

    @Test
    void testHandleImageUpload_emptyFile() throws IOException {
        MultipartFile emptyFile = new MockMultipartFile("image", new byte[0]);

        String result = uploadController.handleProfileImageUpload(emptyFile);

        assertEquals("redirect:/myProfile?error=empty", result);

        verifyNoInteractions(authenticatedUserService);
        verifyNoInteractions(userRepository);
    }
}
