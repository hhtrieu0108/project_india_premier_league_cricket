CREATE TABLE team
(
    team_id INTEGER NOT NULL PRIMARY KEY ,
    team_name VARCHAR(100) NOT NULL UNIQUE
);

INSERT INTO team (team_id, team_name)
VALUES  (1,'Royal Challengers Bengaluru'),
        (2,'Chennai Super Kings');

SELECT * FROM team;