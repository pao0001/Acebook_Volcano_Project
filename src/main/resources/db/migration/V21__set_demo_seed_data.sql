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
 'https://randomuser.me/api/portraits/women/1.jpg', 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?auto=format&fit=crop&w=800&q=80',
 'Female', 'She/her', 'New York', 'Boston', 'DJ', 'NYU', 'Single',
 'Heterosexual', 'Liberal', 'Jewish', '1988-01-15'),

('friend2@example.com', TRUE, NULL,
 'Gardener and nature enthusiast. Has a secret herb garden at home.',
 'Bob', 'Johnson',
 'https://randomuser.me/api/portraits/men/2.jpg', 'https://images.unsplash.com/photo-1516253593875-bd7ba052fbc5?q=80&w=3540&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
 'Male', 'He/him', 'Seattle', 'Portland', 'Botanist', 'University of Washington', 'Married',
 'Heterosexual', 'Moderate', 'Christian', '1975-03-20'),

('friend3@example.com', TRUE, NULL,
 'Photographer capturing everyday beauty. Loves street photography and sunsets.',
 'Cara', 'Lee',
 'https://randomuser.me/api/portraits/women/3.jpg', 'https://images.unsplash.com/photo-1503803548695-c2a7b4a5b875?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c3Vuc2V0fGVufDB8MHwwfHx8MA%3D%3D',
 'Female', 'She/her', 'Chicago', 'Detroit', 'Photographer', 'Columbia College', 'Single',
 'Bisexual', 'Progressive', 'Buddhist', '1992-07-22'),

('friend4@example.com', TRUE, NULL,
 'Tech startup founder passionate about AI and innovation.',
 'David', 'Chen',
 'https://randomuser.me/api/portraits/men/4.jpg', 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fHRlY2h8ZW58MHwwfDB8fHww',
 'Male', 'He/him', 'San Francisco', 'Shanghai', 'Entrepreneur', 'Stanford', 'Single',
 'Heterosexual', 'Progressive', 'Atheist', '1987-09-09'),

('friend5@example.com', TRUE, NULL,
 'Yoga instructor and wellness advocate.',
 'Ella', 'Brown',
 'https://randomuser.me/api/portraits/women/5.jpg', 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8eW9nYXxlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'Austin', 'Dallas', 'Yoga Instructor', 'UT Austin', 'Married',
 'Heterosexual', 'Liberal', 'Hindu', '1990-12-11'),

('friend6@example.com', TRUE, NULL,
 'Loves books, podcasts, and long walks in the park.',
 'Frank', 'Davis',
 'https://randomuser.me/api/portraits/men/6.jpg', 'https://images.unsplash.com/photo-1622050956578-94fd044a0ada?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cGFya3xlbnwwfDB8MHx8fDA%3D',
 'Male', 'He/him', 'Denver', 'Chicago', 'Editor', 'University of Chicago', 'Single',
 'Heterosexual', 'Moderate', 'Christian', '1986-08-02'),

('friend7@example.com', TRUE, NULL,
 'Fashion enthusiast and part-time blogger.',
 'Grace', 'Evans',
 'https://randomuser.me/api/portraits/women/7.jpg', 'https://plus.unsplash.com/premium_photo-1664202526559-e21e9c0fb46a?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZmFzaGlvbnxlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'Los Angeles', 'Miami', 'Fashion Designer', 'Parsons', 'Single',
 'Lesbian', 'Liberal', 'None', '1993-04-14'),

('friend8@example.com', TRUE, NULL,
 'Biker and adrenaline junkie. Always up for a challenge.',
 'Henry', 'Foster',
 'https://randomuser.me/api/portraits/men/8.jpg', 'https://images.unsplash.com/photo-1556221620-3616894469d9?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8bW91bnRhaW4lMjBiaWtpbmd8ZW58MHwwfDB8fHww',
 'Male', 'He/him', 'Portland', 'Seattle', 'Mechanic', 'Oregon State', 'Married',
 'Heterosexual', 'Conservative', 'Atheist', '1982-11-07'),

('friend9@example.com', TRUE, NULL,
 'Chef specializing in vegan desserts.',
 'Isabella', 'Garcia',
 'https://randomuser.me/api/portraits/women/9.jpg', 'https://plus.unsplash.com/premium_photo-1694790026920-2bead0a7d993?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dmVnYW4lMjBkZXNzZXJ0fGVufDB8MHwwfHx8MA%3D%3D',
 'Non-binary', 'They/them', 'New York', 'Los Angeles', 'Chef', 'Culinary Institute', 'Single',
 'Pansexual', 'Progressive', 'Agnostic', '1991-01-19'),

('friend10@example.com', TRUE, NULL,
 'Aspiring novelist who finds inspiration in everyday life.',
 'Jack', 'Harris',
 'https://randomuser.me/api/portraits/men/10.jpg', 'https://plus.unsplash.com/premium_photo-1724176267196-7121b3d21e7f?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8bm92ZWxpc3R8ZW58MHwwfDB8fHww',
 'Male', 'He/him', 'Boston', 'Philadelphia', 'Writer', 'Boston University', 'Single',
 'Heterosexual', 'Liberal', 'None', '1990-07-04'),

('friend11@example.com', TRUE, NULL,
 'Teacher and lifelong learner.',
 'Kara', 'Iverson',
 'https://randomuser.me/api/portraits/women/11.jpg', 'https://images.unsplash.com/photo-1503676260728-1c00da094a0b?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fHRlYWNoZXJ8ZW58MHwwfDB8fHww',
 'Female', 'She/her', 'Atlanta', 'Nashville', 'Teacher', 'Vanderbilt', 'Married',
 'Heterosexual', 'Moderate', 'Christian', '1988-12-22'),

('friend12@example.com', TRUE, NULL,
 'Environmental activist and volunteer.',
 'Liam', 'Jackson',
 'https://randomuser.me/api/portraits/men/12.jpg', 'https://images.unsplash.com/photo-1472313420546-a46e561861d8?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZW52aXJvbm1lbnR8ZW58MHwwfDB8fHww',
 'Male', 'He/him', 'Seattle', 'Vancouver', 'Activist', 'University of Washington', 'Single',
 'Heterosexual', 'Progressive', 'Buddhist', '1994-06-09'),

('friend13@example.com', TRUE, NULL,
 'Gamer and streamer who loves interacting with fans.',
 'Mia', 'Kim',
 'https://randomuser.me/api/portraits/women/13.jpg', 'https://images.unsplash.com/photo-1598550476439-6847785fcea6?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Z2FtZSUyMHN0cmVhbWluZ3xlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'San Diego', 'Seoul', 'Streamer', 'UCSD', 'Single',
 'Bisexual', 'Liberal', 'None', '1995-02-28'),

