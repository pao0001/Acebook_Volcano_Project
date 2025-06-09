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

public class MyProfileTests {

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

    @Test // myProfile should only be accessible when logged in
    public void myProfileAccessibleWhenLoggedIn() {
        // creates fake forename
        String forename = faker.name().firstName();

        // from sign up helper method
        signUpUser();

        // gets myProfile page
        driver.get("http://localhost:8080/myProfile");

        // asserts url is correct
        assertTrue(driver.getCurrentUrl().endsWith("/myProfile"));
    }

    @Test // myProfile should display logged-in user's info
    public void myProfileDisplaysUserData() {

        // from sign up helper method
        signUpUser();

        // test data
        String forename = faker.name().firstName();
        String surname = faker.name().lastName();
        String description = faker.lorem().sentence();

        // gets myProfile page
        driver.get("http://localhost:8080/myProfile");

        // Forename
        WebElement forenameInput = wait.until(ExpectedConditions.elementToBeClickable(By.id("forename")));
        forenameInput.clear();
        forenameInput.sendKeys(forename);
        driver.findElement(By.id("update forename")).click();

        // Surname
        driver.get("http://localhost:8080/myProfile");
        WebElement surnameInput = wait.until(ExpectedConditions.elementToBeClickable(By.id("surname")));
        surnameInput.clear();
        surnameInput.sendKeys(surname);
        driver.findElement(By.id("update surname")).click();

        // go to myProfile and submit description
        driver.get("http://localhost:8080/myProfile");
        WebElement descriptionInput = wait.until(ExpectedConditions.elementToBeClickable(By.id("description")));
        descriptionInput.clear();
        descriptionInput.sendKeys(description);
        driver.findElement(By.id("update description")).click();

        // Final visit to check values
        driver.get("http://localhost:8080/myProfile");

        assertEquals(forename, driver.findElement(By.id("forename")).getAttribute("value"));
        assertEquals(surname, driver.findElement(By.id("surname")).getAttribute("value"));
        assertEquals(description, driver.findElement(By.id("description")).getAttribute("value"));
    }

    @Test // myProfile should redirect user if not logged in.
    public void myProfileRedirectsIfNotLoggedIn() {

        // gets myProfile page
        driver.get("http://localhost:8080/myProfile");

        // gets current URL after navigation
        String currentUrl = driver.getCurrentUrl();

        // asserts the user was redirected (e.g., to login page)
        assertTrue(currentUrl.contains("auth0.com/u/login"));
    }

    @Test // myProfile should allow users to update their forename
    public void myProfileUpdateForenameWorks() {
        // creates fake forename
        String forename = faker.name().firstName();

        // from sign up helper method
        signUpUser();

        // gets myProfile page
        driver.get("http://localhost:8080/myProfile");

        // waits until forename field becomes clickable
        WebElement forenameInput = wait.until(ExpectedConditions.elementToBeClickable(By.id("forename")));
        forenameInput.clear();
        forenameInput.sendKeys(forename);

        // waits until submit button becomes clickable
        WebElement submitButton = wait.until(ExpectedConditions.elementToBeClickable(By.id("update forename")));
        submitButton.click();

        // Wait for the forename field to update and re-fetch it
        WebElement updatedForenameInput = wait.until(
                ExpectedConditions.presenceOfElementLocated(By.id("forename"))
        );
        String displayedForename = updatedForenameInput.getAttribute("value");
        assertEquals(forename, displayedForename);
    }

    @Test // myProfile should allow users to update their surname
    public void myProfileUpdateSurnameWorks() {
        // creates fake surname
        String surname = faker.name().lastName();

        // from sign up helper method
        signUpUser();

        // gets myProfile page
        driver.get("http://localhost:8080/myProfile");

        // waits until surname field becomes clickable
        WebElement surnameInput = wait.until(ExpectedConditions.elementToBeClickable(By.id("surname")));
        surnameInput.clear();
        surnameInput.sendKeys(surname);

        // waits until submit button becomes clickable
        WebElement submitButton = wait.until(ExpectedConditions.elementToBeClickable(By.id("update surname")));
        submitButton.click();

        // Wait for the surname field to update and re-fetch it
        WebElement updatedSurnameInput = wait.until(
                ExpectedConditions.presenceOfElementLocated(By.id("surname"))
        );
        String displayedSurname = updatedSurnameInput.getAttribute("value");
        assertEquals(surname, displayedSurname);
    }

    @Test // myProfile should allow users to update their description
    public void myProfileUpdateDescriptionWorks() {
        // creates fake description
        String description = faker.lorem().sentence();

        // from sign up helper method
        signUpUser();

        // gets myProfile page
        driver.get("http://localhost:8080/myProfile");

        // waits until description field becomes clickable
        WebElement descriptionInput = wait.until(ExpectedConditions.elementToBeClickable(By.id("description")));
        descriptionInput.clear();
        descriptionInput.sendKeys(description);

        // waits until submit button becomes clickable
        WebElement submitButton = wait.until(ExpectedConditions.elementToBeClickable(By.id("update description")));
        submitButton.click();

        // waits for description to update
        WebElement updatedDescriptionInput = wait.until(
                ExpectedConditions.presenceOfElementLocated(By.id("description"))
        );
        String displayedDescription = updatedDescriptionInput.getAttribute("value");
        assertEquals(description, displayedDescription);
    }
}