package com.makersacademy.acebook.feature;

import com.github.javafaker.Faker;
import org.junit.jupiter.api.*;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class FriendsSearchTest {

    private WebDriver driver;
    private Faker faker;
    private WebDriverWait wait;

    @BeforeAll
    public void setupClass() {
        System.setProperty("webdriver.chrome.driver", "/usr/local/bin/chromedriver");
    }

    @BeforeEach
    public void setup() {
        driver = new ChromeDriver();
        wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        faker = new Faker();
    }

    @AfterEach
    public void tearDown() {
        if (driver != null) {
            driver.quit();
        }
    }

    @Test
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
        // Signed in
        driver.findElement(By.linkText("Friends")).click();
        WebElement searchInput = driver.findElement(By.name("query"));
        searchInput.sendKeys("Foster");
        driver.findElement(By.cssSelector("form[action='/friends/search'] button[type='submit']")).click();
        wait.until(ExpectedConditions.urlContains("/profile/9"));
        Assertions.assertTrue(driver.getCurrentUrl().contains("/profile/9"),
                "Expected to be redirected to /profile/9 page after searching 'Foster'");
    }
}