('friend14@example.com', TRUE, NULL,
 'Photographer who loves capturing urban life.',
 'Noah', 'Lopez',
 'https://randomuser.me/api/portraits/men/14.jpg', 'https://images.unsplash.com/photo-1558985789-c73070851265?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTZ8fHVyYmFuJTIwcGhvdG9ncmFwaHl8ZW58MHwwfDB8fHww',
 'Male', 'He/him', 'Chicago', 'Mexico City', 'Photographer', 'Columbia College', 'Single',
 'Heterosexual', 'Moderate', 'Catholic', '1992-09-15'),

('friend15@example.com', TRUE, NULL,
 'Musician and songwriter.',
 'Olivia', 'Martinez',
 'https://randomuser.me/api/portraits/women/15.jpg', 'https://images.unsplash.com/photo-1595971294624-80bcf0d7eb24?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bXVzaWNpYW58ZW58MHwwfDB8fHww',
 'Female', 'She/her', 'Austin', 'Houston', 'Musician', 'UT Austin', 'Single',
 'Heterosexual', 'Liberal', 'Christian', '1990-11-21'),

('friend16@example.com', TRUE, NULL,
 'Software developer and coffee addict.',
 'Peter', 'Nguyen',
 'https://randomuser.me/api/portraits/men/16.jpg', 'https://plus.unsplash.com/premium_photo-1674327105074-46dd8319164b?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8Y29mZmVlfGVufDB8MHwwfHx8MA%3D%3D',
 'Male', 'He/him', 'San Francisco', 'Hanoi', 'Developer', 'Stanford', 'Single',
 'Gay', 'Progressive', 'Atheist', '1987-03-03'),

('friend17@example.com', TRUE, NULL,
 'Fitness coach and marathon runner.',
 'Quinn', 'Jefferson',
 'https://randomuser.me/api/portraits/women/17.jpg', 'https://images.unsplash.com/photo-1571008887538-b36bb32f4571?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cnVubmluZ3xlbnwwfDB8MHx8fDA%3D',
 'Non-binary', 'They/them', 'Denver', 'Boston', 'Coach', 'Boston University', 'Single',
 'Queer', 'Moderate', 'Christian', '1985-10-10'),

('friend18@example.com', TRUE, NULL,
 'Entrepreneur and startup mentor.',
 'Ryan', 'Patel',
 'https://randomuser.me/api/portraits/men/18.jpg', 'https://images.unsplash.com/photo-1665686310429-ee43624978fa?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8ZW50cmVwcmVuZXVyfGVufDB8MHwwfHx8MA%3D%3D',
 'Male', 'He/him', 'San Jose', 'Ahmedabad', 'Entrepreneur', 'MIT', 'Married',
 'Heterosexual', 'Conservative', 'Hindu', '1983-07-08'),

('friend19@example.com', TRUE, NULL,
 'Chef and food blogger.',
 'Sophia', 'Quinn',
 'https://randomuser.me/api/portraits/women/19.jpg', 'https://images.unsplash.com/photo-1577106263724-2c8e03bfe9cf?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Y2hlZnxlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'New Orleans', 'Atlanta', 'Chef', 'Culinary Institute', 'Single',
 'Bisexual', 'Liberal', 'None', '1991-05-12'),

('friend20@example.com', TRUE, NULL,
 'Comedian who uses humor to brighten the darkest days. A quick wit and infectious laugh.',
 'Tom', 'Henderson',
 'https://randomuser.me/api/portraits/men/20.jpg', 'https://images.unsplash.com/photo-1571173069043-82a7a13cee9f?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Y29tZWRpYW58ZW58MHwwfDB8fHww',
 'Male', 'He/him', 'Chicago', 'Detroit', 'Stand-up Comedian', 'DePaul University', 'Single',
 'Heterosexual', 'Moderate', 'None', '1989-06-28'),

-- Mutual friend recommendations (friends of friends, 22-26) --
('mutual1@example.com', TRUE, NULL,
 'Avid traveler and language learner. Currently obsessed with Japanese culture.',
 'Nina', 'Khan',
 'https://randomuser.me/api/portraits/women/31.jpg', 'https://images.unsplash.com/photo-1526481280693-3bfa7568e0f3?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGphcGFuZXNlfGVufDB8MHwwfHx8MA%3D%3D',
 'Female', 'She/her', 'San Diego', 'Karachi', 'Translator', 'UCLA', 'Single',
 'Heterosexual', 'Progressive', 'Muslim', '1991-03-05'),

('mutual2@example.com', TRUE, NULL,
 'Tech geek and gamer. Loves building PCs and streaming gameplays.',
 'Oscar', 'Nguyen',
 'https://randomuser.me/api/portraits/men/32.jpg', 'https://images.unsplash.com/photo-1591238372338-22d30c883a86?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8cGMlMjBidWlsZHxlbnwwfDB8MHx8fDA%3D',
 'Male', 'He/him', 'Austin', 'Hanoi', 'Software Engineer', 'UT Austin', 'Single',
 'Gay', 'Liberal', 'Atheist', '1994-09-17'),

('mutual3@example.com', TRUE, NULL,
 'Chef with a love for spicy dishes and sharing meals with friends.',
 'Priya', 'Desai',
 'https://randomuser.me/api/portraits/women/33.jpg', 'https://plus.unsplash.com/premium_photo-1707227861789-475326479c2b?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y3Vycnl8ZW58MHwwfDB8fHww',
 'Female', 'She/her', 'New Orleans', 'Mumbai', 'Chef', 'Culinary Institute', 'Married',
 'Heterosexual', 'Moderate', 'Hindu', '1987-11-02'),

('mutual4@example.com', TRUE, NULL,
 'Passionate about urban farming and community gardens.',
 'Lucas', 'Morris',
 'https://randomuser.me/api/portraits/men/34.jpg', 'https://plus.unsplash.com/premium_photo-1663090966558-e62333420712?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y29tbXVuaXR5JTIwZ2FyZGVufGVufDB8MHwwfHx8MA%3D%3D',
 'Male', 'He/him', 'Portland', 'Seattle', 'Agriculturalist', 'Oregon State', 'Single',
 'Heterosexual', 'Liberal', 'Christian', '1986-04-18'),

('mutual5@example.com', TRUE, NULL,
 'Painter and art teacher, spreading color and creativity.',
 'Maya', 'Patel',
 'https://randomuser.me/api/portraits/women/35.jpg', 'https://images.unsplash.com/photo-1601220959415-375d328bddc4?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8cGFpbnRlcnxlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'Santa Fe', 'Ahmedabad', 'Artist', 'RISD', 'Single',
 'Bisexual', 'Progressive', 'Hindu', '1993-08-29'),

