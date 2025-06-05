DROP TABLE IF EXISTS friend_requests;

CREATE TABLE friend_requests (
                                 id bigserial PRIMARY KEY,
                                 sender_id int NOT NULL,
                                 receiver_id int NOT NULL,
                                 pending boolean NOT NULL DEFAULT TRUE,
                                 CONSTRAINT fk_sender FOREIGN KEY (sender_id) REFERENCES users(id),
                                 CONSTRAINT fk_receiver FOREIGN KEY (receiver_id) REFERENCES users(id)
);

-- Make zendaya and rihanna friend requests.