CREATE TABLE venue
(
    venue_id         INTEGER NOT NULL PRIMARY KEY , 
    venue_name    VARCHAR(200) NOT NULL UNIQUE
);

INSERT INTO venue (vanue_id, venue_name)
VALUES(1,'MA Chidambaram Stadium, Chepauk, Chennai');

SELECT * FROM venue;