-- Non-friend users for friend requests (27-41) --
('request1@example.com', TRUE, NULL,
 'Aspiring musician who’s always jamming and writing songs.',
 'Quinn', 'Turner',
 'https://randomuser.me/api/portraits/women/36.jpg', 'https://images.unsplash.com/photo-1574540346054-8a91eb807cfb?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8c29uZ3dyaXRlcnxlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'Nashville', 'Memphis', 'Musician', 'Berklee', 'Single',
 'Bisexual', 'Liberal', 'Christian', '1993-08-11'),

('request2@example.com', TRUE, NULL,
 'Fitness enthusiast and marathon runner. Loves to challenge limits.',
 'Raj', 'Singh',
 'https://randomuser.me/api/portraits/men/37.jpg', 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8Zml0bmVzc3xlbnwwfDB8MHx8fDA%3D',
 'Male', 'He/him', 'Denver', 'New Delhi', 'Personal Trainer', 'University of Colorado', 'Single',
 'Heterosexual', 'Moderate', 'Sikh', '1985-04-23'),

('request3@example.com', TRUE, NULL,
 'Writer and poet who finds magic in everyday moments.',
 'Sara', 'Martinez',
 'https://randomuser.me/api/portraits/women/38.jpg', 'https://plus.unsplash.com/premium_photo-1684444605542-93725082d214?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cG9ldHxlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'Boston', 'Madrid', 'Author', 'Boston University', 'Single',
 'Heterosexual', 'Progressive', 'Catholic', '1990-12-30'),

('request4@example.com', TRUE, NULL,
 'Entrepreneur passionate about eco-friendly startups and sustainability.',
 'Theo', 'Clark',
 'https://randomuser.me/api/portraits/men/39.jpg', 'https://plus.unsplash.com/premium_photo-1661368421663-13b2d8115241?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZWNvJTIwZnJpZW5kbHl8ZW58MHwwfDB8fHww',
 'Male', 'He/him', 'San Francisco', 'Seattle', 'Entrepreneur', 'Stanford', 'Single',
 'Heterosexual', 'Progressive', 'Agnostic', '1988-06-15'),

('request5@example.com', TRUE, NULL,
 'Artist exploring digital media and traditional painting.',
 'Vera', 'Kim',
 'https://randomuser.me/api/portraits/women/40.jpg', 'https://images.unsplash.com/photo-1591200687746-73cfd588ea5e?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8YXJ0aXN0fGVufDB8MHwwfHx8MA%3D%3D',
 'Female', 'She/her', 'Los Angeles', 'Seoul', 'Artist', 'CalArts', 'Single',
 'Lesbian', 'Liberal', 'Buddhist', '1992-05-27'),

('request6@example.com', TRUE, NULL,
 'Travel blogger sharing adventures from around the globe.',
 'Wendy', 'Lopez',
 'https://randomuser.me/api/portraits/women/41.jpg', 'https://images.unsplash.com/photo-1469854523086-cc02fe5d8800?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8dHJhdmVsfGVufDB8MHwwfHx8MA%3D%3D',
 'Female', 'She/her', 'Miami', 'Havana', 'Blogger', 'Florida State', 'Single',
 'Heterosexual', 'Liberal', 'Christian', '1993-07-16'),

('request7@example.com', TRUE, NULL,
 'Comic book artist and superhero fan.',
 'Xander', 'Morris',
 'https://randomuser.me/api/portraits/men/42.jpg', 'https://plus.unsplash.com/premium_photo-1725404409133-61938ac37719?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y29taWMlMjBib29rfGVufDB8MHwwfHx8MA%3D%3D',
 'Male', 'He/him', 'New York', 'Chicago', 'Artist', 'School of Visual Arts', 'Single',
 'Heterosexual', 'Moderate', 'Atheist', '1989-02-24'),

('request8@example.com', TRUE, NULL,
 'Barista and coffee aficionado.',
 'Yara', 'Nguyen',
 'https://randomuser.me/api/portraits/women/43.jpg', 'https://images.unsplash.com/photo-1507915135761-41a0a222c709?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YmFyaXN0YXxlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'Seattle', 'Ho Chi Minh City', 'Barista', 'Seattle Central', 'Single',
 'Heterosexual', 'Liberal', 'None', '1991-11-30'),

('request9@example.com', TRUE, NULL,
 'Film director and storyteller.',
 'Zach', 'Daniels',
 'https://randomuser.me/api/portraits/men/44.jpg', 'https://plus.unsplash.com/premium_photo-1682125771198-f7cbed7cb868?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8ZmlsbSUyMGRpcmVjdG9yfGVufDB8MHwwfHx8MA%3D%3D',
 'Male', 'He/him', 'Los Angeles', 'Dublin', 'Director', 'USC', 'Married',
 'Heterosexual', 'Progressive', 'Catholic', '1984-10-02'),

('request10@example.com', TRUE, NULL,
 'Environmental scientist studying climate change.',
 'Amy', 'Parker',
 'https://randomuser.me/api/portraits/women/45.jpg', 'https://images.unsplash.com/photo-1552799446-159ba9523315?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Y2xpbWF0ZSUyMGNoYW5nZXxlbnwwfDB8MHx8fDA%3D',
 'Female', 'She/her', 'Boston', 'Portland', 'Scientist', 'Harvard', 'Single',
 'Heterosexual', 'Progressive', 'None', '1987-05-14'),

('request11@example.com', TRUE, NULL,
 'Dog trainer and animal lover.',
 'Brian', 'Quinn',
 'https://randomuser.me/api/portraits/men/46.jpg', 'https://plus.unsplash.com/premium_photo-1679520867935-be3c649b2e87?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8ZG9nJTIwdHJhaW5lcnxlbnwwfDB8MHx8fDA%3D',
 'Male', 'He/they', 'Denver', 'Salt Lake City', 'Trainer', 'Colorado State', 'Married',
 'Heterosexual', 'Moderate', 'Christian', '1986-12-25'),

('request12@example.com', TRUE, NULL,
 'Photographer focusing on wildlife and nature.',
 'Clara', 'Reed',
 'https://randomuser.me/api/portraits/women/47.jpg', 'https://plus.unsplash.com/premium_photo-1661962757852-72eb0a9a2a81?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8d2lsZGxpZmV8ZW58MHwwfDB8fHww',
 'Female', 'She/her', 'Portland', 'Vancouver', 'Photographer', 'Oregon State', 'Single',
 'Bisexual', 'Liberal', 'None', '1990-09-18'),

