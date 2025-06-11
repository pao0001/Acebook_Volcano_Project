DROP TABLE IF EXISTS rec_friends;

CREATE TABLE rec_friends (
    id bigserial PRIMARY KEY,
    user_id bigint NOT NULL,
    rec_friend_id bigint NOT NULL,
    mutuals integer NOT NULL
)