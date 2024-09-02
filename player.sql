-- Create the player table
CREATE TABLE player
(
    player_id INTEGER NOT NULL PRIMARY KEY ,
    player_name VARCHAR(100) NOT NULL,
    team_id INTEGER NOT NULL,
    FOREIGN KEY (team_id) REFERENCES team(team_id)
);
INSERT INTO player (player_id, player_name, team_id)
VALUES  (1,'V Kohli',1),
        (2,'F du Plessis',1),
        (3,'RM Patidar',1),
        (4,'GJ Maxwell',1),
        (5,'C Green',1),
        (6,'Anuj Rawat',1),
        (7,'KD Karthik',1),
        (8,'KV Sharma',1),
        (9,'AS Joseph',1),
        (10,'Mayank Dagar',1),
        (11,'Mohammed Siraj',1),
        (12,'Yash Dayal',1),
        (13,'RD Gaikwad',2),
        (14,'R Ravindra',2),
        (15,'AM Rahane',2),
        (16,'DJ Mitchell',2),
        (17,'S Dube',2),
        (18,'RA Jadeja',2),
        (19,'Sameer Rizvi',2),
        (20,'MS Dhoni',2),
        (21,'DL Chahar',2),
        (22,'M Theekshana',2),
        (23,'TU Deshpande',2),
        (24,'Mustafizur Rahman',2);

SELECT * FROM player;