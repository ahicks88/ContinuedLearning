-------------------------------------------------------------------------------------------------------------------------------------
-- Title: Short and Simple Subqueries
-------------------------------------------------------------------------------------------------------------------------------------
-- WHERE are the Subqueries?:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT column
FROM (SELECT column
      FROM table) AS subquery;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT home_goal
FROM match
WHERE home_goal > (
        SELECT AVG(home_goal)
        FROM match);
-------------------------------------------------------------------------------------------------------------------------------------
SELECT AVG(home_goal) FROM match;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT home_goal
FROM match
WHERE home_goal > (
        SELECT AVG(home_goal)
        FROM match);
-------------------------------------------------------------------------------------------------------------------------------------
SELECT AVG(home_goal) FROM match;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT data, hometeam_id, awayteam_id, home_goal, away_goal
FROM match
WHERE season = '2012/2013'
      AND home_goal > 1.56091291478423;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT data, hometeam_id, awayteam_id, home_goal, away_goal
FROM match
WHERE season = '2012/2013'
      AND home_goal > (SELECT AVG(home_goal)
                       FROM match);
-------------------------------------------------------------------------------------------------------------------------------------
SELECT team_long_name,
       team_short_name AS abbr
FROM team
where   team_api_id IN
        (SELECT hometeam_id
        FROM match
        WHERE country_id = 15722);
-------------------------------------------------------------------------------------------------------------------------------------
-- Filtering using scalar subqueries:
-------------------------------------------------------------------------------------------------------------------------------------
-- Select the average of home + away goals, multiplied by 3
SELECT 
	3 * AVG(home_goal + away_goal)
FROM matches_2013_2014;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	-- Select the date, home goals, and away goals scored
    date,
	home_goal,
	away_goal
FROM  matches_2013_2014
-- Filter for matches where total goals exceeds 3x the average
WHERE (home_goal + away_goal) > 
       (SELECT 3 * AVG(home_goal + away_goal)
        FROM matches_2013_2014); 
-------------------------------------------------------------------------------------------------------------------------------------
-- Filtering using a subquery with a list:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	-- Select the team long and short names
	team_long_name,
	team_short_name
FROM team 
-- Exclude all values from the subquery
WHERE team_api_id NOT IN
     (SELECT DISTINCT hometeam_ID FROM match);
-------------------------------------------------------------------------------------------------------------------------------------
-- Filtering with more complex subquery conditions:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
	-- Select the team long and short names
	team_long_name,
	team_short_name
FROM team
-- Filter for teams with 8 or more home goals
WHERE team_api_id IN
	  (SELECT hometeam_id 
       FROM match
       WHERE home_goal >= 8);
-------------------------------------------------------------------------------------------------------------------------------------
-- Subqueries in FROM:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
        t.team_long_name AS team,
        AVG(m.home_goal) AS home_avg
FROM match AS m
LEFT JOIN team AS team_long_name
ON m.hometeam_id = t.team_api_id
WHERE season = '2011/2012'
GROUP BY team;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT team, home_avg
FROM (select 
                t.team_api_id AS team
                AVG(m.home_goal) AS home_avg
        FROM match AS m
        LEFT JOIN team AS t
        ON m.hometeam_id = t.team_api_id
        WHERE season = '2011/2012'
        GROUP BY team) AS subquery;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT team, home_avg
FROM (select 
                t.team_api_id AS team
                AVG(m.home_goal) AS home_avg
        FROM match AS m
        LEFT JOIN team AS t
        ON m.hometeam_id = t.team_api_id
        WHERE season = '2011/2012'
        GROUP BY team) AS subquery
ORDER BY home_avg DESC
LIMIT 3;
-------------------------------------------------------------------------------------------------------------------------------------
-- Joining Subqueries in FROM:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	-- Select the country ID and match ID
	country_id, 
    id 
FROM match
-- Filter for matches with 10 or more goals in total
WHERE (home_goal + away_goal) >= 10;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
	-- Select country name and the count match IDs
    c.name AS country_name,
    COUNT(sub.id) AS matches
FROM country AS c
-- Inner join the subquery onto country
-- Select the country id and match id columns
INNER JOIN (SELECT country_id, id 
           FROM match
           -- Filter the subquery by matches with 10+ goals
           WHERE (home_goal + away_goal) >= 10) AS sub
ON c.id = sub.country_id
GROUP BY country_name;
-------------------------------------------------------------------------------------------------------------------------------------
-- Building on Subqueries in FROM:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
	-- Select country, date, home, and away goals from the subquery
    country,
    date,
    home_goal,
    away_goal
FROM 
	-- Select country name, date, and total goals in the subquery
	(SELECT c.name AS country, 
     	    m.date, 
     		m.home_goal, 
     		m.away_goal,
           (m.home_goal + m.away_goal) AS total_goals
    FROM match AS m
    LEFT JOIN country AS c
    ON m.country_id = c.id) AS subquery
