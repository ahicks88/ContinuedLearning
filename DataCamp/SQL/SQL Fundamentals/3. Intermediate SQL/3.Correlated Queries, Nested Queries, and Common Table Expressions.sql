-------------------------------------------------------------------------------------------------------------------------------------
-- Title: Correlated Queries, Nested Queries, and Common Table Expressions
-------------------------------------------------------------------------------------------------------------------------------------
-- Correlated Subqueries:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
    s.stage
    ROUND(s.avg_goals,2) AS avg_goal,
    (SELECT AVG(home_goal + away_goal)
    FROM match
    WHERE season = '2012/2013') AS overall_avg
FROM (SELECT
    stage,
    AVG(home_goal + away_goal) AS avg_goals
    FROM match
    WHERE season = '2012/2013'
    GROUP BY stage) AS s -- Subquery in FROM
WHERE s.avg_goals > (SELECT AVG(home_goal + away_goal)
    FROM match
    WHERE season = '2012/2013'); -- SUbquery in WHERE
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
    s.stage
    ROUND(s.avg_goals,2) AS avg_goal,
    (SELECT AVG(home_goal + away_goal)
    FROM match
    WHERE season = '2012/2013') AS overall_avg
FROM (SELECT
    stage,
    AVG(home_goal + away_goal) AS avg_goals
    FROM match
    WHERE season = '2012/2013'
    GROUP BY stage) AS s -- Subquery in FROM
WHERE s.avg_goals > (SELECT AVG(home_goal + away_goal)
    FROM match
    WHERE s.stage > m.stage);
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
    c.name AS country
    AVG(m.home_goal + m.away_goal) AS avg_goals
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
GROUP BY country;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
    c.name AS country,
    (SELECT
        AVG(home_goal + away_goal)
        FROM match AS m
        WHERE m.country_id = c.id)
            AS avg_goals
FROM country AS c
GROUP BY country;
-------------------------------------------------------------------------------------------------------------------------------------
-- Basic Correlated Subqueries:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	-- Select country ID, date, home, and away goals from match
	main.country_id,
    main.date,
    main.home_goal, 
    main.away_goal
FROM match AS main
WHERE 
	-- Filter the main query by the subquery
	(home_goal + away_goal) > 
        (SELECT AVG((sub.home_goal + sub.away_goal) * 3)
         FROM match AS sub
         -- Join the main query to the subquery in WHERE
         WHERE main.country_id = sub.country_id);
-------------------------------------------------------------------------------------------------------------------------------------
-- Correlated subquery with multiple conditions;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	-- Select country ID, date, home, and away goals from match
	main.country_id,
    main.date,
    main.home_goal,
    main.away_goal
FROM match AS main
WHERE 
	-- Filter for matches with the highest number of goals scored
	(home_goal + away_goal) = 
        (SELECT MAX(sub.home_goal + sub.away_goal)
         FROM match AS sub
         WHERE main.country_id = sub.country_id
               AND main.season = sub.season);
-------------------------------------------------------------------------------------------------------------------------------------
-- Nested subqueries:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
    c.name AS country,
    AVG(m.home_goal + m.away_goal) AS avg_goals,
    AVG(m.home_goal + m.away_goal) -
        (SELECT AVG(home_goal + away_goal)
        FROM match) AS avg_diff
FROM country AS c
LEFT JOIN match AS m
ON c.id = m.country_id
GROUP BY country;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
    EXTRACT(MONTH FROM date) AS month,
    SUM(m.home_goal + m.away_goal) AS total_goals,
    SUM(m.home_goal + m.away_goal) -
        (SELECT AVG(goals)
        FROM (SELECT
                EXTRACT(MONTH FROM date) AS month,
                SUM(home_goal + away_goal) AS goals
            FROM match
            GROUP BY month)) AS avg_diff
FROM match AS m
GROUP BY month;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
    c.name AS country
    (SELECT AVG(home_goal + away_goal)
    FROM match AS match
    WHERE m.country_id = c.id
        AND id IN (
            SELECT id
            FROM match
            WHERE season = '2011/2012')) AS avg_goals
