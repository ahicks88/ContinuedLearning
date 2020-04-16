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
-------------------------------------------------------------------------------------------------------------------------------------
-- In CASE of rivalry:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	date,
	-- Identify the home team as Barcelona or Real Madrid
	CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona' 
        ELSE 'Real Madrid CF' END AS home,
    -- Identify the away team as Barcelona or Real Madrid
	CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona' 
        ELSE 'Real Madrid CF' END AS away
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634)
      AND (awayteam_id = 8633 OR hometeam_id = 8633);
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	date,
	CASE WHEN hometeam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END as home,
	CASE WHEN awayteam_id = 8634 THEN 'FC Barcelona' 
         ELSE 'Real Madrid CF' END as away,
	-- Identify all possible match outcomes
	CASE WHEN home_goal > away_goal AND hometeam_id = 8634 THEN 'Barcelona win!'
        WHEN home_goal > away_goal AND hometeam_id = 8633 THEN 'Real Madrid win!'
        WHEN home_goal < away_goal AND awayteam_id = 8634 THEN 'Barcelona win!'
        WHEN home_goal < away_goal AND awayteam_id = 8633 THEN 'Real Madrid win!'
        ELSE 'Tie!' END AS outcome
FROM matches_spain
WHERE (awayteam_id = 8634 OR hometeam_id = 8634)
      AND (awayteam_id = 8633 OR hometeam_id = 8633);
-------------------------------------------------------------------------------------------------------------------------------------
-- Filtering your CASE statement:
-------------------------------------------------------------------------------------------------------------------------------------
-- Select team_long_name and team_api_id from team
SELECT
	team_api_id,
	team_long_name
FROM teams_italy
-- Filter for team name
WHERE team_long_name = 'Bologna';
-------------------------------------------------------------------------------------------------------------------------------------
-- Select the season and date columns
SELECT 
	season,
	date,
    -- Identify when Bologna won a match
	CASE WHEN hometeam_id = 9857 AND home_goal > away_goal THEN 'Bologna Win'
		WHEN awayteam_id = 9857 AND away_goal > home_goal THEN 'Bologna Win' 
		END AS outcome
FROM matches_italy;
-------------------------------------------------------------------------------------------------------------------------------------
-- Select the season, date, home_goal, and away_goal columns
SELECT 
	season,
    date,
	home_goal,
	away_goal
FROM matches_italy
WHERE 
-- Exclude games not won by Bologna
	CASE WHEN hometeam_id = 9857 AND home_goal > away_goal THEN 'Bologna Win'
		WHEN awayteam_id = 9857 AND away_goal > home_goal THEN 'Bologna Win' 
		END IS NOT NULL;
-------------------------------------------------------------------------------------------------------------------------------------
-- CASE WHEN with aggregate functions:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
        season,
        COUNT(CASE WHEN hometeam_id = 8650
                   AND home_goal > away_goal
                   THEN id END) AS home_wins
FROM match
GROUP BY season;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
        season,
        COUNT(CASE WHEN hometeam_id = 8650 AND home_goal > away_goal
             THEN id END) AS home_wins,
        COUNT(CASE WHEN awayteam_id = 8650 AND away_goal > home_goal
              THEN id END) AS away_wins
FROM match
GROUP BY season;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
        season,
        COUNT(CASE WHEN hometeam_id = 8650 AND home_goal > away_goal
             THEN 54321 END) AS home_wins,
        COUNT(CASE WHEN awayteam_id = 8650 AND away_goal > home_goal
              THEN 'Some random text' END) AS away_wins
FROM match
GROUP BY season;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
        season,
        SUM(CASE WHEN hometeam_id = 8650
                THEN home_goal END) AS home_goals,
        SUM(CASE WHEN awayteam_id = 8650)
                THEN away_goal END) AS away_goals
FROM match
GROUP BY season;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
        season,
        AVG(CASE WHEN hometeam_id = 8650
                THEN home_goal END) AS home_goals
        AVG(CASE WHEN awayteam_id = 8650
                THEN away_goal END) AS away_goal
