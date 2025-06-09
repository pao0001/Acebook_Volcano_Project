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
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class FriendRequestsTest {

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
    public void sendFriendRequestSuccessfully() {
        driver.get("http://localhost:8080/myProfile");
        WebElement friendLink = driver.findElement(By.cssSelector("a[href='/profile/8']"));
        friendLink.click();

        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(3));
        WebElement sendFriendRequestButton = wait.until(
                ExpectedConditions.elementToBeClickable(By.xpath("//button[text()='Send Friend Request']")));
        sendFriendRequestButton.click();

        // Wait for the "Friend request sent." message to appear
        WebElement friendRequestSentMsgElem = wait.until(
                ExpectedConditions.visibilityOfElementLocated(By.id("friendRequestSent")));
        String friendRequestSentMsg = friendRequestSentMsgElem.getText();
        assertEquals("Friend request sent.", friendRequestSentMsg);
    }

    @Test
    public void viewIncomingFriendRequest() {
        String zendayaFriendRequest =  driver.findElement(By.xpath("//span[text()='Zendaya Coleman']")).getText();
        assertEquals("Zendaya Coleman", zendayaFriendRequest);
    }

    @Test
    public void acceptFriendRequest() {
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(3));
        WebElement acceptFriendRequestButton = wait.until(
                ExpectedConditions.elementToBeClickable(By.xpath("//button[text()='Accept']")));
        acceptFriendRequestButton.click();
        String noOfFriendsText = driver.findElement(By.id("friends")).getText();
        assertEquals("Friends (7)", noOfFriendsText);
    }

    @Test
    public void rejectFriendRequest() {
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(3));
        WebElement acceptFriendRequestButton = wait.until(
                ExpectedConditions.elementToBeClickable(By.xpath("//button[text()='Decline']")));
        acceptFriendRequestButton.click();

        WebElement noFriendRequests = wait.until(
                ExpectedConditions.visibilityOfElementLocated(
                        By.xpath("//p[text()='You currently have no friend requests.']")));
        assertEquals("You currently have no friend requests.", noFriendRequests.getText());
    }
}
