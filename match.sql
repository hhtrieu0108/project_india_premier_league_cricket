CREATE TABLE match
(    
    match_id    INTEGER NOT NULL PRIMARY KEY,
    match_date    VARCHR(10)  NOT NULL ,
    venue_id      INTEGER NOT NULL ,
    FOREIGN KEY (venue_id) REFERENCES venue(venue_id)
);

INSERT INTO "match" (match_id, match_date, venue_id)
VALUES  (1,'2024-03-22',1);

SELECT * FROM "match";