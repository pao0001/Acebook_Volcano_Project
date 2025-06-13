-- 🔴 DROP ALL TABLES 🔴 --
DROP TABLE IF EXISTS likes;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS posts;
DROP TABLE IF EXISTS rec_friends;
DROP TABLE IF EXISTS friend_requests;
DROP TABLE IF EXISTS friends;
DROP TABLE IF EXISTS users;

-- 🔴 CREATE ALL TABLES 🔴 --
-- USERS
CREATE TABLE users (
                       id BIGSERIAL PRIMARY KEY,
                       username VARCHAR(50) NOT NULL UNIQUE,
                       enabled BOOLEAN NOT NULL,
                       auth0_id VARCHAR(255) UNIQUE,
                       description TEXT,
                       forename VARCHAR(255),
                       surname VARCHAR(255),
                       profile_image_src VARCHAR(255),
                       banner_image_src VARCHAR(255),
                       gender VARCHAR(50),
                       pronouns VARCHAR(50),
                       current_city VARCHAR(100),
                       hometown VARCHAR(100),
                       job VARCHAR(100),
                       school VARCHAR(100),
                       relationship_status VARCHAR(50),
                       sexual_orientation VARCHAR(50),
                       political_views VARCHAR(100),
                       religion VARCHAR(100),
                       dob DATE
);

-- FRIENDS
CREATE TABLE friends (
                         user_id BIGINT NOT NULL,
                         friend_id BIGINT NOT NULL,
                         PRIMARY KEY (user_id, friend_id),
                         CONSTRAINT fk_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
                         CONSTRAINT fk_friend FOREIGN KEY (friend_id) REFERENCES users(id) ON DELETE CASCADE
);

-- FRIEND REQUESTS
CREATE TABLE friend_requests (
                                 id BIGSERIAL PRIMARY KEY,
                                 sender_id BIGINT NOT NULL,
                                 receiver_id BIGINT NOT NULL,
                                 pending BOOLEAN NOT NULL DEFAULT TRUE,
                                 sent_at TIMESTAMP,
                                 CONSTRAINT fk_sender FOREIGN KEY (sender_id) REFERENCES users(id),
                                 CONSTRAINT fk_receiver FOREIGN KEY (receiver_id) REFERENCES users(id)
);

-- RECOMMENDED FRIENDS
CREATE TABLE rec_friends (
                             id BIGSERIAL PRIMARY KEY,
                             user_id BIGINT NOT NULL,
                             rec_friend_id BIGINT NOT NULL,
                             mutuals INTEGER NOT NULL
);

