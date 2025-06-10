ALTER TABLE posts
  ADD COLUMN username TEXT
;
INSERT INTO posts (username, content) VALUES('Test Post User', 'First test post');