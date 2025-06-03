CREATE TABLE friends (
    user_id bigint NOT NULL,
    friend_id bigint NOT NULL,
    PRIMARY KEY (user_id, friend_id),

    -- These constraints force the tables to use only existing user ids.
    -- On delete cascade deletes friendships if either user or friend deletes their account.
    CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_friend FOREIGN KEY (friend_id) REFERENCES users(id) ON DELETE CASCADE
);
