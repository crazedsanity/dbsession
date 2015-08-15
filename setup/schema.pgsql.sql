
--
-- The user status table is a list of statuses indicating what state a user's
--	account is in.
-- THESE VALUES MUST MATCH THE CODE.
--
CREATE TABLE cs_user_status_table (
    user_status_id integer NOT NULL PRIMARY KEY,
    description text NOT NULL,
    is_active boolean DEFAULT true NOT NULL
);
INSERT INTO cs_user_status_table (user_status_id, description, is_active)
	VALUES 
		(0, 'Disabled User', false),
		(1, 'Active User', true),
		(2, 'Registration Pending', false);


--
-- The authentication table is where usernames & passwords are stored.
-- The "passwd" column is created like this (on a Linux system): 
--		echo "administrator-changeMe" | sha1sum
-- 
CREATE TABLE cs_authentication_table (
    uid serial NOT NULL PRIMARY KEY,
    username text NOT NULL UNIQUE,
    passwd text,
    date_created date DEFAULT now() NOT NULL,
    last_login timestamp with time zone,
    email text,
    user_status_id integer NOT NULL DEFAULT 0 
		REFERENCES cs_user_status_table(user_status_id)
);
INSERT INTO cs_authentication_table (uid,username, user_status_id) 
	VALUES (0, 'anonymous', 0);
INSERT INTO cs_authentication_table (username, passwd, user_status_id)
	VALUES	('test', '75eba0f69d185ef816d0cee43ad44d4b2240de02', 1),			-- "letMeIn"
			('administrator', 'c2fc1fdc72ef8b92cf3d98bd1a60725cafdebdaa', 1);	-- "changeMe"





--
-- Store session data in here.
-- Idea originally from: http://www.developertutorials.com/tutorials/php/saving-php-session-data-database-050711
--

CREATE TABLE cswal_session_table (
	session_id varchar(40) NOT NULL UNIQUE PRIMARY KEY,
	uid integer REFERENCES cs_authentication_table(uid),
	date_created timestamp NOT NULL DEFAULT NOW(),
	last_updated timestamp NOT NULL DEFAULT NOW(),
	num_checkins integer NOT NULL DEFAULT 0,
	session_data text
);
