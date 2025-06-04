package com.makersacademy.acebook.model;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.hasItem;

import org.junit.jupiter.api.Test;

public class UserTest {

    private User karen = new User("Karen", true);
    private User zehad = new User("Zehad", true);

    @Test
    public void checkWhoIsFriends() {
        // Hashset friends table is not bidirectional,
        // Both friends must be added each other
        karen.getFriends().add(zehad);
        zehad.getFriends().add(karen);
        assertThat(karen.getFriends(), hasItem(zehad));
        assertThat(zehad.getFriends(), hasItem(karen));
    }
}
