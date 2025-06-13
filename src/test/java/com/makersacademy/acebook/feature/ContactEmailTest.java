package com.makersacademy.acebook.feature;

import com.github.javafaker.Faker;
import org.junit.jupiter.api.*;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.*;
import java.time.Duration;

@TestInstance(TestInstance.Lifecycle.PER_CLASS)
public class ContactEmailTest {

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
    public void contactForm_SubmitsSuccessfully() {
        driver.get("http://localhost:8080/welcome");

        // Go to contact page
        driver.findElement(By.linkText("Contact Us")).click();

        // Fill in contact form fields
        String name = faker.name().fullName();
        String email = faker.internet().emailAddress();
        String message = faker.lorem().paragraph();

        wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("name"))).sendKeys(name);
        driver.findElement(By.name("email")).sendKeys(email);
        driver.findElement(By.name("message")).sendKeys(message);

        // Submit the form
        driver.findElement(By.cssSelector("form button[type='submit']")).click();

        // Assert redirect or success (e.g., /contact?success or a message)
        wait.until(ExpectedConditions.urlContains("/contact?success"));

        Assertions.assertTrue(driver.getCurrentUrl().contains("/contact?success"),
                "Expected to be redirected to /contact?success");
    }
}