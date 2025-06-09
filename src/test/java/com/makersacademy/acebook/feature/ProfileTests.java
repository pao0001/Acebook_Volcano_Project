package com.makersacademy.acebook.feature;

import com.github.javafaker.Faker;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

import static org.junit.Assert.assertTrue;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class ProfileTests {

    WebDriver driver;
    Faker faker;
    WebDriverWait wait;

    @BeforeEach
    public void setup() {
        System.setProperty("webdriver.chrome.driver", "/usr/local/bin/chromedriver");
        driver = new ChromeDriver();
        faker = new Faker();
        wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        signUpUser();
    }

    @AfterEach
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }

    // Reusable helper methods

    // signs up new user with email and password
    public void signUpUser() {
        String email = faker.name().username() + "@email.com";

        driver.get("http://localhost:8080/");
        driver.findElement(By.linkText("Sign up")).click();
        driver.findElement(By.name("email")).sendKeys(email);
        driver.findElement(By.name("password")).sendKeys("P@55qw0rd");
        driver.findElement(By.name("action")).click();
        /* next line is optional, it adds a wait for second button ('accept') to
        become clickable as this keeps throwing a stale element error when
        Fran tries to run this test */
        WebElement secondActionButton = wait.until(
                ExpectedConditions.elementToBeClickable(By.name("action")));
        secondActionButton.click();
    }

    @Test // profile should only be accessible when logged in
    public void profilePageAccessibleWhenLoggedIn() {

        // setting user to id 2 (Taylor Swift)
        String userId = "2";

        // navigates to user's profile
        driver.get("http://localhost:8080/profile/" + userId);

        // assert URL is the profile page
        assertTrue(driver.getCurrentUrl().endsWith("/profile/" + userId));
    }

    @Test // profile Should display another user's info by id
    public void profilePageDisplaysOtherUserData() {

        // setting user to id 2 (Taylor Swift)
        String userId = "2";

        // expected data for Taylor Swift
        String expectedForename = "Taylor";
        String expectedSurname = "Swift";
        String expectedDescription = "writing songs in lowercase & living eras one heartbreak at a time.";

        // navigates to user's profile
        driver.get("http://localhost:8080/profile/" + userId);

        // waits for fields to become visible
        WebElement forenameSpan = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("forename")));
        WebElement surnameSpan = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("surname")));
        WebElement descriptionSpan = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("description")));

        // assert the displayed user info matches expected data for Taylor Swift
        assertEquals(expectedForename, forenameSpan.getText());
        assertEquals(expectedSurname, surnameSpan.getText());
        assertEquals(expectedDescription, descriptionSpan.getText());
    }

    @Test // profile should not display invalid user
    public void profilePageGives404ForInvalidUser() {

        // setting invalid user id
        String invalidUserId = "999999";

        // getting profile page for invalid id
        driver.get("http://localhost:8080/profile/" + invalidUserId);

        // checking if page displays 404 message or error text
        String pageSource = driver.getPageSource();
        assertTrue("Page should show 404 or error message",
                pageSource.contains("404") || pageSource.contains("User not found") || pageSource.contains("error"));
    }
}