-- POSTS
CREATE TABLE posts (
                       id BIGSERIAL PRIMARY KEY,
                       content VARCHAR(250),
                       username TEXT,
                       user_id INTEGER,
                       forename TEXT,
                       surname TEXT,
                       post_image_src VARCHAR(255),
                       time_stamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- COMMENTS
CREATE TABLE comments (
                          id BIGSERIAL PRIMARY KEY,
                          username VARCHAR(255),
                          comment TEXT,
                          postid INT,
                          time_stamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          FOREIGN KEY (postID) REFERENCES posts(id)
);

-- LIKES
CREATE TABLE likes (
                       id BIGSERIAL PRIMARY KEY,
                       user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
                       liked_type VARCHAR(20) NOT NULL CHECK (liked_type IN ('post', 'comment')),
                       liked_id BIGINT NOT NULL,
                       created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                       UNIQUE (user_id, liked_type, liked_id)
);

-- 🔴 SEEDING USER TABLE 🔴 --
INSERT INTO users (
    username, enabled, auth0_id, description, forename, surname, profile_image_src, banner_image_src,
    gender, pronouns, current_city, hometown, job, school, relationship_status,
    sexual_orientation, political_views, religion, dob
) VALUES
-- Test user (1) --
('test.user@example.com', TRUE, NULL,
 'Adventurous spirit and passionate coder. Loves hiking, coffee, and good conversations.',
 'Test', 'User',
 'https://randomuser.me/api/portraits/lego/1.jpg', 'https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
 'Non-binary', 'They/them', 'San Francisco', 'Denver', 'Software Developer', 'MIT', 'Single',
 'Pansexual', 'Progressive', 'None', '1990-05-20'),

-- Test user’s 20 friends (2-21) --
('friend1@example.com', TRUE, NULL,
 'Music lover and vinyl collector. Always chasing the perfect beat.',
 'Alice', 'Smith',
 'https://images.unsplash.com/photo-1499887142886-791eca5918cd?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8d29tYW58ZW58MHwyfDB8fHww',
 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80',
 'Female', 'She/her', 'New York', 'Boston', 'DJ', 'NYU', 'Single',
 'Heterosexual', 'Liberal', 'Jewish', '1988-01-15'),

('friend2@example.com', TRUE, NULL,
 'Gardener and nature enthusiast. Has a secret herb garden at home.',
 'Bob', 'Johnson',
 'https://images.unsplash.com/photo-1493752603190-08d8b5d1781d?q=80&w=3560&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
 'https://images.unsplash.com/photo-1516253593875-bd7ba052fbc5?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
 'Male', 'He/him', 'Seattle', 'Portland', 'Botanist', 'University of Washington', 'Married',
 'Heterosexual', 'Moderate', 'Christian', '1975-03-20'),

('friend3@example.com', TRUE, NULL,
 'Photographer capturing everyday beauty. Loves street photography and sunsets.',
 'Cara', 'Lee',
 'https://images.unsplash.com/photo-1495580621852-5de0cc907d2f?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8cGhvdG9ncmFwaGVyfGVufDB8MnwwfHx8MA%3D%3D',
 'https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c3Vuc2V0fGVufDB8MHwwfHx8MA%3D%3D',
 'Female', 'She/her', 'Chicago', 'Detroit', 'Photographer', 'Columbia College', 'Single',
 'Bisexual', 'Progressive', 'Buddhist', '1992-07-22'),

('friend4@example.com', TRUE, NULL,
 'Tech startup founder passionate about AI and innovation.',
 'David', 'Chen',
 'https://images.unsplash.com/photo-1720501827999-43d3fb5075f6?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8YXNpYW4lMjBtYW58ZW58MHwyfDB8fHww',
 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fHRlY2h8ZW58MHwwfDB8fHww',
 'Male', 'He/him', 'San Francisco', 'Shanghai', 'Entrepreneur', 'Stanford', 'Single',
 'Heterosexual', 'Progressive', 'Atheist', '1987-09-09'),

('friend5@example.com', TRUE, NULL,
 'Yoga instructor and wellness advocate.',
 'Ella', 'Brown',
 'https://images.unsplash.com/photo-1485727749690-d091e8284ef3?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjZ8fHlvZ2ElMjB0ZWFjaGVyfGVufDB8MnwwfHx8MA%3D%3D',
 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8eW9nYXxlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'Austin', 'Dallas', 'Yoga Instructor', 'UT Austin', 'Married',
 'Heterosexual', 'Liberal', 'Hindu', '1990-12-11'),

('friend6@example.com', TRUE, NULL,
 'Loves books, podcasts, and long walks in the park.',
 'Frank', 'Davis',
 'https://images.unsplash.com/photo-1618077360395-f3068be8e001?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8b2xkZXIlMjBtYW58ZW58MHwyfDB8fHww',
 'https://images.unsplash.com/photo-1622050956578-94fd044a0ada?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cGFya3xlbnwwfDB8MHx8fDA%3D',
 'Male', 'He/him', 'Denver', 'Chicago', 'Editor', 'University of Chicago', 'Single',
 'Heterosexual', 'Moderate', 'Christian', '1986-08-02'),

('friend7@example.com', TRUE, NULL,
 'Fashion enthusiast and part-time blogger.',
 'Grace', 'Evans',
 'https://images.unsplash.com/photo-1666224064108-7375c15c1789?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGxlc2JpYW58ZW58MHwyfDB8fHww',
 'https://plus.unsplash.com/premium_photo-1664202526559-e21e9c0fb46a?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZmFzaGlvbnxlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'Los Angeles', 'Miami', 'Fashion Designer', 'Parsons School of Design', 'Single',
 'Lesbian', 'Liberal', 'None', '1993-04-14'),

('friend8@example.com', TRUE, NULL,
 'Biker and adrenaline junkie. Always up for a challenge.',
 'Henry', 'Foster',
 'https://images.unsplash.com/photo-1660669701082-dbeffd6755fa?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YmlrZXJ8ZW58MHwyfDB8fHww',
 'https://images.unsplash.com/photo-1556221620-3616894469d9?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8bW91bnRhaW4lMjBiaWtpbmd8ZW58MHwwfDB8fHww',
 'Male', 'He/him', 'Portland', 'Seattle', 'Mechanic', 'Oregon State', 'Married',
 'Heterosexual', 'Conservative', 'Atheist', '1982-11-07'),

('friend9@example.com', TRUE, NULL,
 'Chef specializing in vegan desserts.',
 'Isabella', 'Garcia',
 'https://plus.unsplash.com/premium_photo-1723867331866-e112500178a4?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8c3BhbmlzaCUyMHdvbWFufGVufDB8MnwwfHx8MA%3D%3D',
 'https://plus.unsplash.com/premium_photo-1694790026920-2bead0a7d993?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dmVnYW4lMjBkZXNzZXJ0fGVufDB8MHwwfHx8MA%3D%3D',
 'Non-binary', 'They/them', 'New York', 'Los Angeles', 'Chef', 'Culinary Institute', 'Single',
 'Pansexual', 'Progressive', 'Agnostic', '1991-01-19'),

('friend10@example.com', TRUE, NULL,
 'Aspiring novelist who finds inspiration in everyday life.',
 'Jack', 'Harris',
 'https://images.unsplash.com/photo-1623685463160-f3f501540a91?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8d3JpdGVyJTIwbWFufGVufDB8MnwwfHx8MA%3D%3D',
 'https://plus.unsplash.com/premium_photo-1724176267196-7121b3d21e7f?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bm92ZWxpc3R8ZW58MHwwfDB8fHww',
 'Male', 'He/him', 'Boston', 'Philadelphia', 'Writer', 'Boston University', 'Single',
 'Heterosexual', 'Liberal', 'None', '1990-07-04'),

('friend11@example.com', TRUE, NULL,
 'Teacher and lifelong learner.',
 'Kara', 'Iverson',
 'https://images.unsplash.com/photo-1696960181436-1b6d9576354e?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8d29tYW4lMjB0ZWFjaGVyfGVufDB8MnwwfHx8MA%3D%3D',
 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHRlYWNoZXJ8ZW58MHwwfDB8fHww',
 'Female', 'She/her', 'Atlanta', 'Nashville', 'Teacher', 'Vanderbilt', 'Married',
 'Heterosexual', 'Moderate', 'Christian', '1988-12-22'),

('friend12@example.com', TRUE, NULL,
 'Environmental activist and volunteer.',
 'Liam', 'Jackson',
 'https://images.unsplash.com/photo-1685773936404-e37e2a8407cc?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGhpcHBpZSUyMG1hbnxlbnwwfDJ8MHx8fDA%3D',
 'https://images.unsplash.com/photo-1472313420546-a46e561861d8?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZW52aXJvbm1lbnR8ZW58MHwwfDB8fHww',
 'Male', 'He/him', 'Seattle', 'Vancouver', 'Activist', 'University of Washington', 'Single',
 'Heterosexual', 'Progressive', 'Buddhist', '1994-06-09'),

('friend13@example.com', TRUE, NULL,
 'Gamer and streamer who loves interacting with fans.',
 'Mia', 'Kim',
 'https://plus.unsplash.com/premium_photo-1723795214281-640bfd679aaa?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8YXNpYW4lMjBnYW1lcnxlbnwwfDJ8MHx8fDA%3D',
 'https://images.unsplash.com/photo-1598550476439-6847785fcea6?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Z2FtZSUyMHN0cmVhbWluZ3xlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'San Diego', 'Seoul', 'Streamer', 'UCSD', 'Single',
 'Bisexual', 'Liberal', 'None', '1995-02-28'),

('friend14@example.com', TRUE, NULL,
 'Photographer who loves capturing urban life.',
 'Noah', 'Lopez',
 'https://images.unsplash.com/photo-1612195352923-006673e43f27?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8cGhvdG9ncmFwaGVyfGVufDB8MnwwfHx8MA%3D%3D',
 'https://images.unsplash.com/photo-1558985789-c73070851265?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fHVyYmFuJTIwcGhvdG9ncmFwaHl8ZW58MHwwfDB8fHww',
 'Male', 'He/him', 'Chicago', 'Mexico City', 'Photographer', 'Columbia College', 'Single',
 'Heterosexual', 'Moderate', 'Catholic', '1992-09-15'),

('friend15@example.com', TRUE, NULL,
 'Musician and songwriter.',
 'Olivia', 'Martinez',
 'https://images.unsplash.com/photo-1520872024865-3ff2805d8bb3?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fHdvbWFuJTIwcGVyZm9ybWluZ3xlbnwwfDJ8MHx8fDA%3D',
 'https://images.unsplash.com/photo-1595971294624-80bcf0d7eb24?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bXVzaWNpYW58ZW58MHwwfDB8fHww',
 'Female', 'She/her', 'Austin', 'Houston', 'Musician', 'UT Austin', 'Single',
 'Heterosexual', 'Liberal', 'Christian', '1990-11-21'),

('friend16@example.com', TRUE, NULL,
 'Software developer and coffee addict.',
 'Peter', 'Tran',
 'https://images.unsplash.com/photo-1542909168-82c3e7fdca5c?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8YXNpYW4lMjBtYW58ZW58MHwyfDB8fHww',
 'https://plus.unsplash.com/premium_photo-1674327105074-46dd8319164b?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8Y29mZmVlfGVufDB8MHwwfHx8MA%3D%3D',
 'Male', 'He/him', 'San Francisco', 'Hanoi', 'Developer', 'Stanford', 'Single',
 'Gay', 'Progressive', 'Atheist', '1987-03-03'),

('friend17@example.com', TRUE, NULL,
 'Fitness coach and marathon runner.',
 'Quinn', 'Jefferson',
 'https://images.unsplash.com/photo-1739416729276-23deaf06a982?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mzh8fHJ1bm5lcnxlbnwwfDJ8MHx8fDA%3D',
 'https://images.unsplash.com/photo-1571008887538-b36bb32f4571?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cnVubmluZ3xlbnwwfDB8MHx8fDA%3D',
 'Non-binary', 'They/them', 'Denver', 'Boston', 'Coach', 'Boston University', 'Single',
 'Queer', 'Moderate', 'Christian', '1985-10-10'),

('friend18@example.com', TRUE, NULL,
 'Entrepreneur and startup mentor.',
 'Ryan', 'Patel',
 'https://plus.unsplash.com/premium_photo-1723579325857-3a63fba1ad99?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8aW5kaWFuJTIwbWFufGVufDB8MnwwfHx8MA%3D%3D',
 'https://images.unsplash.com/photo-1665686310429-ee43624978fa?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8ZW50cmVwcmVuZXVyfGVufDB8MHwwfHx8MA%3D%3D',
 'Male', 'He/him', 'San Jose', 'Ludhiana', 'Entrepreneur', 'MIT', 'Married',
 'Heterosexual', 'Conservative', 'Sikh', '1983-07-08'),

('friend19@example.com', TRUE, NULL,
 'Chef and food blogger.',
 'Sophia', 'Quinn',
 'https://plus.unsplash.com/premium_photo-1726876844515-df2e188772c0?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fGZvb2QlMjBibG9nZ2VyfGVufDB8MnwwfHx8MA%3D%3D',
 'https://images.unsplash.com/photo-1577106263724-2c8e03bfe9cf?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Y2hlZnxlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'New Orleans', 'Atlanta', 'Chef', 'Culinary Institute', 'Single',
 'Bisexual', 'Liberal', 'None', '1991-05-12'),

('friend20@example.com', TRUE, NULL,
 'Comedian who uses humor to brighten the darkest days. A quick wit and infectious laugh.',
 'Tom', 'Henderson',
 'https://images.unsplash.com/photo-1702065613008-b419a830f635?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Y29tZWRpYW58ZW58MHwyfDB8fHww',
 'https://images.unsplash.com/photo-1571173069043-82a7a13cee9f?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y29tZWRpYW58ZW58MHwwfDB8fHww',
 'Male', 'He/him', 'Chicago', 'Detroit', 'Stand-up Comedian', 'DePaul University', 'Single',
 'Heterosexual', 'Moderate', 'None', '1989-06-28'),

-- Mutual friend recommendations (friends of friends, 22-26) --
('mutual1@example.com', TRUE, NULL,
 'Avid traveler and language learner. Currently obsessed with Japanese culture.',
 'Nina', 'Khan',
 'https://plus.unsplash.com/premium_photo-1726711248673-d79354b0920e?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fG11c2xpbSUyMHdvbWFufGVufDB8MnwwfHx8MA%3D%3D',
 'https://images.unsplash.com/photo-1526481280693-3bfa7568e0f3?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGphcGFuZXNlfGVufDB8MHwwfHx8MA%3D%3D',
 'Female', 'She/her', 'San Diego', 'Karachi', 'Translator', 'UCLA', 'Single',
 'Heterosexual', 'Progressive', 'Muslim', '1991-03-05'),

('mutual2@example.com', TRUE, NULL,
 'Tech geek and gamer. Loves building PCs and streaming gameplays.',
 'Oscar', 'Nguyen',
 'https://images.unsplash.com/photo-1674456736570-3c6df9791b76?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fG1hbiUyMHZpZXRuYW1lc2V8ZW58MHwyfDB8fHww',
 'https://images.unsplash.com/photo-1591238372338-22d30c883a86?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8cGMlMjBidWlsZHxlbnwwfDB8MHx8fDA%3D',
 'Male', 'He/him', 'Austin', 'Hanoi', 'Software Engineer', 'UT Austin', 'Single',
 'Gay', 'Liberal', 'Atheist', '1994-09-17'),

('mutual3@example.com', TRUE, NULL,
 'Chef with a love for spicy dishes and sharing meals with friends.',
 'Priya', 'Desai',
 'https://plus.unsplash.com/premium_photo-1723485857548-3f77b877c0ea?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8aW5kaWFuJTIwd29tYW58ZW58MHwyfDB8fHww',
 'https://plus.unsplash.com/premium_photo-1707227861789-475326479c2b?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y3Vycnl8ZW58MHwwfDB8fHww',
 'Female', 'She/her', 'New Orleans', 'Mumbai', 'Chef', 'Culinary Institute', 'Married',
 'Heterosexual', 'Moderate', 'Hindu', '1987-11-02'),

('mutual4@example.com', TRUE, NULL,
 'Passionate about urban farming and community gardens.',
 'Lucas', 'Morris',
 'https://images.unsplash.com/photo-1616578853146-cb0b5e732b83?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGhpcHBpZSUyMG1hbnxlbnwwfDJ8MHx8fDA%3D',
 'https://plus.unsplash.com/premium_photo-1663090966558-e62333420712?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y29tbXVuaXR5JTIwZ2FyZGVufGVufDB8MHwwfHx8MA%3D%3D',
 'Male', 'He/him', 'Portland', 'Seattle', 'Agriculturalist', 'Oregon State', 'Single',
 'Heterosexual', 'Liberal', 'Christian', '1986-04-18'),

('mutual5@example.com', TRUE, NULL,
 'Painter and art teacher, spreading color and creativity.',
 'Maya', 'Patel',
 'https://images.unsplash.com/photo-1709176001729-f91e08aa2ae0?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mzh8fHBhaW50ZXJ8ZW58MHwyfDB8fHww',
 'https://images.unsplash.com/photo-1601220959415-375d328bddc4?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cGFpbnRlcnxlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'Santa Fe', 'Ahmedabad', 'Artist', 'RISD', 'Single',
 'Bisexual', 'Progressive', 'Hindu', '1993-08-29'),

-- Non-friend users for friend requests (27-41) --
('request1@example.com', TRUE, NULL,
 'Aspiring musician who’s always jamming and writing songs.',
 'Gloria', 'Turner',
 'https://images.unsplash.com/photo-1579967844753-fa9cdd10a9c0?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fHNpbmdlciUyMHdvbWFufGVufDB8MnwwfHx8MA%3D%3D',
 'https://images.unsplash.com/photo-1574540346054-8a91eb807cfb?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8c29uZ3dyaXRlcnxlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'Nashville', 'Memphis', 'Musician', 'Berklee', 'Single',
 'Bisexual', 'Liberal', 'Christian', '1993-08-11'),

('request2@example.com', TRUE, NULL,
 'Fitness enthusiast and marathon runner. Loves to challenge limits.',
 'Raj', 'Singh',
 'https://images.unsplash.com/photo-1631164127494-272cf06180bd?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NjB8fGluZGlhbiUyMG1hbnxlbnwwfDJ8MHx8fDA%3D',
 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Zml0bmVzc3xlbnwwfDB8MHx8fDA%3D',
 'Male', 'He/him', 'Denver', 'New Delhi', 'Personal Trainer', 'University of Colorado', 'Single',
 'Heterosexual', 'Moderate', 'Sikh', '1985-04-23'),

('request3@example.com', TRUE, NULL,
 'Writer and poet who finds magic in everyday moments.',
 'Sara', 'Martinez',
 'https://images.unsplash.com/photo-1606685544086-ce4ab1b91c21?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDd8fHdyaXRlcnxlbnwwfDJ8MHx8fDA%3D',
 'https://plus.unsplash.com/premium_photo-1684444605542-93725082d214?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cG9ldHxlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'Boston', 'Madrid', 'Author', 'Boston University', 'Single',
 'Heterosexual', 'Progressive', 'Catholic', '1990-12-30'),

('request4@example.com', TRUE, NULL,
 'Entrepreneur passionate about eco-friendly startups and sustainability.',
 'Theo', 'Clark',
 'https://plus.unsplash.com/premium_photo-1726711229102-d617dddbdca0?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mjl8fGhpcHBpZSUyMG1hbnxlbnwwfDJ8MHx8fDA%3D',
 'https://plus.unsplash.com/premium_photo-1661368421663-13b2d8115241?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZWNvJTIwZnJpZW5kbHl8ZW58MHwwfDB8fHww',
 'Male', 'He/him', 'San Francisco', 'Seattle', 'Entrepreneur', 'Stanford', 'Single',
 'Heterosexual', 'Progressive', 'Agnostic', '1988-06-15'),

('request5@example.com', TRUE, NULL,
 'Artist exploring digital media and traditional painting.',
 'Vera', 'Kim',
 'https://images.unsplash.com/photo-1637761566180-9dbde4fdab77?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8YXNpYW4lMjBhcnRpc3R8ZW58MHwyfDB8fHww',
 'https://images.unsplash.com/photo-1591200687746-73cfd588ea5e?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8YXJ0aXN0fGVufDB8MHwwfHx8MA%3D%3D',
 'Female', 'She/her', 'Los Angeles', 'Seoul', 'Artist', 'CalArts', 'Single',
 'Lesbian', 'Liberal', 'Buddhist', '1992-05-27'),

('request6@example.com', TRUE, NULL,
 'Travel blogger sharing adventures from around the globe.',
 'Wendy', 'Lopez',
 'https://images.unsplash.com/photo-1582696532633-628289319654?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Njh8fHdvbWFuJTIwdHJhdmVsfGVufDB8MnwwfHx8MA%3D%3D',
 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8dHJhdmVsfGVufDB8MHwwfHx8MA%3D%3D',
 'Female', 'She/her', 'Miami', 'Havana', 'Blogger', 'Florida State', 'Single',
 'Heterosexual', 'Liberal', 'Christian', '1993-07-16'),

('request7@example.com', TRUE, NULL,
 'Comic book artist and superhero fan.',
 'Xander', 'Morris',
 'https://images.unsplash.com/photo-1535467269829-2959b350bdb7?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Y29taWMlMjBib29rfGVufDB8MnwwfHx8MA%3D%3D',
 'https://plus.unsplash.com/premium_photo-1725404409133-61938ac37719?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y29taWMlMjBib29rfGVufDB8MHwwfHx8MA%3D%3D',
 'Male', 'He/him', 'New York', 'Chicago', 'Artist', 'School of Visual Arts', 'Single',
 'Heterosexual', 'Moderate', 'Atheist', '1989-02-24'),

('request8@example.com', TRUE, NULL,
 'Barista and coffee aficionado.',
 'Yara', 'Hoang',
 'https://plus.unsplash.com/premium_photo-1726862815372-ee2c2d1bd600?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8YmFyaXN0YXxlbnwwfDJ8MHx8fDA%3D',
 'https://images.unsplash.com/photo-1507915135761-41a0a222c709?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YmFyaXN0YXxlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'Seattle', 'Ho Chi Minh City', 'Barista', 'Seattle Central', 'Single',
 'Heterosexual', 'Liberal', 'None', '1991-11-30'),

('request9@example.com', TRUE, NULL,
 'Film director and storyteller.',
 'Zach', 'Daniels',
 'https://images.unsplash.com/photo-1654175979490-502d1800b396?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8ZmlsbSUyMGRpcmVjdHJ8ZW58MHwyfDB8fHww',
 'https://plus.unsplash.com/premium_photo-1682125771198-f7cbed7cb868?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZmlsbSUyMGRpcmVjdG9yfGVufDB8MHwwfHx8MA%3D%3D',
 'Male', 'He/him', 'Los Angeles', 'Dublin', 'Director', 'USC', 'Married',
 'Heterosexual', 'Progressive', 'Catholic', '1984-10-02'),

('request10@example.com', TRUE, NULL,
 'Environmental scientist studying climate change.',
 'Amy', 'Parker',
 'https://images.unsplash.com/photo-1664223987460-e5fd70a455ee?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8d29tYW4lMjBzdHVkZW50fGVufDB8MnwwfHx8MA%3D%3D',
 'https://images.unsplash.com/photo-1552799446-159ba9523315?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y2xpbWF0ZSUyMGNoYW5nZXxlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'Boston', 'Portland', 'Scientist', 'Harvard', 'Single',
 'Heterosexual', 'Progressive', 'None', '1987-05-14'),

('request11@example.com', TRUE, NULL,
 'Dog trainer and animal lover.',
 'Brian', 'Watson',
 'https://images.unsplash.com/photo-1645709043778-cdf8bae9fa7a?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8ZG9nJTIwdHJhaW5lcnxlbnwwfDJ8MHx8fDA%3D',
 'https://plus.unsplash.com/premium_photo-1679520867935-be3c649b2e87?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8ZG9nJTIwdHJhaW5lcnxlbnwwfDB8MHx8fDA%3D',
 'Male', 'He/they', 'Denver', 'Salt Lake City', 'Trainer', 'Colorado State', 'Married',
 'Heterosexual', 'Moderate', 'Christian', '1986-12-25'),

('request12@example.com', TRUE, NULL,
 'Photographer focusing on wildlife and nature.',
 'Clara', 'Reed',
 'https://images.unsplash.com/photo-1583138605411-f85466f61638?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDd8fHBob3RvZ3JhcGhlcnxlbnwwfDJ8MHx8fDA%3D',
 'https://plus.unsplash.com/premium_photo-1661962757852-72eb0a9a2a81?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8d2lsZGxpZmV8ZW58MHwwfDB8fHww',
 'Female', 'She/her', 'Portland', 'Vancouver', 'Photographer', 'Oregon State', 'Single',
 'Bisexual', 'Liberal', 'None', '1990-09-18'),

('request13@example.com', TRUE, NULL,
 'Chef specializing in fusion cuisine.',
 'Derek', 'Santos',
 'https://images.unsplash.com/photo-1583394293214-28ded15ee548?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Y2hlZnxlbnwwfDJ8MHx8fDA%3D',
 'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8ZnVzaW9uJTIwY3Vpc2luZXxlbnwwfDB8MHx8fDA%3D',
 'Male', 'He/him', 'San Francisco', 'Manila', 'Chef', 'Culinary Institute', 'Single',
 'Heterosexual', 'Progressive', 'Christian', '1988-08-21'),

('request14@example.com', TRUE, NULL,
 'Yoga teacher and mindfulness coach.',
 'Emily', 'Taylor',
 'https://images.unsplash.com/photo-1730672786211-c3c7fcad328e?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8eW9nYSUyMHRlYWNoZXJ8ZW58MHwyfDB8fHww',
 'https://images.unsplash.com/photo-1524863479829-916d8e77f114?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fHlvZ2F8ZW58MHwwfDB8fHww',
 'Female', 'She/her', 'Austin', 'Toronto', 'Yoga Instructor', 'UT Austin', 'Single',
 'Heterosexual', 'Liberal', 'Buddhist', '1992-03-10'),

('request15@example.com', TRUE, NULL,
 'Software engineer and open-source contributor.',
 'Felix', 'Upton',
 'https://images.unsplash.com/photo-1588544108061-3c44c505d45d?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGdheS4lMjBtYW58ZW58MHwyfDB8fHww',
 'https://plus.unsplash.com/premium_photo-1678565879444-f87c8bd9f241?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8c29mdHdhcmV8ZW58MHwwfDB8fHww',
 'Male', 'He/him', 'San Jose', 'London', 'Engineer', 'MIT', 'Single',
 'Gay', 'Progressive', 'Atheist', '1989-07-07');

-- 🔴 SEEDING FRIENDS TABLE 🔴 --
INSERT INTO friends (user_id, friend_id) VALUES
-- 20 friends for the test user
(1, 2),
(2, 1),
(1, 3),
(3, 1),
(1, 4),
(4, 1),
(1, 5),
(5, 1),
(1, 6),
(6, 1),
(1, 7),
(7, 1),
(1, 8),
(8, 1),
(1, 9),
(9, 1),
(1, 10),
(10, 1),
(1, 11),
(11, 1),
(1, 12),
(12, 1),
(1, 13),
(13, 1),
(1, 14),
(14, 1),
(1, 15),
(15, 1),
(1, 16),
(16, 1),
(1, 17),
(17, 1),
(1, 18),
(18, 1),
(1, 19),
(19, 1),
(1, 20),
(20, 1),
(1, 21),
(21, 1),

-- Mutual friendships among the 20 friends (reciprocal pairs)
-- Mutual 22 friends
(22, 2), (2, 22),
(22, 3), (3, 22),
(22, 4), (4, 22),

-- Mutual 23 friends
(23, 5), (5, 23),
(23, 6), (6, 23),
(23, 7), (7, 23),

-- Mutual 24 friends
(24, 8), (8, 24),
(24, 9), (9, 24),
(24, 10), (10, 24),

-- Mutual 25 friends
(25, 11), (11, 25),
(25, 12), (12, 25),
(25, 13), (13, 25),

-- Mutual 26 friends
(26, 14), (14, 26),
(26, 15), (15, 26),
(26, 16), (16, 26);

-- 🔴 SEEDING FRIEND REQUESTS TABLE 🔴 --
INSERT INTO friend_requests (sender_id, receiver_id, pending, sent_at)
VALUES
    (27, 1, TRUE, NOW() - INTERVAL '2 days'),
    (28, 1, TRUE, NOW() - INTERVAL '1 day'),
    (29, 1, TRUE, NOW() - INTERVAL '12 hours');

-- 🔴 SEEDING POSTS TABLE 🔴 --
-- Posts for Test User (id=1) --
INSERT INTO posts (user_id, forename, surname, content, post_image_src, time_stamp)
VALUES
    (1, 'Test', 'User', 'Just finished a great hike today! Feeling refreshed and alive.', NULL, '2025-05-22 18:43:10'),
    (1, 'Test', 'User', 'Experimenting with some new code ideas. Excited to see where this goes!', NULL, '2025-05-29 20:14:08'),
    (1, 'Test', 'User', NULL, 'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=1400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Y29mZmVlfGVufDB8MHwwfHx8MA%3D%3D', '2025-06-07 15:36:54'),
    (1, 'Test', 'User', NULL, 'https://images.unsplash.com/photo-1711032265178-3d06d4bfbf18?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8bGVnbyUyMG1hbnxlbnwwfDJ8MHx8fDA%3D', '2025-06-03 09:57:21'),
    (1, 'Test', 'User', 'Looking forward to the weekend and some quality downtime.', NULL, '2025-05-22 18:43:10'),

-- Posts for friends of Test User --
-- Alice Smith (id=2) --
    (2, 'Alice', 'Smith', 'Spinning my favorite vinyls all day. Music is the soul’s therapy!', NULL, '2025-05-22 03:26:42'),
    (2, 'Alice', 'Smith', 'Discovered a rare jazz record this weekend. Pure gold!', NULL, '2025-05-23 18:12:17'),
    (2, 'Alice', 'Smith', NULL, 'https://images.unsplash.com/photo-1724390265362-c58d0bc7d17a?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fG11c2ljJTIwZmVzdGl2YWx8ZW58MHwyfDB8fHww', '2025-05--5 13:30:45'),

-- Bob Johnson (id=3) --
    (3, 'Bob', 'Johnson', 'Spent the afternoon planting some new herbs in the garden. Feels great!', NULL, '2025-05-24 13:24:32'),
    (3, 'Bob', 'Johnson', 'Green thumbs unite! Any tips for keeping basil alive?', NULL, '2025-05-26 01:53:43'),
    (3, 'Bob', 'Johnson', NULL, 'https://images.unsplash.com/photo-1627989147125-a004d05946d3?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Z2FyZGVuaW5nfGVufDB8MnwwfHx8MA%3D%3D', '2025-05-05 13:47:34'),

-- Cara Lee (id=4) --
    (4, 'Cara', 'Lee', 'Chasing sunsets around the city. Every shot tells a story.', NULL, '2025-05-25 00:42:09'),
    (4, 'Cara', 'Lee', NULL, 'https://images.unsplash.com/photo-1690514570719-36875c9c3e7f?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fHN0cmVldCUyMGFydHxlbnwwfDJ8MHx8fDA%3D', '2025-05-05 06:21:43'),
    (4, 'Cara', 'Lee', 'Photography is my way of freezing moments in time.', NULL, '2025-05-31 01:28:11'),

-- David Chen (id=5) --
    (5, 'David', 'Chen', 'Brainstorming the next big AI project with the team.', NULL, '2025-05-14 22:37:40'),
    (5, 'David', 'Chen', 'Innovation never sleeps! Excited for what’s next.', NULL, '2025-05-20 15:15:32'),
    (5, 'David', 'Chen', NULL, 'https://images.unsplash.com/photo-1529353721-ae64f46030b6?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c3RyZWV0JTIwYXJ0fGVufDB8MnwwfHx8MA%3D%3D', '2025-06-03 18:39:20'),

-- Ella Brown (id=6) --
    (6, 'Ella', 'Brown', 'Yoga at sunrise is the best way to start the day.', NULL, '2025-05-20 15:50:19'),
    (6, 'Ella', 'Brown', 'Guided meditation sessions are helping my students unwind.', NULL, '2025-05-23 14:32:28'),
    (6, 'Ella', 'Brown', NULL, 'https://images.unsplash.com/photo-1611800065476-b295f882c8ea?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fHlvZ2F8ZW58MHwyfDB8fHww', '2025-05-21 21:43:39'),

-- Frank Davis (id=7) --
    (7, 'Frank', 'Davis', 'Lost in a good book this weekend. Recommendations welcome!', NULL, '2025-05-18 20:44:57'),
    (7, 'Frank', 'Davis', 'Podcasts keep me company on long walks.', NULL, '2025-05-28 00:17:22'),
    (7, 'Frank', 'Davis', NULL, 'https://images.unsplash.com/photo-1517596107285-5ce3dd0f61df?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGJvb2t8ZW58MHwyfDB8fHww', '2025-05-27 15:25:51'),

-- Grace Evans (id=8) --
    (8, 'Grace', 'Evans', 'New blog post live! Exploring sustainable fashion.', NULL, '2025-05-22 03:55:53'),
    (8, 'Grace', 'Evans', NULL, 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8ZmFzaGlvbnxlbnwwfDJ8MHx8fDA%3D', '2025-05-11 23:10:49'),
    (8, 'Grace', 'Evans', 'Style is a way to say who you are without speaking.', NULL, '2025-05-27 14:07:15'),

-- Henry Foster (id=9) --
    (9, 'Henry', 'Foster', 'Weekend ride through the mountains was epic!', NULL, '2025-05-30 18:40:57'),
    (9, 'Henry', 'Foster', 'Pushing limits and loving every second.', NULL, '2025-06-02 01:22:15'),
    (9, 'Henry', 'Foster', NULL, 'https://images.unsplash.com/photo-1679233767426-713ca299cd0a?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGJpa2luZ3xlbnwwfDJ8MHx8fDA%3D', '2025-06-01 10:46:54'),

-- Isabella Garcia (id=10) --
    (10, 'Isabella', 'Garcia', 'Experimenting with new vegan dessert recipes.', NULL, '2025-05-17 11:16:40'),
    (10, 'Isabella', 'Garcia', 'Sweet treats don’t have to be unhealthy.', NULL, '2025-05-24 19:41:14'),
    (10, 'Isabella', 'Garcia', NULL, 'https://plus.unsplash.com/premium_photo-1726797728786-efdc34d29aeb?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dmVnYW4lMjBkZXNzZXJ0fGVufDB8MnwwfHx8MA%3D%3D', '2025-05-01 19:26:15'),

-- Jack Harris (id=11) --
    (11, 'Jack', 'Harris', 'Drafting ideas for my next novel. Writer’s block? Never heard of it.', NULL, '2025-05-19 09:11:22'),
    (11, 'Jack', 'Harris', 'Everyday life holds the best stories.', NULL, '2025-05-29 17:56:34'),
    (11, 'Jack', 'Harris', NULL, 'https://plus.unsplash.com/premium_photo-1677567996070-68fa4181775a?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Ym9va3N8ZW58MHwwfDB8fHww', '2025-05-03 18:47:31'),

-- Kara Iverson (id=12) --
    (12, 'Kara', 'Iverson', 'Inspiring minds one lesson at a time.', NULL, '2025-05-15 18:40:31'),
    (12, 'Kara', 'Iverson', 'Education is the key to a brighter future.', NULL, '2025-05-27 17:39:52'),
    (12, 'Kara', 'Iverson', NULL, 'https://plus.unsplash.com/premium_photo-1723568428336-4b4e21ec91af?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8dGVhY2hpbmd8ZW58MHwyfDB8fHww', '2025-05-01 10:59:42'),

-- Liam Jackson (id=13) --
    (13, 'Liam', 'Jackson', 'Organizing a beach cleanup this weekend.', NULL, '2025-05-05 22:40:34'),
    (13, 'Liam', 'Jackson', 'Protecting our planet starts with us.', NULL, '2025-05-27 03:50:02'),
    (13, 'Liam', 'Jackson', NULL, 'https://images.unsplash.com/photo-1627118976394-990852371725?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8YmVhY2glMjBjbGVhbnVwfGVufDB8MnwwfHx8MA%3D%3D', '2025-05-17 06:42:22'),

-- Mia Kim (id=14) --
    (14, 'Mia', 'Kim', 'Live streaming tonight! Join me for some fun and games.', NULL, '2025-05-19 03:02:58'),
    (14, 'Mia', 'Kim', 'Thankful for the amazing community I have.', NULL, '2025-06-04 10:39:14'),
    (14, 'Mia', 'Kim', NULL, 'https://images.unsplash.com/photo-1622649755106-1f61a6b1b445?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGdhbWluZ3xlbnwwfDJ8MHx8fDA%3D', '2025-05-30 20:56:13'),

-- Noah Lopez (id=15) --
    (15, 'Noah', 'Lopez', 'Exploring the urban jungle through my lens.', NULL, '2025-05-18 19:42:44'),
    (15, 'Noah', 'Lopez', NULL, 'https://plus.unsplash.com/premium_photo-1682124843954-eb395dfa50ea?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dXJiYW4lMjBqdW5nbGV8ZW58MHwyfDB8fHww', '2025-05-27 07:34:34'),
    (15, 'Noah', 'Lopez', 'Photography is an adventure without limits.', NULL, '2025-05-30 08:48:12'),

-- Olivia Martinez (id=16) --
    (16, 'Olivia', 'Martinez', 'Writing songs that speak from the heart.', NULL, '2025-05-18 00:25:55'),
    (16, 'Olivia', 'Martinez', 'Music is my language.', NULL, '2025-06-01 07:30:52'),
    (16, 'Olivia', 'Martinez', NULL, 'https://images.unsplash.com/photo-1524650359799-842906ca1c06?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bXVzaWN8ZW58MHwyfDB8fHww', '2025-05-16 01:40:03'),

-- Peter Tran (id=17) --
    (17, 'Peter', 'Tran', 'Debugging code and drinking espresso. Perfect combo.', NULL, '2025-05-15 01:12:14'),
    (17, 'Peter', 'Tran', 'Launched a new app feature today!', NULL, '2025-05-25 06:45:02'),
    (17, 'Peter', 'Tran', NULL, 'https://images.unsplash.com/photo-1611691934391-5a8805e0bd1a?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZXNwcmVzc298ZW58MHwyfDB8fHww', '2025-05-03 23:06:12'),

-- Quinn Jefferson (id=18) --
    (18, 'Quinn', 'Jefferson', 'Training for the marathon. Every mile counts!', NULL, '2025-05-23 12:46:04'),
    (18, 'Quinn', 'Jefferson', 'Fitness is a journey, not a destination.', NULL, '2025-05-24 04:26:09'),
    (18, 'Quinn', 'Jefferson', NULL, 'https://plus.unsplash.com/premium_photo-1664304823165-888f56fc101b?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cnVubmluZ3xlbnwwfDJ8MHx8fDA%3D', '2025-06-04 11:41:13'),

-- Ryan Patel (id=19) --
    (19, 'Ryan', 'Patel', 'Mentoring young entrepreneurs is so rewarding.', NULL, '2025-05-24 08:46:28'),
    (19, 'Ryan', 'Patel', 'Pitching ideas and learning every day.', NULL, '2025-05-26 09:22:34'),
    (19, 'Ryan', 'Patel', NULL, 'https://plus.unsplash.com/premium_photo-1665520346947-a07db617d300?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8dGVhY2hpbmd8ZW58MHwyfDB8fHww', '2025-05-17 06:56:06'),

-- Sophia Quinn (id=20) --
    (20, 'Sophia', 'Quinn', 'Trying out a new vegan recipe today.', NULL, '2025-05-17 14:35:48'),
    (20, 'Sophia', 'Quinn', 'Food blogging is my passion.', NULL, '2025-05-24 20:47:30'),
    (20, 'Sophia', 'Quinn', NULL, 'https://plus.unsplash.com/premium_photo-1698867577020-38ae235fd612?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dmVnYW4lMjBmb29kfGVufDB8MnwwfHx8MA%3D%3D', '2025-06-01 03:28:15'),

-- Tom Henderson (id=21) --
    (21, 'Tom', 'Henderson', 'Performed at an open mic night. Loved every second!', NULL, '2025-05-31 13:44:42'),
    (21, 'Tom', 'Henderson', 'Laughter is the best medicine.', NULL, '2025-05-16 11:55:25'),
    (21, 'Tom', 'Henderson', NULL, 'https://images.unsplash.com/photo-1730875647521-81e8bc2fca1c?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Z2lnfGVufDB8MnwwfHx8MA%3D%3D', '2025-05-03 14:00:29'),

-- Posts for possible mutuals --
-- Nina Khan (id=22) --
    (22, 'Nina', 'Khan', 'Just booked my next trip to Kyoto! Can’t wait to explore the temples and sushi spots.', NULL, '2025-05-15 21:53:51'),
    (22, 'Nina', 'Khan', 'Learning Japanese every day. まだまだ勉強が必要ですね!', NULL, '2025-05-30 01:19:27'),
    (22, 'Nina', 'Khan', NULL, 'https://plus.unsplash.com/premium_photo-1664304460618-e27a37b4f05b?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8YmVhY2glMjBzdW5zZXR8ZW58MHwyfDB8fHww', '2025-05-18 04:53:41'),

-- Oscar Nguyen (id=23) --
    (23, 'Oscar', 'Nguyen', 'Built a new PC setup over the weekend. Loving the RGB glow!', NULL, '2025-05-16 00:07:06'),
    (23, 'Oscar', 'Nguyen', 'Streaming some co-op games tonight. Come hang out!', NULL, '2025-05-29 10:01:37'),
    (23, 'Oscar', 'Nguyen', NULL, 'https://images.unsplash.com/photo-1579493593963-2ca325e3703e?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHJnYiUyMHBjfGVufDB8MnwwfHx8MA%3D%3D', '2025-05-05 22:20:48'),

-- Priya Desai (id=24) --
    (24, 'Priya', 'Desai', 'Experimented with a new spicy curry recipe. Friends loved it!', NULL, '2025-05-16 14:03:47'),
    (24, 'Priya', 'Desai', NULL, 'https://plus.unsplash.com/premium_photo-1726797618903-1bca7ac038ff?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y3Vycnl8ZW58MHwyfDB8fHww', '2025-05-17 10:42:08'),
    (24, 'Priya', 'Desai', 'Nothing beats a homemade meal shared with family.', NULL, '2025-06-04 17:25:07'),

-- Lucas Morris (id=25) --
    (25, 'Lucas', 'Morris', 'Started planting heirloom tomatoes in the community garden.', NULL, '2025-05-16 07:44:37'),
    (25, 'Lucas', 'Morris', 'Urban farming is the future. Who’s with me?', NULL, '2025-06-02 05:37:13'),
    (25, 'Lucas', 'Morris', NULL, 'https://plus.unsplash.com/premium_photo-1723377607590-5aac4e48bb06?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dG9tYXRvZXN8ZW58MHwyfDB8fHww', '2025-06-02 02:55:45'),

-- Maya Patel (id=26) --
    (26, 'Maya', 'Patel', 'Painting a new mural downtown. Can’t wait to show the final piece!', NULL, '2025-05-19 22:11:54'),
    (26, 'Maya', 'Patel', 'Creativity flows best with coffee and good music.', NULL, '2025-05-22 04:47:45'),
    (26, 'Maya', 'Patel', NULL, 'https://images.unsplash.com/photo-1551366895-3532ca1f7ebb?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8bXVyYWx8ZW58MHwyfDB8fHww', '2025-05-01 15:32:47'),

-- 1 post each for request users --
    (27, 'Gloria', 'Turner', 'Jamming on some new tunes today — feeling inspired! 🎶', NULL, '2025-05-17 07:37:45'),
    (28, 'Raj', 'Singh', 'Early morning run done — pushing limits every day! 🏃‍♂️', NULL, '2025-05-27 09:50:01'),
    (29, 'Sara', 'Martinez', 'Working on a new poem inspired by the city lights.', NULL, '2025-05-22 22:40:20'),
    (30, 'Theo', 'Clark', 'Brainstorming ideas for my next eco-startup. Sustainability first!', NULL, '2025-05-25 20:45:36'),
    (31, 'Vera', 'Kim', 'Experimenting with digital and traditional paints — love the blend.', NULL, '2025-05-26 00:42:08'),
    (32, 'Wendy', 'Lopez', 'Just posted my latest travel blog — adventures await! ✈️', NULL, '2025-05-29 02:16:45'),
    (33, 'Xander', 'Morris', 'Sketching new comic characters — superheroes in the making!', NULL, '2025-05-25 01:56:41'),
    (34, 'Yara', 'Hoang', 'Perfected a new latte art design today — coffee bliss.', NULL, '2025-05-28 20:56:59'),
    (35, 'Zach', 'Daniels', 'Wrapping up edits on my latest short film — storytelling at its best.', NULL, '2025-05-19 23:43:43'),
    (36, 'Amy', 'Parker', 'Collecting data on climate patterns — science in action.', NULL, '2025-05-23 03:21:22'),
    (37, 'Brian', 'Watson', 'Training a new rescue pup — progress is amazing!', NULL, '2025-05-14 16:46:14'),
    (38, 'Clara', 'Reed', 'Captured some stunning shots of the forest wildlife today.', NULL, '2025-05-23 09:40:29'),
    (39, 'Derek', 'Santos', 'Cooked up a fusion feast last night — flavors exploded!', NULL, '2025-05-25 10:17:16'),
    (40, 'Emily', 'Taylor', 'Leading a mindfulness session — peace and calm everywhere.', NULL, '2025-05-31 04:44:58'),
    (41, 'Felix', 'Upton', 'Pushed a new update to my open-source project. Code is life.', NULL, '2025-06-01 15:28:28');

-- 🔴 SEEDING COMMENTS TABLE 🔴 --
INSERT INTO comments (postid, username, comment, time_stamp) VALUES

-- Test User - Post 1 comments
(1, 'friend1@example.com', 'Sounds amazing, hiking always resets my mind! Which trail did you hit?', NOW() - INTERVAL '4 days 20 hours'),
(1, 'friend2@example.com', 'Nothing beats fresh mountain air. Glad you had a great time!', NOW() - INTERVAL '4 days 18 hours'),
(1, 'friend3@example.com', 'Beautiful! Hope you snapped some photos to share.', NOW() - INTERVAL '4 days 15 hours'),

-- Test User - Post 2 comments
(2, 'friend4@example.com', 'Excited to hear about this.', NOW() - INTERVAL '3 days 20 hours'),

-- Test User - Post 3 comments
(3, 'friend5@example.com', 'Always! My morning ritual is incomplete without coffee.', NOW() - INTERVAL '2 days 22 hours'),
(3, 'friend6@example.com', 'Coffee is the secret ingredient to my creativity.', NOW() - INTERVAL '2 days 20 hours'),
(3, 'friend7@example.com', 'You’re speaking my language! What’s your favorite brew?', NOW() - INTERVAL '2 days 18 hours'),
(3, 'friend8@example.com', 'I’m more of a chai person, but coffee is a close second!', NOW() - INTERVAL '2 days 17 hours'),
(3, 'friend9@example.com', 'Big yes! Currently debugging with a latte on my desk.', NOW() - INTERVAL '2 days 16 hours'),

-- Test User - Post 5 comments
(5, 'friend10@example.com', 'You deserve it! Hope you get some great rest.', NOW() - INTERVAL '1 day 20 hours'),
(5, 'friend11@example.com', 'Weekend plans sound good — any outdoor adventures?', NOW() - INTERVAL '1 day 18 hours'),

-- Comments for test user's friend's posts
-- Alice Smith's posts
(6, 'request2@example.com', 'Vinyls are timeless. What’s spinning today?', NOW() - INTERVAL '4 days 22 hours'),
(7, 'mutual5@example.com', 'Jazz is life! Got any recommendations?', NOW() - INTERVAL '3 days 2 hours'),
(8, 'mutual4@example.com', 'Music festivals always bring the best vibes!', NOW() - INTERVAL '23 hours'),

-- Bob Johnson's posts
(9, 'mutual3@example.com', 'Basil can be tricky, but keep it sunny and watered.', NOW() - INTERVAL '2 days'),
(10, 'mutual1@example.com', 'Herb gardens are the best! Fresh pesto is the reward.', NOW() - INTERVAL '10 hours'),

-- Cara Lee's posts
(12, 'friend6@example.com', 'Sunsets make everything magical.', NOW() - INTERVAL '6 days'),
(13, 'request12@example.com', 'Street art colors always inspire me!', NOW() - INTERVAL '3 days 1 hour'),

-- David Chen's posts
(15, 'friend16@example.com', 'AI projects sound exciting! Can’t wait to hear about it.', NOW() - INTERVAL '5 days'),
(16, 'friend18@example.com', 'Tech conferences are where the magic happens.', NOW() - INTERVAL '1 day 20 hours'),

-- Ella Brown's posts
(18, 'request14@example.com', 'Yoga at sunrise is truly refreshing!', NOW() - INTERVAL '4 days 6 hours'),
(19, 'friend13@example.com', 'Meditation really helps me stay focused.', NOW() - INTERVAL '2 days 22 hours'),

-- Frank Davis's posts
(21, 'request3@example.com', 'Books and podcasts — perfect combo for a lazy weekend.', NOW() - INTERVAL '5 days 20 hours'),

--Grace Evans's posts
(24, 'request5@example.com', 'Sustainable fashion is the future!', NOW() - INTERVAL '5 days'),
(25, 'request6@example.com', 'Fashion week vibes are so inspiring.', NOW() - INTERVAL '2 days 21 hours'),

--Henry Foster's posts
(27, 'request2@example.com', 'Epic rides are the best way to recharge.', NOW() - INTERVAL '5 days 22 hours'),

-- Isabella Garcia's posts
(31, 'friend19@example.com', 'Raw chocolate tart? Yum, sounds delicious!', NOW() - INTERVAL '1 day'),

--Jack Hsrris's posts
(33, 'request3@example.com', 'Writer’s block is real, but you’re smashing it!', NOW() - INTERVAL '3 days 10 hours'),

(37, 'request4@example.com', 'Creative curriculums shape the future.', NOW() - INTERVAL '3 days'),

(39, 'request10@example.com', 'Beach cleanups are so important for the environment.', NOW() - INTERVAL '5 days'),

(43, 'request6@example.com', 'Congrats on the milestone! Keep streaming.', NOW() - INTERVAL '2 days'),

(45, 'request12@example.com', 'Cityscapes always tell a unique story.', NOW() - INTERVAL '3 days'),

(48, 'request1@example.com', 'Local gigs have the best vibes. Keep it up!', NOW() - INTERVAL '1 day 12 hours'),

(51, 'request15@example.com', 'Coffee and code — can’t live without them.', NOW() - INTERVAL '1 day 4 hours'),

(54, 'request2@example.com', 'Every mile counts. Keep pushing!', NOW() - INTERVAL '2 days'),

(58, 'request4@example.com', 'Startup life is wild but so rewarding.', NOW() - INTERVAL '3 days'),

(61, 'request5@example.com', 'Keep on keeping on. Strength and love.', NOW() - INTERVAL '2 days'),

(63, 'friend1@example.com', 'Open mic nights are such a great way to connect.', NOW() - INTERVAL '5 days'),

(66, 'friend12@example.com', 'Kyoto is amazing! Don’t miss the bamboo forest.', NOW() - INTERVAL '4 days 20 hours'),
(67, 'friend19@example.com', 'Learning Japanese is so rewarding, 頑張って!', NOW() - INTERVAL '3 days 4 hours'),
(68, 'friend13@example.com', 'That sunset looks stunning! Perfect travel vibes.', NOW() - INTERVAL '23 hours'),

(69, 'friend10@example.com', 'RGB lighting really sets the mood, nice setup!', NOW() - INTERVAL '6 days 2 hours'),
(70, 'friend3@example.com', 'Co-op gaming sounds fun. Count me in!', NOW() - INTERVAL '2 days 22 hours'),

(72, 'friend5@example.com', 'Spicy curry sounds delicious. Recipe, please?', NOW() - INTERVAL '5 days'),
(74, 'friend1@example.com', 'Homemade meals are the best kind of love.', NOW() - INTERVAL '1 day 3 hours 52 minutes'),

(75, 'friend12@example.com', 'Heirloom tomatoes are the tastiest!', NOW() - INTERVAL '5 days 22 hours'),
(76, 'request2@example.com', 'Urban farming is definitely the future.', NOW() - INTERVAL '2 days 23 hours'),

(78, 'friend15@example.com', 'Can’t wait to see your mural!', NOW() - INTERVAL '4 days 23 hours 11 minutes'),
(79, 'friend18@example.com', 'Coffee and creativity are a perfect combo.', NOW() - INTERVAL '3 days 1 hour 47 minutes');

-- 🔴 SEEDING LIKES TABLE 🔴 --

-- Likes seed data with 0-5 likes per post/comment

INSERT INTO likes (user_id, liked_type, liked_id) VALUES
-- Post likes
-- 1 like for all posts
(2, 'post', 1),
(2, 'post', 2),
(2, 'post', 3),
(2, 'post', 4),
(2, 'post', 5),
(2, 'post', 6),
(2, 'post', 7),
(2, 'post', 8),
(2, 'post', 9),
(2, 'post', 10),
(2, 'post', 11),
(2, 'post', 12),
(2, 'post', 13),
(2, 'post', 14),
(2, 'post', 15),
(2, 'post', 16),
(2, 'post', 17),
(2, 'post', 18),
(2, 'post', 19),
(2, 'post', 20),
(2, 'post', 21),
(2, 'post', 22),
(2, 'post', 23),
(2, 'post', 24),
(2, 'post', 25),
(2, 'post', 26),
(2, 'post', 27),
(2, 'post', 28),
(2, 'post', 29),
(2, 'post', 30),
(2, 'post', 31),
(2, 'post', 32),
(2, 'post', 33),
(2, 'post', 34),
(2, 'post', 35),
(2, 'post', 36),
(2, 'post', 37),
(2, 'post', 38),
(2, 'post', 39),
(2, 'post', 40),
(2, 'post', 41),
(2, 'post', 42),
(2, 'post', 43),
(2, 'post', 44),
(2, 'post', 45),
(2, 'post', 46),
(2, 'post', 47),
(2, 'post', 48),
(2, 'post', 49),
(2, 'post', 50),
(2, 'post', 51),
(2, 'post', 52),
(2, 'post', 53),
(2, 'post', 54),
(2, 'post', 55),
(2, 'post', 56),
(2, 'post', 57),
(2, 'post', 58),
(2, 'post', 59),
(2, 'post', 60),
(2, 'post', 61),
(2, 'post', 62),
(2, 'post', 63),
(2, 'post', 64),
(2, 'post', 65),
(2, 'post', 66),
(2, 'post', 67),
(2, 'post', 68),
(2, 'post', 69),
(2, 'post', 70),
(2, 'post', 71),
(2, 'post', 72),
(2, 'post', 73),
(2, 'post', 74),
(2, 'post', 75),
(2, 'post', 76),
(2, 'post', 77),
(2, 'post', 78),
(2, 'post', 79),
(2, 'post', 80),
(2, 'post', 81),
(2, 'post', 82),
(2, 'post', 83),
(2, 'post', 84),
(2, 'post', 85),
(2, 'post', 86),
(2, 'post', 87),
(2, 'post', 88),
(2, 'post', 89),
(2, 'post', 90),
(2, 'post', 91),
(2, 'post', 92),
(2, 'post', 93),
(2, 'post', 94),
(2, 'post', 95),

--2 likes for all posts
(3, 'post', 1),
(3, 'post', 2),
(3, 'post', 3),
(3, 'post', 4),
(3, 'post', 5),
(3, 'post', 6),
(3, 'post', 7),
(3, 'post', 8),
(3, 'post', 9),
(3, 'post', 10),
(3, 'post', 11),
(3, 'post', 12),
(3, 'post', 13),
(3, 'post', 14),
(3, 'post', 15),
(3, 'post', 16),
(3, 'post', 17),
(3, 'post', 18),
(3, 'post', 19),
(3, 'post', 20),
(3, 'post', 21),
(3, 'post', 22),
(3, 'post', 23),
(3, 'post', 24),
(3, 'post', 25),
(3, 'post', 26),
(3, 'post', 27),
(3, 'post', 28),
(3, 'post', 29),
(3, 'post', 30),
(3, 'post', 31),
(3, 'post', 32),
(3, 'post', 33),
(3, 'post', 34),
(3, 'post', 35),
(3, 'post', 36),
(3, 'post', 37),
(3, 'post', 38),
(3, 'post', 39),
(3, 'post', 40),
(3, 'post', 41),
(3, 'post', 42),
(3, 'post', 43),
(3, 'post', 44),
(3, 'post', 45),
(3, 'post', 46),
(3, 'post', 47),
(3, 'post', 48),
(3, 'post', 49),
(3, 'post', 50),
(3, 'post', 51),
(3, 'post', 52),
(3, 'post', 53),
(3, 'post', 54),
(3, 'post', 55),
(3, 'post', 56),
(3, 'post', 57),
(3, 'post', 58),
(3, 'post', 59),
(3, 'post', 60),
(3, 'post', 61),
(3, 'post', 62),
(3, 'post', 63),
(3, 'post', 64),
(3, 'post', 65),
(3, 'post', 66),
(3, 'post', 67),
(3, 'post', 68),
(3, 'post', 69),
(3, 'post', 70),
(3, 'post', 71),
(3, 'post', 72),
(3, 'post', 73),
(3, 'post', 74),
(3, 'post', 75),
(3, 'post', 76),
(3, 'post', 77),
(3, 'post', 78),
(3, 'post', 79),
(3, 'post', 80),
(3, 'post', 81),
(3, 'post', 82),
(3, 'post', 83),
(3, 'post', 84),
(3, 'post', 85),
(3, 'post', 86),
(3, 'post', 87),
(3, 'post', 88),
(3, 'post', 89),
(3, 'post', 90),
(3, 'post', 91),
(3, 'post', 92),
(3, 'post', 93),
(3, 'post', 94),
(3, 'post', 95),

-- Likes for most posts, skewed to test user and friends
(4, 'post', 1),
(4, 'post', 2),
(4, 'post', 3),
(4, 'post', 4),
(4, 'post', 5),
(4, 'post', 7),
(4, 'post', 8),
(4, 'post', 10),
(4, 'post', 11),
(4, 'post', 13),
(4, 'post', 14),
(4, 'post', 16),
(4, 'post', 17),
(4, 'post', 19),
(4, 'post', 20),
(4, 'post', 21),
(4, 'post', 22),
(4, 'post', 23),
(4, 'post', 25),
(4, 'post', 26),
(4, 'post', 28),
(4, 'post', 29),
(4, 'post', 35),
(4, 'post', 36),
(4, 'post', 38),
(4, 'post', 39),
(4, 'post', 40),
(4, 'post', 41),
(4, 'post', 42),
(4, 'post', 43),
(4, 'post', 44),
(4, 'post', 45),
(4, 'post', 46),
(4, 'post', 47),
(4, 'post', 49),
(4, 'post', 51),
(4, 'post', 53),
(4, 'post', 54),
(4, 'post', 55),
(4, 'post', 56),
(4, 'post', 58),
(4, 'post', 60),
(4, 'post', 62),
(4, 'post', 66),
(4, 'post', 67),
(4, 'post', 68),
(4, 'post', 70),
(4, 'post', 71),
(4, 'post', 77),
(4, 'post', 81),
(4, 'post', 87),
(4, 'post', 88),
(4, 'post', 92),
(4, 'post', 93),
(4, 'post', 94),

-- likes for some posts
(5, 'post', 1),
(5, 'post', 3),
(5, 'post', 4),
(5, 'post', 7),
(5, 'post', 8),
(5, 'post', 10),
(5, 'post', 11),
(5, 'post', 13),
(5, 'post', 16),
(5, 'post', 17),
(5, 'post', 21),
(5, 'post', 23),
(5, 'post', 26),
(5, 'post', 28),
(5, 'post', 36),
(5, 'post', 42),
(5, 'post', 43),
(5, 'post', 47),
(5, 'post', 51),
(5, 'post', 53),
(5, 'post', 58),
(5, 'post', 60),
(5, 'post', 62),
(5, 'post', 77),
(5, 'post', 81),

-- likes for few posts
(6, 'post', 1),
(6, 'post', 4),
(6, 'post', 7),
(6, 'post', 8),
(6, 'post', 13),
(6, 'post', 16),
(6, 'post', 17),
(6, 'post', 21),
(6, 'post', 47),
(6, 'post', 51),
(6, 'post', 58),
(6, 'post', 62),
(6, 'post', 81),

-- Comment likes
-- 1 like for all comments
(2, 'comment', 1),
(2, 'comment', 2),
(2, 'comment', 3),
(2, 'comment', 4),
(2, 'comment', 5),
(2, 'comment', 6),
(2, 'comment', 7),
(2, 'comment', 8),
(2, 'comment', 9),
(2, 'comment', 10),
(2, 'comment', 11),
(2, 'comment', 12),
(2, 'comment', 13),
(2, 'comment', 14),
(2, 'comment', 15),
(2, 'comment', 16),
(2, 'comment', 17),
(2, 'comment', 18),
(2, 'comment', 19),
(2, 'comment', 20),
(2, 'comment', 21),
(2, 'comment', 22),
(2, 'comment', 23),
(2, 'comment', 24),
(2, 'comment', 25),
(2, 'comment', 26),
(2, 'comment', 27),
(2, 'comment', 28),
(2, 'comment', 29),
(2, 'comment', 30),
(2, 'comment', 31),
(2, 'comment', 32),
(2, 'comment', 33),
(2, 'comment', 34),
(2, 'comment', 35),
(2, 'comment', 36),
(2, 'comment', 37),
(2, 'comment', 38),
(2, 'comment', 39),
(2, 'comment', 40),
(2, 'comment', 41),
(2, 'comment', 42),
(2, 'comment', 43),
(2, 'comment', 44),
(2, 'comment', 45),
(2, 'comment', 46),
(2, 'comment', 47),
(2, 'comment', 48),
(2, 'comment', 49),

-- 2 likes for all comments
(3, 'comment', 1),
(3, 'comment', 2),
(3, 'comment', 3),
(3, 'comment', 4),
(3, 'comment', 5),
(3, 'comment', 6),
(3, 'comment', 7),
(3, 'comment', 8),
(3, 'comment', 9),
(3, 'comment', 10),
(3, 'comment', 11),
(3, 'comment', 12),
(3, 'comment', 13),
(3, 'comment', 14),
(3, 'comment', 15),
(3, 'comment', 16),
(3, 'comment', 17),
(3, 'comment', 18),
(3, 'comment', 19),
(3, 'comment', 20),
(3, 'comment', 21),
(3, 'comment', 22),
(3, 'comment', 23),
(3, 'comment', 24),
(3, 'comment', 25),
(3, 'comment', 26),
(3, 'comment', 27),
(3, 'comment', 28),
(3, 'comment', 29),
(3, 'comment', 30),
(3, 'comment', 31),
(3, 'comment', 32),
(3, 'comment', 33),
(3, 'comment', 34),
(3, 'comment', 35),
(3, 'comment', 36),
(3, 'comment', 37),
(3, 'comment', 38),
(3, 'comment', 39),
(3, 'comment', 40),
(3, 'comment', 41),
(3, 'comment', 42),
(3, 'comment', 43),
(3, 'comment', 44),
(3, 'comment', 45),
(3, 'comment', 46),
(3, 'comment', 47),
(3, 'comment', 48),
(3, 'comment', 49),

-- Likes for most comments
(4, 'comment', 1),
(4, 'comment', 2),
(4, 'comment', 3),
(4, 'comment', 4),
(4, 'comment', 5),
(4, 'comment', 7),
(4, 'comment', 8),
(4, 'comment', 10),
(4, 'comment', 11),
(4, 'comment', 13),
(4, 'comment', 14),
(4, 'comment', 16),
(4, 'comment', 17),
(4, 'comment', 19),
(4, 'comment', 20),
(4, 'comment', 21),
(4, 'comment', 23),
(4, 'comment', 25),
(4, 'comment', 28),
(4, 'comment', 29),
(4, 'comment', 35),
(4, 'comment', 36),
(4, 'comment', 39),
(4, 'comment', 40),
(4, 'comment', 41),
(4, 'comment', 43),
(4, 'comment', 44),
(4, 'comment', 46),
(4, 'comment', 49),

-- likes for some comments
(5, 'comment', 1),
(5, 'comment', 3),
(5, 'comment', 4),
(5, 'comment', 8),
(5, 'comment', 11),
(5, 'comment', 16),
(5, 'comment', 17),
(5, 'comment', 26),
(5, 'comment', 36),
(5, 'comment', 47),

-- likes for a few comments
(6, 'comment', 1),
(6, 'comment', 3),
(6, 'comment', 17),
(6, 'comment', 36);