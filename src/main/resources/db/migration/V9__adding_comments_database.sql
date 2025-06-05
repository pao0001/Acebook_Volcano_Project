CREATE TABLE comments(
id BIGSERIAL PRIMARY KEY,
username VARCHAR(255),
comment TEXT,
postID INT,
time_stamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY (postID) REFERENCES posts(id)
);

INSERT INTO comments (username, comment, postID) VALUES('Paul','First test comment', 1);