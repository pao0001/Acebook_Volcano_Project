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

import static org.junit.jupiter.api.Assertions.assertEquals;

public class SignUpTest {

    WebDriver driver;
    Faker faker;
    WebDriverWait wait;

    @BeforeEach
    public void setup() {
        System.setProperty("webdriver.chrome.driver", "/usr/local/bin/chromedriver");
        driver = new ChromeDriver();
        faker = new Faker();
        wait = new WebDriverWait(driver, Duration.ofSeconds(10));
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
        String greetingText = driver.findElement(By.id("greeting")).getText();

        assertEquals("Signed in as " + email, greetingText);
    }
}
