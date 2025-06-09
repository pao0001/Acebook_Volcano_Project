DROP TABLE IF EXISTS friend_requests;

CREATE TABLE friend_requests (
                                 id bigserial PRIMARY KEY,
                                 sender_id bigint NOT NULL,
                                 receiver_id bigint NOT NULL,
                                 pending boolean NOT NULL DEFAULT TRUE,
                                 sent_at TIMESTAMP,
                                 CONSTRAINT fk_sender FOREIGN KEY (sender_id) REFERENCES users(id),
                                 CONSTRAINT fk_receiver FOREIGN KEY (receiver_id) REFERENCES users(id)
);