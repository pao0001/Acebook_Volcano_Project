package com.makersacademy.acebook.feature;

import com.github.javafaker.Faker;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

//Have a look at selenium for finding text IDs
// See how to insert element IDs.
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class FriendsTest {

    WebDriver driver;
    Faker faker;

    @BeforeEach
    public void setup() {
        System.setProperty("webdriver.chrome.driver", "/usr/local/bin/chromedriver");
        driver = new ChromeDriver();
        String email = "test@test.com";
        driver.get("http://localhost:8080/");
        driver.findElement(By.name("username")).sendKeys(email);
        driver.findElement(By.name("password")).sendKeys("Test123!");
        driver.findElement(By.name("action")).click();
        driver.get("http://localhost:8080/friends");

    }

    @AfterEach
    public void tearDown() {
        driver.quit(); // safer than close()
    }

    @Test
    public void successfulTestLogInShowsTestFriends() {
        String noOfFriendsText = driver.findElement(By.id("friends")).getText();
        assertEquals("Friends (6)", noOfFriendsText);

    }

    @Test
    public void testLogInShowsAllFriends() {
        String taylorSwift = driver.findElement(By.id("Taylor")).getText();
        String dwayneJohnson = driver.findElement(By.id("Dwayne")).getText();
        String robertDowney = driver.findElement(By.id("Robert")).getText();
        String drake = driver.findElement(By.id("Aubrey \"Drake\"")).getText();
        String emmaWatson = driver.findElement(By.id("Emma")).getText();
        String beyonce = driver.findElement(By.id("Beyoncé")).getText();

        assertEquals("Taylor Swift", taylorSwift);
        assertEquals("Dwayne Johnson", dwayneJohnson);
        assertEquals("Robert Downey", robertDowney);
        assertEquals("Aubrey \"Drake\" Graham", drake);
        assertEquals("Emma Watson", emmaWatson);
        assertEquals("Beyoncé Knowles", beyonce);
    }
}
