package com.makersacademy.acebook.feature;

import com.github.javafaker.Faker;
import org.junit.jupiter.api.*;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.*;

import java.time.Duration;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class PostsControllerTest {

    WebDriver driver;
    Faker faker;
    WebDriverWait wait;

    @BeforeEach
    public void setup() {
        System.setProperty("webdriver.chrome.driver", "/usr/local/bin/chromedriver");
        driver = new ChromeDriver();
        wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        faker = new Faker();
    }

    @AfterEach
    public void tearDown() {
        driver.quit();
    }

    @Test // Signing in
        // ADD BELOW TO EACH TEST TO ALLOW AUTHENTICATION
    public void successfulSignUpAlsoLogsInUser() {
        String email = faker.name().username() + "@email.com";
        driver.get("http://localhost:8080/");
        driver.findElement(By.linkText("Sign up")).click();
        driver.findElement(By.name("email")).sendKeys(email);
        driver.findElement(By.name("password")).sendKeys("P@55qw0rd");
        driver.findElement(By.name("action")).click();
        WebElement secondActionButton = wait.until(
                ExpectedConditions.elementToBeClickable(By.name("action")));
        secondActionButton.click();
//        String greetingText = driver.findElement(By.id("greeting")).getText();
            // AUTHENTICATION END
//        assertEquals("Signed in as " + email, greetingText);
    }



    @Test // Checking post
    public void checkingPost() {
        String email = faker.name().username() + "@email.com";
        // AUTHENTICATION START
        driver.get("http://localhost:8080/");
        driver.findElement(By.linkText("Sign up")).click();
        driver.findElement(By.name("email")).sendKeys(email);
        driver.findElement(By.name("password")).sendKeys("P@55qw0rd");
        driver.findElement(By.name("action")).click();
        WebElement secondActionButton = wait.until(
                ExpectedConditions.elementToBeClickable(By.name("action")));
        secondActionButton.click();
//        String greetingText = driver.findElement(By.id("greeting")).getText();
        // POST START
        driver.get("http://localhost:8080/");
        driver.findElement(By.id("post-send")).sendKeys("Hello there");
        driver.findElement(By.cssSelector("button.post-submit-button")).click();
        WebElement renderedPost = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("post-render")));
        String testPost = renderedPost.getText();
        assertEquals("Hello there", testPost);

    }


        @Test // Checking Comment
        public void checkingComment() {
            String email = faker.name().username() + "@email.com";
            // AUTHENTICATION START
            driver.get("http://localhost:8080/");
            driver.findElement(By.linkText("Sign up")).click();
            driver.findElement(By.name("email")).sendKeys(email);
            driver.findElement(By.name("password")).sendKeys("P@55qw0rd");
            driver.findElement(By.name("action")).click();
            WebElement secondActionButton = wait.until(
                    ExpectedConditions.elementToBeClickable(By.name("action")));
            secondActionButton.click();
//            String greetingText = driver.findElement(By.id("greeting")).getText();
            // POST START
            driver.get("http://localhost:8080/");
            driver.findElement(By.id("post-send")).sendKeys("Hello there");
            driver.findElement(By.cssSelector("button.post-submit-button")).click();
            WebElement renderedPost = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("post-render")));
            String testPost = renderedPost.getText();
            assertEquals("Hello there", testPost);
            // COMMENT START

            driver.findElement(By.id("comment-send")).sendKeys("Hi again!");
            driver.findElement(By.cssSelector("button.comment-submit-button")).click();
            WebElement renderedComment = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("comment-render")));
            String testComment = renderedComment.getText();
            assertEquals("Hi again!", testComment);
        }
        @Test
        public void checkingPostNotFoundWithoutFriend() {
            // First user signs up and makes a post
            String user1Email = faker.name().username() + "@email.com";
            String user1Password = "P@55qw0rd";

            driver.get("http://localhost:8080/");
            driver.findElement(By.linkText("Sign up")).click();
            driver.findElement(By.name("email")).sendKeys(user1Email);
            driver.findElement(By.name("password")).sendKeys(user1Password);
            driver.findElement(By.name("action")).click();

            WebElement secondActionButton = wait.until(
                    ExpectedConditions.elementToBeClickable(By.name("action"))
            );
            secondActionButton.click();

            driver.get("http://localhost:8080/");
            String postText = "Hello there";
            driver.findElement(By.id("post-send")).sendKeys(postText);
            driver.findElement(By.cssSelector("button.post-submit-button")).click();

            WebElement renderedPost = wait.until(
                    ExpectedConditions.visibilityOfElementLocated(By.id("post-render"))
            );
            assertEquals(postText, renderedPost.getText());

            // ===== LOGOUT =====
            driver.findElement(By.linkText("Logout")).click();

            // ===== SECOND USER SIGNS UP & LOGS IN =====
            String user2Email = faker.name().username() + "@email.com";
            String user2Password = "P@55qw0rd";

            driver.findElement(By.linkText("here")).click();
            driver.findElement(By.linkText("Sign up")).click();
            driver.findElement(By.name("email")).sendKeys(user2Email);
            driver.findElement(By.name("password")).sendKeys(user2Password);
            driver.findElement(By.name("action")).click();
            wait.until(ExpectedConditions.elementToBeClickable(By.name("action"))).click();

            // ===== POST SHOULD NOT BE FOUND =====
            driver.get("http://localhost:8080/");
            List<WebElement> posts = driver.findElements(By.id("post-render"));

            boolean found = posts.stream().anyMatch(el -> el.getText().equals(postText));
            assertFalse(found, "Post by first user should NOT be visible to second user");

    }


}