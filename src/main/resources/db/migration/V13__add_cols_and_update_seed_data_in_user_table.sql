ALTER TABLE users
ADD COLUMN gender VARCHAR(50),
ADD COLUMN pronouns VARCHAR(50),
ADD COLUMN current_city VARCHAR(100),
ADD COLUMN hometown VARCHAR(100),
ADD COLUMN job VARCHAR(100),
ADD COLUMN school VARCHAR(100),
ADD COLUMN relationship_status VARCHAR(50),
ADD COLUMN sexual_orientation VARCHAR(50),
ADD COLUMN political_views VARCHAR(100),
ADD COLUMN religion VARCHAR(100);

UPDATE users SET
    gender = 'Male',
    pronouns = 'he/him',
    current_city = 'Los Angeles',
    hometown = 'Philadelphia',
    job = 'Software Tester',
    school = 'MIT',
    relationship_status = 'Married',
    sexual_orientation = 'Heterosexual',
    political_views = 'Independent',
    religion = 'Agnostic'
WHERE username = 'test@test.com';

UPDATE users SET
    gender = 'Female',
    pronouns = 'she/her',
    current_city = 'Nashville',
    hometown = 'Reading',
    job = 'Singer-Songwriter',
    school = 'Hendersonville High School',
    relationship_status = 'Single',
    sexual_orientation = 'Heterosexual',
    political_views = 'Centrist',
    religion = 'Christian'
WHERE username = 't.swiftie89@popvibes.com';

UPDATE users SET
    gender = 'Male',
    pronouns = 'he/him',
    current_city = 'Malibu',
    hometown = 'New York City',
    job = 'Actor',
    school = 'Santa Monica High School',
    relationship_status = 'Married',
    sexual_orientation = 'Heterosexual',
    political_views = 'Liberal',
    religion = 'Jewish'
WHERE username = 'robert.downey@starkmail.com';

UPDATE users SET
    gender = 'Female',
    pronouns = 'she/her',
    current_city = 'Houston',
    hometown = 'Houston',
    job = 'Entrepreneur / Artist',
    school = 'High School for the Performing and Visual Arts',
    relationship_status = 'Married',
    sexual_orientation = 'Heterosexual',
    political_views = 'Progressive',
    religion = 'Christian'
WHERE username = 'bey.queenb@lemonadehub.net';

UPDATE users SET
    gender = 'Male',
    pronouns = 'he/him',
    current_city = 'Los Angeles',
    hometown = 'Hayward',
    job = 'Actor / Producer',
    school = 'University of Miami',
    relationship_status = 'Married',
    sexual_orientation = 'Heterosexual',
    political_views = 'Moderate',
    religion = 'Christian'
WHERE username = 'the.rock@smashmail.org';

UPDATE users SET
    gender = 'Female',
    pronouns = 'she/her',
    current_city = 'London',
    hometown = 'Paris',
    job = 'Actress / Activist',
    school = 'Brown University',
    relationship_status = 'Single',
    sexual_orientation = 'Heterosexual',
    political_views = 'Progressive',
    religion = 'Spiritual'
WHERE username = 'emma.watson.books@hermione.io';

UPDATE users SET
    gender = 'Male',
    pronouns = 'he/him',
    current_city = 'Toronto',
    hometown = 'Toronto',
    job = 'Musician / Entrepreneur',
    school = 'Forest Hill Collegiate Institute',
    relationship_status = 'Single',
    sexual_orientation = 'Heterosexual',
    political_views = 'Liberal',
    religion = 'Christian'
WHERE username = 'drake@octobersveryown.ca';

UPDATE users SET
    gender = 'Female',
    pronouns = 'she/her',
    current_city = 'Bridgetown',
    hometown = 'Bridgetown',
    job = 'Singer / CEO',
    school = 'Combermere School',
    relationship_status = 'In a relationship',
    sexual_orientation = 'Bisexual',
    political_views = 'Liberal',
    religion = 'Christian'
WHERE username = 'rih.navy@fentyhq.co';

UPDATE users SET
    gender = 'Female',
    pronouns = 'she/her',
    current_city = 'Los Angeles',
    hometown = 'Oakland',
    job = 'Actress / Model',
    school = 'Oakland School for the Arts',
    relationship_status = 'In a relationship',
    sexual_orientation = 'Queer',
    political_views = 'Progressive',
    religion = 'Non-religious'
WHERE username = 'zendaya.now@webslings.tv';