-- Filter by total goals scored in the main query
WHERE total_goals >= 10;
-------------------------------------------------------------------------------------------------------------------------------------
-- Subqueries in SELECT:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT COUNT(id) FROM match;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
        season,
        COUNT(id) AS matches,
        12837 AS total_matches
FROM match
GROUP BY season;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
        season,
        COUNT(id) AS matches,
        (SELECT COUNT(id) FROM match) AS total_matches
FROM match
GROUP BY season;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT AVG(home_goal + away_goal)
FROM match
WHERE season = '2011/2012';
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
        data,
        (home_goal + away_goal) AS goals,
        (home_goal + away_goal) - 2.72 AS diff
FROM match
WHERE season = '2011/2012';
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
        data,
        (home_goal + away_goal) AS goals,
        (home_goal + away_goal) - 
        (SELECT AVG(home_goal + away_goal)
        FROM match
        WHERE season = '2011/2012') AS diff
FROM match
WHERE season = '2011/2012';
-------------------------------------------------------------------------------------------------------------------------------------
-- Add a subquery to the SELECT clause:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	l.name AS league,
    -- Select and round the league's total goals
    ROUND(AVG(m.home_goal + m.away_goal), 2) AS avg_goals,
    -- Select & round the average total goals for the season
    (SELECT ROUND(AVG(home_goal + away_goal), 2) 
     FROM match
     WHERE season = '2013/2014') AS overall_avg
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
-- Filter for the 2013/2014 season
WHERE season = '2013/2014'
GROUP BY l.name;
-------------------------------------------------------------------------------------------------------------------------------------
-- Subqueries in Select for Calculations:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
	-- Select the league name and average goals scored
	l.name AS league,
	ROUND(AVG(m.home_goal + m.away_goal),2) AS avg_goals,
    -- Subtract the overall average from the league average
	ROUND(AVG(m.home_goal + m.away_goal) - 
		(SELECT AVG(home_goal + away_goal)
		 FROM match 
         WHERE season = '2013/2014'),2) AS diff
FROM league AS l
LEFT JOIN match AS m
ON l.country_id = m.country_id
-- Only include 2013/2014 results
WHERE season = '2013/2014'
GROUP BY l.name;
-------------------------------------------------------------------------------------------------------------------------------------
-- Subqueries everywhere! And best practices!:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
        col1,
        col2,
        col3
FROM table1
WHERE col1 = 2;
-------------------------------------------------------------------------------------------------------------------------------------
/* This query filters for col1 = 2 and only selects data from table1 */
SELECT
        col1,
        col2,
        col3
FROM table1
WHERE col1 = 2;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
        col1,
        col2,
        col3
FROM table1 -- this table has 10,000 rows
WHERE col1 = 2; -- Filter WHERE value 2
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
        col1,
        col2,
        col3
FROM table1
WHERE col1 IN
                (SELECT id
                FROM table2
                WHERE year = 1991);
-------------------------------------------------------------------------------------------------------------------------------------
-- ALL the Subqueries EVERYWHERE:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	-- Select the stage and average goals for each stage
	m.stage,
    ROUND(AVG(m.home_goal + m.away_goal),2) AS avg_goals,
    -- Select the average overall goals for the 2012/2013 season
    ROUND((SELECT AVG(home_goal + away_goal) 
           FROM match 
           WHERE season = '2012/2013'),2) AS overall
FROM match AS m
-- Filter for the 2012/2013 season
WHERE m.season = '2012/2013'
-- Group by stage
GROUP BY stage;
-------------------------------------------------------------------------------------------------------------------------------------
-- Add a subquery in FROM:
-------------------------------------------------------------------------------------------------------------------------------------

SELECT 
	-- Select the stage and average goals from the subquery
	s.stage,
	ROUND(s.avg_goals,2) AS avg_goals
FROM 
	-- Select the stage and average goals in 2012/2013
	(SELECT
		 stage,
         AVG(home_goal + away_goal) AS avg_goals
	 FROM match
	 WHERE season = '2012/2013'
	 GROUP BY stage) AS s
WHERE 
	-- Filter the main query using the subquery
	s.avg_goals > (SELECT AVG(home_goal + away_goal) 
                    FROM match WHERE season = '2012/2013');
-------------------------------------------------------------------------------------------------------------------------------------
SELECT 
	-- Select the stage and average goals from s
	s.stage,
    ROUND(s.avg_goals,2) AS avg_goal,
    -- Select the overall average for 2012/2013
    (SELECT AVG(home_goal + away_goal) FROM match WHERE season = '2012/2013') AS overall_avg
FROM 
	-- Select the stage and average goals in 2012/2013 from match
	(SELECT
		 stage,
         AVG(home_goal + away_goal) AS avg_goals
	 FROM match
	 WHERE season = '2012/2013'
	 GROUP BY stage) AS s
WHERE 
	-- Filter the main query using the subquery
	s.avg_goals > (SELECT AVG(home_goal + away_goal) 
                    FROM match WHERE season = '2012/2013');