('request13@example.com', TRUE, NULL,
 'Chef specializing in fusion cuisine.',
 'Derek', 'Santos',
 'https://randomuser.me/api/portraits/men/48.jpg', 'https://plus.unsplash.com/premium_photo-1673108852141-e8c3c22a4a22?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8ZnVzaW9uJTIwY3Vpc2luZXxlbnwwfDB8MHx8fDA%3D',
 'Male', 'He/him', 'San Francisco', 'Manila', 'Chef', 'Culinary Institute', 'Single',
 'Heterosexual', 'Progressive', 'Christian', '1988-08-21'),

('request14@example.com', TRUE, NULL,
 'Yoga teacher and mindfulness coach.',
 'Emily', 'Taylor',
 'https://randomuser.me/api/portraits/women/49.jpg', 'https://images.unsplash.com/photo-1524863479829-916d8e77f114?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fHlvZ2F8ZW58MHwwfDB8fHww',
 'Female', 'She/her', 'Austin', 'Toronto', 'Yoga Instructor', 'UT Austin', 'Single',
 'Heterosexual', 'Liberal', 'Buddhist', '1992-03-10'),

('request15@example.com', TRUE, NULL,
 'Software engineer and open-source contributor.',
 'Felix', 'Upton',
 'https://randomuser.me/api/portraits/men/50.jpg', 'https://plus.unsplash.com/premium_photo-1678565879444-f87c8bd9f241?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8c29mdHdhcmV8ZW58MHwwfDB8fHww',
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
    (1, 'Test', 'User', 'Just finished a great hike today! Feeling refreshed and alive.', NULL, NOW() - INTERVAL '5 days'),
    (1, 'Test', 'User', 'Experimenting with some new code ideas. Excited to see where this goes!', NULL, NOW() - INTERVAL '4 days 3 hours'),
    (1, 'Test', 'User', NULL, 'https://images.unsplash.com/photo-1640880793908-b0afa07238f1?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bGVnbyUyMG1hbnxlbnwwfDJ8MHx8fDA%3D', NOW() - INTERVAL '3 days 5 hours'),
    (1, 'Test', 'User', NULL, 'https://images.unsplash.com/photo-1711032265178-3d06d4bfbf18?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8bGVnbyUyMG1hbnxlbnwwfDJ8MHx8fDA%3D', NOW() - INTERVAL '2 days 6 hours'),
    (1, 'Test', 'User', 'Looking forward to the weekend and some quality downtime.', NULL, NOW() - INTERVAL '1 day 4 hours'),

-- Posts for friends of Test User --
-- Alice Smith (id=2) --
    (2, 'Alice', 'Smith', 'Spinning my favorite vinyls all day. Music is the soul’s therapy!', NULL, NOW() - INTERVAL '5 days 2 hours'),
    (2, 'Alice', 'Smith', 'Discovered a rare jazz record this weekend. Pure gold!', NULL, NOW() - INTERVAL '3 days 4 hours'),
    (2, 'Alice', 'Smith', NULL, 'https://images.unsplash.com/photo-1724390265362-c58d0bc7d17a?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fG11c2ljJTIwZmVzdGl2YWx8ZW58MHwyfDB8fHww', NOW() - INTERVAL '1 day 1 hour'),

-- Bob Johnson (id=3) --
    (3, 'Bob', 'Johnson', 'Spent the afternoon planting some new herbs in the garden. Feels great!', NULL, NOW() - INTERVAL '4 days 6 hours'),
    (3, 'Bob', 'Johnson', 'Green thumbs unite! Any tips for keeping basil alive?', NULL, NOW() - INTERVAL '2 days 2 hours'),
    (3, 'Bob', 'Johnson', NULL, 'https://images.unsplash.com/photo-1627989147125-a004d05946d3?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Z2FyZGVuaW5nfGVufDB8MnwwfHx8MA%3D%3D', NOW() - INTERVAL '12 hours'),

-- Cara Lee (id=4) --
    (4, 'Cara', 'Lee', 'Chasing sunsets around the city. Every shot tells a story.', NULL, NOW() - INTERVAL '6 days 5 hours'),
    (4, 'Cara', 'Lee', NULL, 'https://images.unsplash.com/photo-1690514570719-36875c9c3e7f?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fHN0cmVldCUyMGFydHxlbnwwfDJ8MHx8fDA%3D', NOW() - INTERVAL '3 days 3 hours'),
    (4, 'Cara', 'Lee', 'Photography is my way of freezing moments in time.', NULL, NOW() - INTERVAL '1 day 5 hours'),

-- David Chen (id=5) --
    (5, 'David', 'Chen', 'Brainstorming the next big AI project with the team.', NULL, NOW() - INTERVAL '5 days 4 hours'),
    (5, 'David', 'Chen', 'Innovation never sleeps! Excited for what’s next.', NULL, NOW() - INTERVAL '2 days 7 hours'),
    (5, 'David', 'Chen', NULL, 'https://images.unsplash.com/photo-1529353721-ae64f46030b6?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8c3RyZWV0JTIwYXJ0fGVufDB8MnwwfHx8MA%3D%3D', NOW() - INTERVAL '1 day'),

-- Ella Brown (id=6) --
    (6, 'Ella', 'Brown', 'Yoga at sunrise is the best way to start the day.', NULL, NOW() - INTERVAL '4 days 8 hours'),
    (6, 'Ella', 'Brown', 'Guided meditation sessions are helping my students unwind.', NULL, NOW() - INTERVAL '3 days 1 hour'),
    (6, 'Ella', 'Brown', NULL, 'https://images.unsplash.com/photo-1611800065476-b295f882c8ea?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fHlvZ2F8ZW58MHwyfDB8fHww', NOW() - INTERVAL '12 hours'),

-- Frank Davis (id=7) --
    (7, 'Frank', 'Davis', 'Lost in a good book this weekend. Recommendations welcome!', NULL, NOW() - INTERVAL '6 days 2 hours'),
    (7, 'Frank', 'Davis', 'Podcasts keep me company on long walks.', NULL, NOW() - INTERVAL '4 days 3 hours'),
    (7, 'Frank', 'Davis', NULL, 'https://images.unsplash.com/photo-1517596107285-5ce3dd0f61df?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGJvb2t8ZW58MHwyfDB8fHww', NOW() - INTERVAL '1 day 4 hours'),

-- Grace Evans (id=8) --
    (8, 'Grace', 'Evans', 'New blog post live! Exploring sustainable fashion.', NULL, NOW() - INTERVAL '5 days 6 hours'),
    (8, 'Grace', 'Evans', NULL, 'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8ZmFzaGlvbnxlbnwwfDJ8MHx8fDA%3D', NOW() - INTERVAL '3 days 2 hours'),
    (8, 'Grace', 'Evans', 'Style is a way to say who you are without speaking.', NULL, NOW() - INTERVAL '1 day 3 hours'),

-- Henry Foster (id=9) --
    (9, 'Henry', 'Foster', 'Weekend ride through the mountains was epic!', NULL, NOW() - INTERVAL '6 days 7 hours'),
    (9, 'Henry', 'Foster', 'Pushing limits and loving every second.', NULL, NOW() - INTERVAL '3 days 5 hours'),
    (9, 'Henry', 'Foster', NULL, 'https://images.unsplash.com/photo-1679233767426-713ca299cd0a?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fGJpa2luZ3xlbnwwfDJ8MHx8fDA%3D', NOW() - INTERVAL '12 hours'),

-- Isabella Garcia (id=10) --
    (10, 'Isabella', 'Garcia', 'Experimenting with new vegan dessert recipes.', NULL, NOW() - INTERVAL '5 days 1 hour'),
    (10, 'Isabella', 'Garcia', 'Sweet treats don’t have to be unhealthy.', NULL, NOW() - INTERVAL '3 days 6 hours'),
    (10, 'Isabella', 'Garcia', NULL, 'https://plus.unsplash.com/premium_photo-1726797728786-efdc34d29aeb?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dmVnYW4lMjBkZXNzZXJ0fGVufDB8MnwwfHx8MA%3D%3D', NOW() - INTERVAL '1 day 2 hours'),

-- Jack Harris (id=11) --
    (11, 'Jack', 'Harris', 'Drafting ideas for my next novel. Writer’s block? Never heard of it.', NULL, NOW() - INTERVAL '4 days 9 hours'),
    (11, 'Jack', 'Harris', 'Everyday life holds the best stories.', NULL, NOW() - INTERVAL '2 days 4 hours'),

-- Kara Iverson (id=12) --
    (12, 'Kara', 'Iverson', 'Inspiring minds one lesson at a time.', NULL, NOW() - INTERVAL '5 days 3 hours'),
    (12, 'Kara', 'Iverson', 'Education is the key to a brighter future.', NULL, NOW() - INTERVAL '3 days 4 hours'),
    (12, 'Kara', 'Iverson', NULL, 'https://plus.unsplash.com/premium_photo-1723568428336-4b4e21ec91af?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8dGVhY2hpbmd8ZW58MHwyfDB8fHww', NOW() - INTERVAL '1 day 1 hour'),

-- Liam Jackson (id=13) --
    (13, 'Liam', 'Jackson', 'Organizing a beach cleanup this weekend.', NULL, NOW() - INTERVAL '6 days 4 hours'),
    (13, 'Liam', 'Jackson', 'Protecting our planet starts with us.', NULL, NOW() - INTERVAL '3 days 3 hours'),
    (13, 'Liam', 'Jackson', NULL, 'https://images.unsplash.com/photo-1627118976394-990852371725?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8YmVhY2glMjBjbGVhbnVwfGVufDB8MnwwfHx8MA%3D%3D', NOW() - INTERVAL '1 day 2 hours'),

-- Mia Kim (id=14) --
    (14, 'Mia', 'Kim', 'Live streaming tonight! Join me for some fun and games.', NULL, NOW() - INTERVAL '5 days 7 hours'),
    (14, 'Mia', 'Kim', 'Thankful for the amazing community I have.', NULL, NOW() - INTERVAL '3 days 6 hours'),
    (14, 'Mia', 'Kim', NULL, 'https://images.unsplash.com/photo-1622649755106-1f61a6b1b445?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fGdhbWluZ3xlbnwwfDJ8MHx8fDA%3D', NOW() - INTERVAL '1 day 3 hours'),

-- Noah Lopez (id=15) --
    (15, 'Noah', 'Lopez', 'Exploring the urban jungle through my lens.', NULL, NOW() - INTERVAL '6 days 6 hours'),
    (15, 'Noah', 'Lopez', NULL, 'https://plus.unsplash.com/premium_photo-1682124843954-eb395dfa50ea?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dXJiYW4lMjBqdW5nbGV8ZW58MHwyfDB8fHww', NOW() - INTERVAL '3 days 2 hours'),
    (15, 'Noah', 'Lopez', 'Photography is an adventure without limits.', NULL, NOW() - INTERVAL '1 day 4 hours'),

-- Olivia Martinez (id=16) --
    (16, 'Olivia', 'Martinez', 'Writing songs that speak from the heart.', NULL, NOW() - INTERVAL '5 days 5 hours'),
    (16, 'Olivia', 'Martinez', 'Music is my language.', NULL, NOW() - INTERVAL '3 days 7 hours'),
    (16, 'Olivia', 'Martinez', NULL, 'https://images.unsplash.com/photo-1524650359799-842906ca1c06?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8bXVzaWN8ZW58MHwyfDB8fHww', NOW() - INTERVAL '1 day 1 hour'),

-- Peter Nguyen (id=17) --
    (17, 'Peter', 'Nguyen', 'Debugging code and drinking espresso. Perfect combo.', NULL, NOW() - INTERVAL '6 days 3 hours'),
    (17, 'Peter', 'Nguyen', 'Launched a new app feature today!', NULL, NOW() - INTERVAL '4 days 5 hours'),
    (17, 'Peter', 'Nguyen', NULL, 'https://images.unsplash.com/photo-1611691934391-5a8805e0bd1a?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8ZXNwcmVzc298ZW58MHwyfDB8fHww', NOW() - INTERVAL '1 day 2 hours'),

-- Quinn Jefferson (id=18) --
    (18, 'Quinn', 'Jefferson', 'Training for the marathon. Every mile counts!', NULL, NOW() - INTERVAL '5 days 8 hours'),
    (18, 'Quinn', 'Jefferson', 'Fitness is a journey, not a destination.', NULL, NOW() - INTERVAL '3 days 2 hours'),
    (18, 'Quinn', 'Jefferson', NULL, 'https://plus.unsplash.com/premium_photo-1664304823165-888f56fc101b?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8cnVubmluZ3xlbnwwfDJ8MHx8fDA%3D', NOW() - INTERVAL '1 day 3 hours'),

-- Ryan Patel (id=19) --
    (19, 'Ryan', 'Patel', 'Mentoring young entrepreneurs is so rewarding.', NULL, NOW() - INTERVAL '6 days 5 hours'),
    (19, 'Ryan', 'Patel', 'Pitching ideas and learning every day.', NULL, NOW() - INTERVAL '4 days 3 hours'),
    (19, 'Ryan', 'Patel', NULL, 'https://plus.unsplash.com/premium_photo-1665520346947-a07db617d300?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8dGVhY2hpbmd8ZW58MHwyfDB8fHww', NOW() - INTERVAL '1 day 2 hours'),

-- Sophia Quinn (id=20) --
    (20, 'Sophia', 'Quinn', 'Trying out a new vegan recipe today.', NULL, NOW() - INTERVAL '5 days 6 hours'),
    (20, 'Sophia', 'Quinn', 'Food blogging is my passion.', NULL, NOW() - INTERVAL '3 days 5 hours'),
    (20, 'Sophia', 'Quinn', NULL, 'https://plus.unsplash.com/premium_photo-1698867577020-38ae235fd612?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dmVnYW4lMjBmb29kfGVufDB8MnwwfHx8MA%3D%3D', NOW() - INTERVAL '1 day 4 hours'),

-- Tom Henderson (id=21) --
    (21, 'Tom', 'Henderson', 'Performed at an open mic night. Loved every second!', NULL, NOW() - INTERVAL '6 days 1 hour'),
    (21, 'Tom', 'Henderson', 'Laughter is the best medicine.', NULL, NOW() - INTERVAL '4 days 4 hours'),
    (21, 'Tom', 'Henderson', NULL, 'https://images.unsplash.com/photo-1730875647521-81e8bc2fca1c?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8Z2lnfGVufDB8MnwwfHx8MA%3D%3D', NOW() - INTERVAL '1 day 3 hours'),

-- Posts for possible mutuals --
-- Nina Khan (id=22) --
    (22, 'Nina', 'Khan', 'Just booked my next trip to Kyoto! Can’t wait to explore the temples and sushi spots.', NULL, NOW() - INTERVAL '5 days 3 hours'),
    (22, 'Nina', 'Khan', 'Learning Japanese every day. まだまだ勉強が必要ですね!', NULL, NOW() - INTERVAL '3 days 7 hours'),
    (22, 'Nina', 'Khan', NULL, 'https://plus.unsplash.com/premium_photo-1664304460618-e27a37b4f05b?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8YmVhY2glMjBzdW5zZXR8ZW58MHwyfDB8fHww', NOW() - INTERVAL '1 day 5 hours'),

-- Oscar Nguyen (id=23) --
    (23, 'Oscar', 'Nguyen', 'Built a new PC setup over the weekend. Loving the RGB glow!', NULL, NOW() - INTERVAL '6 days 6 hours'),
    (23, 'Oscar', 'Nguyen', 'Streaming some co-op games tonight. Come hang out!', NULL, NOW() - INTERVAL '3 days 4 hours'),
    (23, 'Oscar', 'Nguyen', NULL, 'https://images.unsplash.com/photo-1579493593963-2ca325e3703e?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fHJnYiUyMHBjfGVufDB8MnwwfHx8MA%3D%3D', NOW() - INTERVAL '1 day 3 hours'),

-- Priya Desai (id=24) --
    (24, 'Priya', 'Desai', 'Experimented with a new spicy curry recipe. Friends loved it!', NULL, NOW() - INTERVAL '5 days 2 hours'),
    (24, 'Priya', 'Desai', NULL, 'https://plus.unsplash.com/premium_photo-1726797618903-1bca7ac038ff?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8Y3Vycnl8ZW58MHwyfDB8fHww', NOW() - INTERVAL '3 days 5 hours'),
    (24, 'Priya', 'Desai', 'Nothing beats a homemade meal shared with family.', NULL, NOW() - INTERVAL '1 day 4 hours'),

-- Lucas Morris (id=25) --
    (25, 'Lucas', 'Morris', 'Started planting heirloom tomatoes in the community garden.', NULL, NOW() - INTERVAL '6 days 7 hours'),
    (25, 'Lucas', 'Morris', 'Urban farming is the future. Who’s with me?', NULL, NOW() - INTERVAL '3 days 2 hours'),
    (25, 'Lucas', 'Morris', NULL, 'https://plus.unsplash.com/premium_photo-1723377607590-5aac4e48bb06?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dG9tYXRvZXN8ZW58MHwyfDB8fHww', NOW() - INTERVAL '1 day 1 hour'),

-- Maya Patel (id=26) --
    (26, 'Maya', 'Patel', 'Painting a new mural downtown. Can’t wait to show the final piece!', NULL, NOW() - INTERVAL '5 days 4 hours'),
    (26, 'Maya', 'Patel', 'Creativity flows best with coffee and good music.', NULL, NOW() - INTERVAL '3 days 3 hours'),
    (26, 'Maya', 'Patel', NULL, 'https://images.unsplash.com/photo-1551366895-3532ca1f7ebb?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NHx8bXVyYWx8ZW58MHwyfDB8fHww', NOW() - INTERVAL '1 day 6 hours'),

-- 1 post each for request users --
    (27, 'Quinn', 'Turner', 'Jamming on some new tunes today — feeling inspired! 🎶', NULL, NOW() - INTERVAL '2 days 4 hours'),
    (28, 'Raj', 'Singh', 'Early morning run done — pushing limits every day! 🏃‍♂️', NULL, NOW() - INTERVAL '3 days 2 hours'),
    (29, 'Sara', 'Martinez', 'Working on a new poem inspired by the city lights.', NULL, NOW() - INTERVAL '1 day 6 hours'),
    (30, 'Theo', 'Clark', 'Brainstorming ideas for my next eco-startup. Sustainability first!', NULL, NOW() - INTERVAL '4 days 3 hours'),
    (31, 'Vera', 'Kim', 'Experimenting with digital and traditional paints — love the blend.', NULL, NOW() - INTERVAL '2 days 5 hours'),
    (32, 'Wendy', 'Lopez', 'Just posted my latest travel blog — adventures await! ✈️', NULL, NOW() - INTERVAL '1 day 7 hours'),
    (33, 'Xander', 'Morris', 'Sketching new comic characters — superheroes in the making!', NULL, NOW() - INTERVAL '3 days 4 hours'),
    (34, 'Yara', 'Nguyen', 'Perfected a new latte art design today — coffee bliss.', NULL, NOW() - INTERVAL '2 days 3 hours'),
    (35, 'Zach', 'Daniels', 'Wrapping up edits on my latest short film — storytelling at its best.', NULL, NOW() - INTERVAL '5 days 6 hours'),
    (36, 'Amy', 'Parker', 'Collecting data on climate patterns — science in action.', NULL, NOW() - INTERVAL '3 days 5 hours'),
    (37, 'Brian', 'Quinn', 'Training a new rescue pup — progress is amazing!', NULL, NOW() - INTERVAL '4 days 2 hours'),
    (38, 'Clara', 'Reed', 'Captured some stunning shots of the forest wildlife today.', NULL, NOW() - INTERVAL '1 day 8 hours'),
    (39, 'Derek', 'Santos', 'Cooked up a fusion feast last night — flavors exploded!', NULL, NOW() - INTERVAL '2 days 6 hours'),
    (40, 'Emily', 'Taylor', 'Leading a mindfulness session — peace and calm everywhere.', NULL, NOW() - INTERVAL '1 day 4 hours'),
    (41, 'Felix', 'Upton', 'Pushed a new update to my open-source project. Code is life.', NULL, NOW() - INTERVAL '3 days 7 hours');

-- 🔴 SEEDING COMMENTS TABLE 🔴 --
INSERT INTO comments (postid, username, comment, time_stamp) VALUES
-- Post 1 comments
(1, 'friend1@example.com', 'Sounds amazing, hiking always resets my mind! Which trail did you hit?', NOW() - INTERVAL '4 days 20 hours'),
(1, 'friend2@example.com', 'Nothing beats fresh mountain air. Glad you had a great time!', NOW() - INTERVAL '4 days 18 hours'),
(1, 'friend3@example.com', 'Beautiful! Hope you snapped some photos to share.', NOW() - INTERVAL '4 days 15 hours'),

-- Post 2 comments
(2, 'friend4@example.com', 'Love the energy! Can’t wait to hear what you build next.', NOW() - INTERVAL '3 days 20 hours'),

-- Post 3 comments
(3, 'friend5@example.com', 'Always! My morning ritual is incomplete without coffee.', NOW() - INTERVAL '2 days 22 hours'),
(3, 'friend6@example.com', 'Coffee is the secret ingredient to my creativity.', NOW() - INTERVAL '2 days 20 hours'),
(3, 'friend7@example.com', 'You’re speaking my language! What’s your favorite brew?', NOW() - INTERVAL '2 days 18 hours'),
(3, 'friend8@example.com', 'I’m more of a chai person, but coffee is a close second!', NOW() - INTERVAL '2 days 17 hours'),
(3, 'friend9@example.com', 'Big yes! Currently debugging with a latte on my desk.', NOW() - INTERVAL '2 days 16 hours'),

-- Post 5 comments
(5, 'friend10@example.com', 'You deserve it! Hope you get some great rest.', NOW() - INTERVAL '1 day 20 hours'),
(5, 'friend11@example.com', 'Weekend plans sound good — any outdoor adventures?', NOW() - INTERVAL '1 day 18 hours'),

-- Comments for test user's friend's posts
-- Comments on Alice Smith's posts (user id 2)
(2, 'request2@example.com', 'Vinyls are timeless. What’s spinning today?', NOW() - INTERVAL '4 days 22 hours'),
(2, 'mutual5@example.com', 'Jazz is life! Got any recommendations?', NOW() - INTERVAL '3 days 2 hours'),
(2, 'mutual4@example.com', 'Music festivals always bring the best vibes!', NOW() - INTERVAL '23 hours'),

-- Comments on Bob Johnson's posts (user id 3)
(3, 'mutual3@example.com', 'Basil can be tricky, but keep it sunny and watered.', NOW() - INTERVAL '2 days'),
(3, 'mutual1@example.com', 'Herb gardens are the best! Fresh pesto is the reward.', NOW() - INTERVAL '10 hours'),

-- Comments on Cara Lee's posts (user id 4)
(4, 'friend6@example.com', 'Sunsets make everything magical.', NOW() - INTERVAL '6 days'),
(4, 'request12@example.com', 'Street art colors always inspire me!', NOW() - INTERVAL '3 days 1 hour'),

-- Comments on David Chen's posts (user id 5)
(5, 'friend16@example.com', 'AI projects sound exciting! Can’t wait to hear about it.', NOW() - INTERVAL '5 days'),
(5, 'friend18@example.com', 'Tech conferences are where the magic happens.', NOW() - INTERVAL '1 day 20 hours'),

-- Comments on Ella Brown's posts (user id 6)
(6, 'request14@example.com', 'Yoga at sunrise is truly refreshing!', NOW() - INTERVAL '4 days 6 hours'),
(6, 'friend13@example.com', 'Meditation really helps me stay focused.', NOW() - INTERVAL '2 days 22 hours'),

-- Comments on Frank Davis's posts (user id 7)
(7, 'request3@example.com', 'Books and podcasts — perfect combo for a lazy weekend.', NOW() - INTERVAL '5 days 20 hours'),

-- Comments on Grace Evans's posts (user id 8)
(8, 'request5@example.com', 'Sustainable fashion is the future!', NOW() - INTERVAL '5 days'),
(8, 'request6@example.com', 'Fashion week vibes are so inspiring.', NOW() - INTERVAL '2 days 21 hours'),

-- Comments on Henry Foster's posts (user id 9)
(9, 'request2@example.com', 'Epic rides are the best way to recharge.', NOW() - INTERVAL '5 days 22 hours'),

-- Comments on Isabella Garcia's posts (user id 10)
(10, 'friend19@example.com', 'Raw chocolate tart? Yum, sounds delicious!', NOW() - INTERVAL '1 day'),

-- Comments on Jack Harris's posts (user id 11)
(11, 'request3@example.com', 'Writer’s block is real, but you’re smashing it!', NOW() - INTERVAL '3 days 10 hours'),

-- Comments on Kara Iverson's posts (user id 12)
(12, 'request4@example.com', 'Creative curriculums shape the future.', NOW() - INTERVAL '3 days'),

-- Comments on Liam Jackson's posts (user id 13)
(13, 'request10@example.com', 'Beach cleanups are so important for the environment.', NOW() - INTERVAL '5 days'),

-- Comments on Mia Kim's posts (user id 14)
(14, 'request6@example.com', 'Congrats on the milestone! Keep streaming.', NOW() - INTERVAL '2 days'),

-- Comments on Noah Lopez's posts (user id 15)
(15, 'request12@example.com', 'Cityscapes always tell a unique story.', NOW() - INTERVAL '3 days'),

-- Comments on Olivia Martinez's posts (user id 16)
(16, 'request1@example.com', 'Local gigs have the best vibes. Keep it up!', NOW() - INTERVAL '1 day 12 hours'),

-- Comments on Peter Nguyen's posts (user id 17)
(17, 'request15@example.com', 'Coffee and code — can’t live without them.', NOW() - INTERVAL '1 day 4 hours'),

-- Comments on Quinn Jefferson's posts (user id 18)
(18, 'request2@example.com', 'Every mile counts. Keep pushing!', NOW() - INTERVAL '2 days'),

-- Comments on Ryan Patel's posts (user id 19)
(19, 'request4@example.com', 'Startup life is wild but so rewarding.', NOW() - INTERVAL '3 days'),

-- Comments on Sophia Quinn's posts (user id 20)
(20, 'request5@example.com', 'Keep on keeping on. Strength and love.', NOW() - INTERVAL '2 days'),

-- Comments on Tom Henderson's posts (user id 21)
(21, 'friend1@example.com', 'Open mic nights are such a great way to connect.', NOW() - INTERVAL '5 days'),

-- Comments on mutual friends' posts
-- Nina Khan's posts (user id 22)
(22, 'friend12@example.com', 'Kyoto is amazing! Don’t miss the bamboo forest.', NOW() - INTERVAL '4 days 20 hours'),
(22, 'friend19@example.com', 'Learning Japanese is so rewarding, 頑張って!', NOW() - INTERVAL '3 days 4 hours'),
(22, 'friend13@example.com', 'That sunset looks stunning! Perfect travel vibes.', NOW() - INTERVAL '23 hours'),

-- Oscar Nguyen's posts (user id 23)
(23, 'friend10@example.com', 'RGB lighting really sets the mood, nice setup!', NOW() - INTERVAL '6 days 2 hours'),
(23, 'friend3@example.com', 'Co-op gaming sounds fun. Count me in!', NOW() - INTERVAL '2 days 22 hours'),

-- Priya Desai's posts (user id 24)
(24, 'friend5@example.com', 'Spicy curry sounds delicious. Recipe, please?', NOW() - INTERVAL '5 days'),
(24, 'friend1@example.com', 'Homemade meals are the best kind of love.', NOW() - INTERVAL '1 day 3 hours 52 minutes'),

-- Lucas Morris's posts (user id 25)
(25, 'friend12@example.com', 'Heirloom tomatoes are the tastiest!', NOW() - INTERVAL '5 days 22 hours'),
(25, 'request2@example.com', 'Urban farming is definitely the future.', NOW() - INTERVAL '2 days 23 hours'),

-- Maya Patel's posts (user id 26)
(26, 'friend15@example.com', 'Can’t wait to see your mural!', NOW() - INTERVAL '4 days 23 hours 11 minutes'),
(26, 'friend18@example.com', 'Coffee and creativity are a perfect combo.', NOW() - INTERVAL '3 days 1 hour 47 minutes');

-- 🔴 SEEDING LIKES TABLE 🔴 --

-- Likes seed data with 0-5 likes per post/comment

INSERT INTO likes (user_id, liked_type, liked_id) VALUES
-- Post likes
(7, 'post', 1),
(24, 'post', 1),
(15, 'post', 2),
(41, 'post', 2),
(5, 'post', 3),
(16, 'post', 4),
(29, 'post', 5),
(1, 'post', 6),
(10, 'post', 7),
(22, 'post', 8),
(8, 'post', 9),
(30, 'post', 10),
(33, 'post', 11),
(14, 'post', 12),
(6, 'post', 13),
(4, 'post', 14),
(25, 'post', 15),
(39, 'post', 16),
(21, 'post', 17),
(19, 'post', 18),
(12, 'post', 19),
(38, 'post', 20),
(2, 'post', 21),
(31, 'post', 22),
(40, 'post', 23),
(3, 'post', 24),
(17, 'post', 25),
(11, 'post', 26),
(27, 'post', 27),
(35, 'post', 28),
(23, 'post', 29),
(7, 'post', 30),
(1, 'post', 31),
(9, 'post', 32),
(14, 'post', 33),
(13, 'post', 34),
(20, 'post', 35),
(36, 'post', 36),
(5, 'post', 37),
(4, 'post', 38),
(18, 'post', 39),
(22, 'post', 40),
(28, 'post', 41),
(26, 'post', 42),
(37, 'post', 43),
(10, 'post', 44),
(15, 'post', 45),
(24, 'post', 46),
(19, 'post', 47),
(8, 'post', 48),
(3, 'post', 49),
(34, 'post', 50),
(30, 'post', 51),
(16, 'post', 52),
(1, 'post', 53),
(23, 'post', 54),
(27, 'post', 55),
(12, 'post', 56),
(40, 'post', 57),
(21, 'post', 58),
(33, 'post', 59),
(38, 'post', 60),
(5, 'post', 61),
(7, 'post', 62),
(9, 'post', 63),
(15, 'post', 64),
(26, 'post', 65),
(31, 'post', 66),
(18, 'post', 67),
(4, 'post', 68),
(11, 'post', 69),
(22, 'post', 70),
(29, 'post', 71),
(14, 'post', 72),
(35, 'post', 73),
(13, 'post', 74),
(24, 'post', 75),
(8, 'post', 76),
(20, 'post', 77),
(30, 'post', 78),
(3, 'post', 79),
(37, 'post', 80),
(10, 'post', 81),
(1, 'post', 82),
(16, 'post', 83),
(25, 'post', 84),
(19, 'post', 85),
(39, 'post', 86),
(21, 'post', 87),
(6, 'post', 88),
(14, 'post', 89),
(32, 'post', 90),
(7, 'post', 91),
(5, 'post', 92),
(11, 'post', 93),
(24, 'post', 94),
(15, 'post', 95),

-- Comment likes
(10, 'comment', 1),
(7, 'comment', 1),
(19, 'comment', 1),
(33, 'comment', 2),
(22, 'comment', 3),
(9, 'comment', 4),
(14, 'comment', 5),
(1, 'comment', 6),
(27, 'comment', 6),
(4, 'comment', 7),
(20, 'comment', 8),
(15, 'comment', 9),
(30, 'comment', 10),
(21, 'comment', 11),
(5, 'comment', 12),
(31, 'comment', 13),
(11, 'comment', 14),
(3, 'comment', 15),
(26, 'comment', 16),
(38, 'comment', 17),
(2, 'comment', 18),
(29, 'comment', 19),
(13, 'comment', 20),
(17, 'comment', 21),
(6, 'comment', 22),
(23, 'comment', 23),
(8, 'comment', 24),
(25, 'comment', 25),
(7, 'comment', 26),
(12, 'comment', 27),
(34, 'comment', 28),
(9, 'comment', 29),
(16, 'comment', 30),
(18, 'comment', 31),
(20, 'comment', 32),
(1, 'comment', 33),
(27, 'comment', 34),
(4, 'comment', 35),
(22, 'comment', 36),
(30, 'comment', 37),
(14, 'comment', 38),
(35, 'comment', 39),
(8, 'comment', 40),
(24, 'comment', 41),
(11, 'comment', 42),
(31, 'comment', 43),
(5, 'comment', 44),
(7, 'comment', 45),
(13, 'comment', 46),
(9, 'comment', 47),
(19, 'comment', 48);