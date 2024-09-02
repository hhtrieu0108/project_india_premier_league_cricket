/*
This script contains all the SQL statements required to populate the 
scorecard for the iplt20.com website
*/


/* 
Get all the information required by the web team to build the match summary
*/

/*
Match level information Required
-------------------------------------
1. Match Number
2. Venue
3. Match Date
4. Winning Team Name
*/
SELECT 
        m.match_id,
        m.match_date,
        v.venue_name,
        t.team_name AS winning_team_name
FROM 
        match m JOIN venue v ON (m.venue_id = v.venue_id)
                JOIN result r ON (m.match_id = r.match_id)
                JOIN team t ON (r.winning_team_id = t.team_id);


/*
Innings level information Required
-------------------------------------
1. Name of the teams played
2. Total runs scored
3. Total wickets lost
4. Total overs played
*/

SELECT  i.match_id,
        i.innings_no,
        t.team_name,
        SUM(s.runs_off_bat +  s.extras) AS total_runs,
        COUNT(wicket_type) AS total_wickets,
        CASE WHEN MOD ((COUNT(*) - COUNT(wides) - COUNT(noballs)), 6) = 0 -- Check to see if there are any remaining balls
                THEN (COUNT(*) - COUNT(wides) - COUNT(noballs)) / 6 -- Just output the overs as there are no remaining balls
                ELSE  CAST(((COUNT(*) - COUNT(wides) - COUNT(noballs)) / 6) AS INTEGER)   -- Concatenate overs with remaining balls
                        || '.' 
                        ||  CAST((MOD ((COUNT(*) - COUNT(wides) - COUNT(noballs)), 6)) AS INTEGER) 
        END AS total_overs
FROM innings i JOIN team t ON (i.batting_team_id = t.team_id)
                JOIN score_by_ball s ON (i.match_id = s.match_id AND i.innings_no = s.innings_no)
GROUP BY i.match_id,
        i.innings_no,
        t.team_name;


-- Batting Summary (Batsman Level)
/*
Information Required
-----------------------
1. Team Name
2. Batsman Name
3. Runs
4. Balls
5. 4s
6. 6s
7. Strike Rate
*/

SELECT  i.match_id,
        i.innings_no,
        t.team_name AS batting_team_name,
        p.player_name AS batsman_name,
        sum(runs_off_bat) AS total_runs,
        COUNT(*) AS total_balls,
        SUM(IIF(s.runs_off_bat = 4, 1, 0)) AS no_of_fours,
        SUM(IIF(s.runs_off_bat = 6, 1, 0)) AS no_of_sixes,
        FORMAT("%.2f", (CAST(sum(runs_off_bat) AS REAL) / CAST(COUNT(*) AS REAL)) * 100) AS strike_rate
FROM innings i JOIN team t ON (i.batting_team_id = t.team_id)
                JOIN score_by_ball s ON (i.match_id = s.match_id AND i.innings_no = s.innings_no)
                JOIN player p ON (s.striker_id = p.player_id)
WHERE s.wides IS NULL AND s.noballs IS NULL
GROUP BY i.match_id,
                i.innings_no,
                t.team_name,
                p.player_name 
ORDER BY  i.match_id,
                i.innings_no,
                MIN(s.ball_no)  ;

-- Batting Summary (Extras)
/*
Information Required
-----------------------
1. Team Name
2. extras
3. noballs
4. wides
5. byes
6. legbyes
7. penalities
*/

SELECT  i.match_id,
        i.innings_no,
        t.team_name AS batting_team_name,
        SUM(s.extras) AS total_extras,
        SUM(IFNULL(s.noballs, 0)) AS total_noballs,
        SUM(IFNULL(s.wides, 0)) AS total_wides,
        SUM(IFNULL(s.byes, 0)) AS total_byes,
        SUM(IFNULL(s.legbyes, 0)) AS total_legbyes,
        SUM(IFNULL(s.penalty, 0)) AS total_penalty
FROM innings i JOIN team t ON (i.batting_team_id = t.team_id)
                JOIN score_by_ball s ON (i.match_id = s.match_id AND i.innings_no = s.innings_no)
GROUP BY  i.match_id,
        i.innings_no,
        t.team_name  ;

SELECT * FROM score_by_ball;

-- Bowling Summary (Bowler Level)
/*
Information Required
-----------------------
1. Batting Team Name
2. Bowler Name
3. Overs
4. Runs
5. Wickets
6. Economy
7. Dots
*/

SELECT  i.match_id,
        i.innings_no,
        t.team_name,
        p.player_name AS bowler_name,
        CASE WHEN MOD ((COUNT(*) - COUNT(wides) - COUNT(noballs)), 6) = 0 -- Check to see if there are any remaining balls
                THEN (COUNT(*) - COUNT(wides) - COUNT(noballs)) / 6 -- Just output the overs as there are no remaining balls
                ELSE  CAST(((COUNT(*) - COUNT(wides) - COUNT(noballs)) / 6) AS INTEGER)   -- Concatenate overs with remaining balls
                        || '.' 
                        ||  CAST((MOD ((COUNT(*) - COUNT(wides) - COUNT(noballs)), 6)) AS INTEGER) 
        END AS total_overs,
        SUM(s.runs_off_bat +  IFNULL(s.wides, 0) + IFNULL(s.noballs, 0)) AS total_runs,
        COUNT(wicket_type) AS total_wickets       ,
        ROUND(
                SUM(s.runs_off_bat +  IFNULL(s.wides, 0) + IFNULL(s.noballs, 0)) 
                        /   (CAST((COUNT(*) - COUNT(wides) - COUNT(noballs)) AS REAL) / 6) 
                , 2)  AS economy,
        SUM(IIF(s.runs_off_bat = 0 AND s.wides IS NULL AND s.noballs IS NULL, 1, 0)) AS dots
FROM innings i JOIN team t ON (i.batting_team_id = t.team_id)
                JOIN score_by_ball s ON (i.match_id = s.match_id AND i.innings_no = s.innings_no)
                JOIN player p ON (s.bowler_id = p.player_id)
GROUP BY i.match_id,
        i.innings_no,
        t.team_name,
        p.player_name
ORDER BY  i.match_id,
        i.innings_no,
        MIN(s.ball_no);