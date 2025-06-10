package com.makersacademy.acebook.model;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set; // Make sure Set is imported if not already

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.*;

public class FriendRequestTest {

        private User zendaya;
        private User tom;
        private User beyonce;
        private User bieber;

        private FriendRequest zendayaToTomRequest;
        private FriendRequest beyonceToZendayaRequest;
        private FriendRequest bieberToZendayaRequest;

        @BeforeEach
        public void setUp() {
                zendaya = new User("Zendaya", true);
                zendaya.setFriends(new HashSet<>());

                tom = new User("Tom", true);
                tom.setFriends(new HashSet<>());

                beyonce = new User("Beyonce", true);
                beyonce.setFriends(new HashSet<>());

                bieber = new User("Justin", true);
                bieber.setFriends(new HashSet<>());

                // Add Zendaya's request to Tom's requests
                zendayaToTomRequest = new FriendRequest(zendaya, tom, true, LocalDateTime.now());
                tom.getReceivedFriendRequests().add(zendayaToTomRequest);

                // Add Beyonce's request to Zendaya's requests
                beyonceToZendayaRequest = new FriendRequest(beyonce, zendaya, true, LocalDateTime.now());
                zendaya.getReceivedFriendRequests().add(beyonceToZendayaRequest);

                // Add Bieber's request to Zendaya's requests
                bieberToZendayaRequest = new FriendRequest(bieber, zendaya, true, LocalDateTime.now());
                zendaya.getReceivedFriendRequests().add(bieberToZendayaRequest);
        }

        @Test
        public void checkBieberHasNoFriendRequests() {
                assertThat(bieber.getReceivedFriendRequests().isEmpty(), is(true));
                assertThat(bieber.getReceivedFriendRequests().size(), is(0));
        }

        @Test
        public void checkTomHasOneReceivedFriendRequest() {
                assertThat(tom.getReceivedFriendRequests().size(), is(1));
                assertThat(tom.getReceivedFriendRequests(), hasItem(zendayaToTomRequest));
                assertThat(tom.getReceivedFriendRequests().iterator().next().getSender(), is(zendaya));
        }


        @Test
        public void checkZendayaHasTwoReceivedFriendRequests() {
                assertThat(zendaya.getReceivedFriendRequests().size(), is(2));
                assertThat(zendaya.getReceivedFriendRequests(), hasItem(beyonceToZendayaRequest));
                assertThat(zendaya.getReceivedFriendRequests(), hasItem(bieberToZendayaRequest));

                // Check justin and beyonce are in zendaya's requests
                assertThat(
                        zendaya.getReceivedFriendRequests().stream()
                                .map(FriendRequest::getSender)
                                .collect(java.util.stream.Collectors.toSet()),
                        containsInAnyOrder(beyonce, bieber)
                );
        }

        @Test
        public void checkFriendRequestCanBeAccepted() {
                assertThat(beyonceToZendayaRequest.isPending(), is(true));
                beyonceToZendayaRequest.setPending(false);
                assertThat(beyonceToZendayaRequest.isPending(), is(false));
        }

        @Test
        public void checkZendayaStartsWithNoFriends() {
                assertThat(zendaya.getFriends().isEmpty(), is(true));
                assertThat(zendaya.getFriends().size(), is(0));
        }

        @Test
        public void checkAddedToFriendsList() {
                // Mark request as false to remove from table
                zendayaToTomRequest.setPending(false);

                //Then add them as friends
                zendaya.getFriends().add(tom);
                tom.getFriends().add(zendaya);

                assertThat(zendaya.getFriends(), hasItem(tom));
                assertThat(tom.getFriends(), hasItem(zendaya));
                assertThat(zendaya.getFriends().size(), is(1));
                assertThat(tom.getFriends().size(), is(1));
        }
}