INSERT INTO users (username, enabled, auth0_id, description, forename, surname)
VALUES	  ('test@test.com',
             'TRUE',
             NULL,
             'test description',
             'John',
             'Smith' ),

          ('t.swiftie89@popvibes.com',
           'TRUE',
           NULL,
           'writing songs in lowercase & living eras one heartbreak at a time.',
           'Taylor',
           'Swift' ),

          ('robert.downey@starkmail.com',
           'TRUE',
           NULL,
           'genius, billionaire, occasional Avenger—still figuring out email folders.',
           'Robert',
           'Downey'),

          ('bey.queenb@lemonadehub.net',
           'TRUE',
           NULL,
           'building empires in heels & harmony.',
           'Beyoncé',
           'Knowles'),

          ('the.rock@smashmail.org',
           'TRUE',
           NULL,
           'lifting heavy things, making big moves, staying humble.',
           'Dwayne',
           'Johnson'),

          ('emma.watson.books@hermione.io',
           'TRUE',
           NULL,
           'actress, activist, bookworm—powered by caffeine and curiosity.',
           'Emma',
           'Watson'),

          ('drake@octobersveryown.ca',
           'TRUE',
           NULL,
           'emotional in the booth, iced out in the booth, still reading your texts.',
           'Aubrey "Drake"',
           'Graham'),

          ('rih.navy@fentyhq.co',
           'TRUE',
           NULL,
           'CEO energy with a side of island breeze.',
           'Robyn "Rihanna"',
           'Fenty'),

          ('zendaya.now@webslings.tv',
           'TRUE',
           NULL,
           'actor, fashion nerd, part-time superhero, full-time cozy.',
           'Zendaya',
           'Coleman');

INSERT INTO friends (user_id, friend_id)
VALUES
    (
        (SELECT id FROM users WHERE username = 'test@test.com'),
        (SELECT id FROM users WHERE username = 't.swiftie89@popvibes.com')
    ),
    (
        (SELECT id FROM users WHERE username = 'test@test.com'),
        (SELECT id FROM users WHERE username = 'robert.downey@starkmail.com')
    ),
    (
        (SELECT id FROM users WHERE username = 'test@test.com'),
        (SELECT id FROM users WHERE username = 'bey.queenb@lemonadehub.net')
    ),
    (
        (SELECT id FROM users WHERE username = 'test@test.com'),
        (SELECT id FROM users WHERE username = 'the.rock@smashmail.org')
    ),
    (
        (SELECT id FROM users WHERE username = 'test@test.com'),
        (SELECT id FROM users WHERE username = 'emma.watson.books@hermione.io')
    ),
    (
        (SELECT id FROM users WHERE username = 'test@test.com'),
        (SELECT id FROM users WHERE username = 'drake@octobersveryown.ca')
    );