FROM country AS c
GROUP BY country;
-------------------------------------------------------------------------------------------------------------------------------------
-- Nested simple subqueries:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
	-- Select the season and max goals scored in a match
	season,
    MAX(home_goal + away_goal) AS max_goals,
    -- Select the overall max goals scored in a match
   (SELECT MAX(home_goal + away_goal) FROM match) AS overall_max_goals,
   -- Select the max number of goals scored in any match in July
   (SELECT MAX(home_goal + away_goal) 
    FROM match
    WHERE id IN (
          SELECT id FROM match WHERE EXTRACT(MONTH FROM date) = 07)) AS july_max_goals
FROM match
GROUP BY season;
-------------------------------------------------------------------------------------------------------------------------------------
-- Nest a subquery in FROM:
-------------------------------------------------------------------------------------------------------------------------------------
-- Select matches where a team scored 5+ goals
SELECT
	country_id,
    season,
	id
FROM match
WHERE home_goal >= 5 OR away_goal >= 5;
-------------------------------------------------------------------------------------------------------------------------------------
-- Count match ids
SELECT
    country_id,
    season,
    COUNT(subquery.id) AS matches
-- Set up and alias the subquery
FROM (
	SELECT
    	country_id,
    	season,
    	id
	FROM match
	WHERE home_goal >= 5 OR away_goal >= 5) AS subquery
-- Group by country_id and season
GROUP BY country_id, season;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
	c.name AS country,
    -- Calculate the average matches per season
	AVG(outer_s.matches) AS avg_seasonal_high_scores
FROM country AS c
-- Left join outer_s to country
LEFT JOIN (
  SELECT country_id, season,
         COUNT(id) AS matches
  FROM (
    SELECT country_id, season, id
	FROM match
	WHERE home_goal >= 5 OR away_goal >= 5) AS inner_s
  -- Close parentheses and alias the subquery
  GROUP BY country_id, season) AS outer_s
ON c.id = outer_s.country_id
GROUP BY country;
-------------------------------------------------------------------------------------------------------------------------------------
-- Common Table Expressions:
-------------------------------------------------------------------------------------------------------------------------------------
WITH cte AS (
    SELECT col1 , col2
    FROM table)
SELECT
    AVG(col1) AS avg_col
FROM cte;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
    c.name AS country,
    COUNT(s.id) AS matches
FROM country AS c
INNER JOIN (
    SELECT country_id, id
    FROM match
    WHERE (home_goal + away_goal) >= 10) AS s
ON c.id = s.country_id
GROUP BY country;
-------------------------------------------------------------------------------------------------------------------------------------
(
    SELECT country_id, id
    FROM match
    WHERE (home_goal + away_goal) >= 10
)
SELECT
    c.name AS country,
    COUNT(s.id) AS matches
FROM country AS c
INNER JOIN s
ON c.id = s.country_id
GROUP BY country;
-------------------------------------------------------------------------------------------------------------------------------------
WITH s1 AS (
    SELECT country_id, id
    FROM match
    WHERE (home_goal + away_goal) >= 10),
s2 AS (                                     -- New subquery
    SELECT country_id, id
    FROM match
    WHERE (home_goal + away_goal) <= 1
)
SELECT 
    c.name AS country
    COUNT(s1.id) AS high_scores,
    COUNT(s2.id) AS low_scores              -- New column
FROM country AS c
INNER JOIN s1
ON c.id = s1.country_id
INNER JOIN s2                               -- New join
ON c.id = s1.country_id
GROUP BY country;
-------------------------------------------------------------------------------------------------------------------------------------
-- Cleaning up with CTEs:
-------------------------------------------------------------------------------------------------------------------------------------
-- Set up your CTE
WITH match_list AS (
    SELECT 
  		country_id, 
  		id
    FROM match
    WHERE (home_goal + away_goal) >= 10)
-- Select league and count of matches from the CTE
SELECT
    l.name AS league,
    COUNT(match_list.id) AS matches
FROM league AS l
-- Join the CTE to the league table
LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY l.name;
-------------------------------------------------------------------------------------------------------------------------------------
-- Organizing with CTEs:
-------------------------------------------------------------------------------------------------------------------------------------
-- Set up your CTE
WITH match_list AS (
  -- Select the league, date, home, and away goals
    SELECT 
  		l.name AS league, 
     	m.date, 
  		m.home_goal, 
  		m.away_goal,
       (m.home_goal + m.away_goal) AS total_goals
    FROM match AS m
    LEFT JOIN league as l ON m.country_id = l.id)
