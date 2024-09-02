SELECT 
    i.match_id,
    i.innings_no,
    t.team_name AS bowling_team_name,
    p.player_name AS bowler_name,
    CASE WHEN MOD ((COUNT(*) - COUNT(wides) - COUNT(noballs)), 6) = 0 
            THEN (COUNT(*) - COUNT(wides) - COUNT(noballs)) / 6 
            ELSE  CAST(((COUNT(*) - COUNT(wides) - COUNT(noballs)) / 6) AS INTEGER)  
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
FROM 
    innings i JOIN team t ON (i.bowling_team_id = t.team_id)
            JOIN score_by_ball s ON (i.match_id = s.match_id AND i.innings_no = s.innings_no)
            JOIN player p ON (s.bowler_id = p.player_id)
GROUP BY 
        i.match_id,
        i.innings_no,
        t.team_name,
        p.player_name
ORDER BY  
        i.match_id,
        i.innings_no,
        MIN(s.ball_no);

