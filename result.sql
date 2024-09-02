CREATE TABLE result
(    
    match_id    INTEGER NOT NULL PRIMARY KEY,
    winning_team_id INTEGER NOT NULL,         
    player_of_the_match_id   INTEGER NOT NULL ,
    FOREIGN KEY (match_id) REFERENCES match(match_id),
    FOREIGN KEY (winning_team_id) REFERENCES team(team_id)
    FOREIGN KEY (player_of_the_match_id) REFERENCES player(player_id)
);

INSERT INTO result (match_id, winning_team_id, player_of_the_match_id)
VALUES  (1,2,24);

SELECT * FROM result;