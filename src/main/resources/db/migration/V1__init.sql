DROP TABLE IF EXISTS posts;

CREATE TABLE posts (
  id bigserial PRIMARY KEY,
  content varchar(250) NOT NULL
);

INSERT INTO posts (content) VALUES('First test post');