FROM match
GROUP BY season;
-------------------------------------------------------------------------------------------------------------------------------------
ROUND (3.14159653589,2)
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
        season,
        AVG(CASE WHEN hometeam_id = 8455 AND home_goal > away_goal THEN 1
                 WHEN hometeam_id = 8455 AND home_goal < away_goal THEN 0
                 END) AS pct_homewins,
        AVG(CASE WHEN awayteam_id = 8455 AND away_goal > home_goal THEN 1
                 WHEN awayteam_id = 8455 AND away_goal < home_goal THEN 0
                 END) AS pct_awaywins
FROM match
GROUP BY season;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
        season,
        ROUND(AVG(CASE WHEN hometeam_id = 8455 AND home_goal > away_goal THEN 1
                 WHEN hometeam_id = 8455 AND home_goal < away_goal THEN 0
                 END),2) AS pct_homewins,
        ROUND(AVG(CASE WHEN awayteam_id = 8455 AND away_goal > home_goal THEN 1
                 WHEN awayteam_id = 8455 AND away_goal < home_goal THEN 0
                 END),2) AS pct_awaywins
FROM match
GROUP BY season;
-------------------------------------------------------------------------------------------------------------------------------------
-- COUNT using CASE WHEN:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	c.name AS country,
    -- Count games from the 2012/2013 season
	COUNT(CASE WHEN m.season = '2012/2013' 
        	THEN m.id ELSE NULL END) AS matches_2012_2013
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY c.name;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	c.name AS country,
    -- Count matches in each of the 3 seasons
	COUNT(CASE WHEN m.season = '2012/2013' THEN m.id END) AS matches_2012_2013,
	COUNT(CASE WHEN m.season = '2013/2014' THEN m.id END) AS matches_2013_2014,
	COUNT(CASE WHEN m.season = '2014/2015' THEN m.id END) AS matches_2014_2015
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY c.name;
-------------------------------------------------------------------------------------------------------------------------------------
-- COUNT and CASE WHEN with multiple conditions:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	c.name AS country,
    -- Sum the total records in each season where the home team won
	SUM(CASE WHEN m.season = '2012/2013' AND m.home_goal > m.away_goal 
        THEN 1 ELSE 0 END) AS matches_2012_2013,
 	SUM(CASE WHEN m.season = '2013/2014' AND m.home_goal > m.away_goal
        THEN 1 ELSE 0 END) AS matches_2013_2014,
	SUM(CASE WHEN m.season = '2014/2015' AND m.home_goal > m.away_goal 
        THEN 1 ELSE 0 END) AS matches_2014_2015
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
-- Group by country name alias
GROUP BY c.name;
-------------------------------------------------------------------------------------------------------------------------------------
-- Calculating percent with CASE and AVG:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
    c.name AS country,
    -- Count the home wins, away wins, and ties in each country
	COUNT(CASE WHEN m.home_goal > m.away_goal THEN m.id 
        END) AS home_wins,
	COUNT(CASE WHEN m.home_goal < m.away_goal THEN m.id 
        END) AS away_wins,
	COUNT(CASE WHEN m.home_goal = m.away_goal THEN m.id 
        END) AS ties
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	c.name AS country,
    -- Calculate the percentage of tied games in each season
	AVG(CASE WHEN m.season='2013/2014' AND m.home_goal = m.away_goal THEN 1
			WHEN m.season='2013/2014' AND m.home_goal != m.away_goal THEN 0
			END) AS ties_2013_2014,
	AVG(CASE WHEN m.season='2014/2015' AND m.home_goal = m.away_goal THEN 1
			WHEN m.season='2014/2015' AND m.home_goal != m.away_goal THEN 0
			END) AS ties_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	c.name AS country,
    -- Round the percentage of tied games to 2 decimal points
	ROUND(AVG(CASE WHEN m.season='2013/2014' AND m.home_goal = m.away_goal THEN 1
			 WHEN m.season='2013/2014' AND m.home_goal != m.away_goal THEN 0
			 END),2) AS pct_ties_2013_2014,
	ROUND(AVG(CASE WHEN m.season='2014/2015' AND m.home_goal = m.away_goal THEN 1
			 WHEN m.season='2014/2015' AND m.home_goal != m.away_goal THEN 0
			 END),2) AS pct_ties_2014_2015
FROM country AS c
LEFT JOIN matches AS m
ON c.id = m.country_id
GROUP BY country;
