-------------------------------------------------------------------------------------------------------------------------------------
-- Title: We'll take the CASE
-------------------------------------------------------------------------------------------------------------------------------------
-- We'll take the CASE:
-------------------------------------------------------------------------------------------------------------------------------------
CASE WHEN x = 1 THEN 'a'
     WHEN x = 2 THEN 'b'
     ELSE 'c' END AS new_column;
-------------------------------------------------------------------------------------------------------------------------------------
-- Basic CASE statements:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
	-- Select the team long name and team API id
	team_long_name,
	team_api_id
FROM teams_germany
-- Only include FC Schalke 04 and FC Bayern Munich
WHERE team_long_name IN ('FC Schalke 04', 'FC Bayern Munich');
-------------------------------------------------------------------------------------------------------------------------------------
-- Identify the home team as Bayern Munich, Schalke 04, or neither
SELECT 
	CASE WHEN hometeam_id = 10189 THEN 'FC Schalke 04'
        WHEN hometeam_id = 9823 THEN 'FC Bayern Munich'
         ELSE 'Other' END AS home_team,
	COUNT(id) AS total_matches
FROM matches_germany
-- Group by the CASE statement alias
GROUP BY home_team;
-------------------------------------------------------------------------------------------------------------------------------------
-- CASE statements comparing column values:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	-- Select the date of the match
	date,
	-- Identify home wins, losses, or ties
	CASE WHEN home_goal > away_goal THEN 'Home win!'
        WHEN home_goal < away_goal THEN 'Home loss :(' 
        ELSE 'Tie' END AS outcome
FROM matches_spain;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	m.date,
	--Select the team long name column and call it 'opponent'
	t.team_long_name AS opponent, 
	-- Complete the CASE statement with an alias
	CASE WHEN m.home_goal > away_goal THEN 'Home win!'
        WHEN m.home_goal < away_goal THEN 'Home loss :('
        ELSE 'Tie' END AS outcome
FROM matches_spain AS m
-- Left join teams_spain onto matches_spain
LEFT JOIN teams_spain AS t
ON m.awayteam_id = t.team_api_id;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	m.date,
	t.team_long_name AS opponent,
    -- Complete the CASE statement with an alias
	CASE WHEN m.home_goal > away_goal THEN 'Barcelona win!'
        WHEN m.home_goal < away_goal THEN 'Barcelona loss :(' 
        ELSE 'Tie' END AS outcome 
FROM matches_spain AS m
LEFT JOIN teams_spain AS t 
ON m.awayteam_id = t.team_api_id
-- Filter for Barcelona as the home team
WHERE m.hometeam_id = 8634; 
-------------------------------------------------------------------------------------------------------------------------------------
-- CASE statements comparing two column values part 2:
-------------------------------------------------------------------------------------------------------------------------------------
-- Select matches where Barcelona was the away team
SELECT  
	m.date,
	t.team_long_name AS opponent,
	CASE WHEN m.home_goal < m.away_goal THEN 'Barcelona win!'
        WHEN m.home_goal > m.away_goal THEN 'Barcelona loss :(' 
        ELSE 'Tie' END AS outcome
FROM matches_spain AS m
-- Join teams_spain to matches_spain
LEFT JOIN teams_spain AS t 
ON m.hometeam_id = t.team_api_id
WHERE m.awayteam_id = 8634;
-------------------------------------------------------------------------------------------------------------------------------------
-- In CASE things get more complex:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
    data,
    season
    CASE WHEN home_goal > away_goal THEN 'Home team win!'
         WHEN home_goal < away_goal THEN 'Away team win!'
         ELSE 'Tie' END AS outcome
FROM match;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT data, hometeam_id, awayteam_id
    CASE WHEN hometeam_id = 8455 AND home_goal > away_goal
            THEN 'Chelsea home win!'
         WHEN awayteam_id = 8455 AND home_goal < away_goal
            THEN 'Chelsea away win!'
         ELSE 'Loss or tie :(' END AS outcome
FROM match 
    WHERE hometeam_id = 8455 OR awayteam_id =8455;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT data, hometeam_id, awayteam_id
    CASE WHEN hometeam_id = 8455 AND home_goal > away_goal
            THEN 'Chelsea home win!'
         WHEN awayteam_id = 8455 AND home_goal < away_goal
            THEN 'Chelsea away win!'
         ELSE 'Loss or tie :(' END AS outcome
FROM match;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT data, hometeam_id, awayteam_id
    CASE WHEN hometeam_id = 8455 AND home_goal > away_goal
            THEN 'Chelsea home win!'
         WHEN awayteam_id = 8455 AND home_goal < away_goal
            THEN 'Chelsea away win!'
         ELSE 'Loss or tie :(' END AS outcome
FROM match
WHERE hometeam_id = 8455 OR awayteam_id = 8455;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT date,
CASE WHEN date > '2015-01-01' THEN 'More Recently'
     WHEN data < '2012-01-01' THEN 'Older'
     END AS date_category
FROM match;

SELECT date,
CASE WHEN date > '2015-01-01' THEN 'More Recently'
     WHEN data < '2012-01-01' THEN 'Older'
     ELSE NULL END AS date_category
FROM match;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT data, season,
    CASE WHEN hometeam_id =8455 AND home_goal > away_goal
            THEN 'Chelsea home win!'
         WHEN awayteam_id = 8455 AND home_goal < away_goal
            THEN 'Chelsea away win!' END AS outcome
FROM match
WHERE CASE WHEN hometeam_id = 8455 AND home_goal > away_goal
                THEN 'Chelsea home win!'
           WHEN awayteam_id = 8455 AND home_goal < away_goal
                THEN 'Chelsea away win' END IS NOT NULL;