-- Select the league, date, home, and away goals from the CTE
SELECT league, date, home_goal, away_goal
FROM match_list
-- Filter by total goals
WHERE total_goals >= 10;
-------------------------------------------------------------------------------------------------------------------------------------
-- CTEs with nested subqueries:
-------------------------------------------------------------------------------------------------------------------------------------

------------------ Set up your CTE
WITH match_list AS (
    SELECT 
  		country_id,
  	   (home_goal + away_goal) AS goals
    FROM match
  	-- Create a list of match IDs to filter data in the CTE
    WHERE id IN (
       SELECT id
       FROM match
       WHERE season = '2013/2014' AND EXTRACT(MONTH FROM date) = 08))
-- Select the league name and average of goals in the CTE
SELECT 
	l.name,
    AVG(match_list.goals)
FROM league AS l
-- Join the CTE onto the league table
LEFT JOIN match_list ON l.id = match_list.country_id
GROUP BY l.name;
---------------------------------------------------------------------------------------------------------------------
-- Deciding on techniques to use:
-------------------------------------------------------------------------------------------------------------------------------------
-- Get team names with a subquery:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	m.id, 
    t.team_long_name AS hometeam
-- Left join team to match
FROM match AS m
LEFT JOIN team as t
ON m.hometeam_id = team_api_id;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
	m.date,
    -- Get the home and away team names
    home.hometeam,
    away.awayteam,
    m.home_goal,
    m.away_goal
FROM match AS m
-- Join the home subquery to the match table
LEFT JOIN (
  SELECT match.id, team.team_long_name AS hometeam
  FROM match
  LEFT JOIN team
  ON match.hometeam_id = team.team_api_id) AS home
ON home.id = m.id
-- Join the away subquery to the match table
LEFT JOIN (
  SELECT match.id, team.team_long_name AS awayteam
  FROM match
  LEFT JOIN team
  -- Get the away team ID in the subquery
  ON match.awayteam_id = team.team_api_id) AS away
ON away.id = m.id;
-------------------------------------------------------------------------------------------------------------------------------------
-- Get team names with correlated subqueries:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
    m.date,
   (SELECT team_long_name
    FROM team AS t
    -- Connect the team to the match table
    WHERE t.team_api_id = m.hometeam_id) AS hometeam
FROM match AS m;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
    m.date,
    (SELECT team_long_name
     FROM team AS t
     WHERE t.team_api_id = m.hometeam_id) AS hometeam,
    -- Connect the team to the match table
    (SELECT team_long_name
     FROM team AS t
     WHERE t.team_api_id = m.awayteam_id) AS awayteam,
    -- Select home and away goals
     m.home_goal,
     m.away_goal
FROM match AS m;
-------------------------------------------------------------------------------------------------------------------------------------
-- Get team names with CTEs:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	-- Select match id and team long name
    m.id, 
    t.team_long_name AS hometeam
FROM match AS m
-- Join team to match using team_api_id and hometeam_id
LEFT JOIN team AS t 
ON m.hometeam_id = t.team_api_id;
-------------------------------------------------------------------------------------------------------------------------------------
-- Declare the home CTE
WITH home AS (
	SELECT m.id, t.team_long_name AS hometeam
	FROM match AS m
	LEFT JOIN team AS t 
	ON m.hometeam_id = t.team_api_id)
-- Select everything from home
SELECT *
FROM home;
-------------------------------------------------------------------------------------------------------------------------------------
WITH home AS (
  SELECT m.id, m.date, 
  		 t.team_long_name AS hometeam, m.home_goal
  FROM match AS m
  LEFT JOIN team AS t 
  ON m.hometeam_id = t.team_api_id),
-- Declare and set up the away CTE
away AS (
  SELECT m.id, m.date, 
  		 t.team_long_name AS awayteam, m.away_goal
  FROM match AS m
  LEFT JOIN team AS t 
  ON m.awayteam_id = t.team_api_id)
-- Select date, home_goal, and away_goal
SELECT 
	home.date,
    home.hometeam,
    away.awayteam,
    home.home_goal,
    away.away_goal
-- Join away and home on the id column
FROM home
INNER JOIN away
ON home.id = away.id ;
-------------------------------------------------------------------------------------------------------------------------------------
