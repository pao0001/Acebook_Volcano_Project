package com.makersacademy.acebook.feature;

import com.github.javafaker.Faker;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

//Have a look at selenium for finding text IDs
// See how to insert element IDs.
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class FriendsTest {

    WebDriver driver;
    Faker faker;

    @BeforeEach
    public void setup() {
        System.setProperty("webdriver.chrome.driver", "/usr/local/bin/chromedriver");
        driver = new ChromeDriver();
    }

    @AfterEach
    public void tearDown() {
        driver.quit(); // safer than close()
    }

    @Test
    public void successfulTestLogInShowsTestFriends() {
        String email = "test@test.com";

        driver.get("http://localhost:8080/");
        driver.findElement(By.name("username")).sendKeys(email);
        driver.findElement(By.name("password")).sendKeys("Test123!");
        driver.findElement(By.name("action")).click();
        driver.get("http://localhost:8080/friends");

        // CSS selector as alternative to xpath, example syntax:
        // WebElement button = driver.findElement(By.xpath("//*[@data-testid=‘friends’]”));

        String noOfFriendsText = driver.findElement(By.xpath("friends")).getText();

        assertEquals("Friends (6)", noOfFriendsText);
    }
}
