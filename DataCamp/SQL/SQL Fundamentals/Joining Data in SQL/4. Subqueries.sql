setwd()
-------------------------------------------------------------------------------------------------------------------------------------
-- Title: Subqueries
-------------------------------------------------------------------------------------------------------------------------------------
-- Subqueries inside WHERE and SELECT clauses:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT AVG(fert_rate)
FROM states;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT name, fert_rate
FROM states;
WHERE continent = 'Asia'
    AND fert_rate < 
        (SELECT AVG(fert_rate)
        FROM states);
-------------------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT continent
FROM prime_ministers;

SELECT DISTINCT continent,
    (SELECT COUNT(*)
    FROM states
    WHERE prime_ministers.continent = states.continent) AS countries_num
FROM prime_ministers;
-------------------------------------------------------------------------------------------------------------------------------------
-- Subquery inside where:
-------------------------------------------------------------------------------------------------------------------------------------
-- Select average life_expectancy
SELECT AVG(life_expectancy)
  -- From populations
  FROM populations
-- Where year is 2015
WHERE year = 2015
-------------------------------------------------------------------------------------------------------------------------------------
-- Select fields
SELECT *
  -- From populations
  FROM populations
-- Where life_expectancy is greater than
WHERE life_expectancy > 
  -- 1.15 * subquery
  1.15 *
   (SELECT AVG(life_expectancy)
   FROM populations
   WHERE year = 2015)
  AND year = 2015;
-------------------------------------------------------------------------------------------------------------------------------------
-- Subquery inside where (2):
-------------------------------------------------------------------------------------------------------------------------------------
-- 2. Select fields
SELECT name, country_code, urbanarea_pop
  -- 3. From cities
  FROM cities
-- 4. Where city name in the field of capital cities
WHERE name IN
  -- 1. Subquery
  (SELECT capital
   FROM countries)
ORDER BY urbanarea_pop DESC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Subquery inside select:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT countries.name AS country, COUNT(*) AS cities_num
  FROM cities
    INNER JOIN countries
    ON countries.code = cities.country_code
GROUP BY country
ORDER BY cities_num DESC, country
LIMIT 9;

/* 
SELECT ___ AS ___,
  (SELECT ___
   FROM ___
   WHERE countries.code = cities.country_code) AS cities_num
FROM ___
ORDER BY ___ ___, ___
LIMIT 9;
*/
-------------------------------------------------------------------------------------------------------------------------------------
/*SELECT countries.name AS country, COUNT(*) AS cities_num
  FROM cities
    INNER JOIN countries
    ON countries.code = cities.country_code
GROUP BY country
ORDER BY cities_num DESC, country
LIMIT 9;
*/

SELECT countries.name AS country,
  (SELECT count(*)
   FROM cities
   WHERE countries.code = cities.country_code) AS cities_num
FROM countries
ORDER BY cities_num DESC, country
LIMIT 9;
-------------------------------------------------------------------------------------------------------------------------------------
-- Subquery inside FROM clause:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT continent, MAX(women_parli_perc) AS max_perc
FROM states
GROUP BY continent
ORDER BY continent;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT monarchs.continent
FROM monarchs, states
WHERE monarchs.continent = states.continent
ORDER BY continent;
-------------------------------------------------------------------------------------------------------------------------------------
SELECT DISTINCT monarchs.continent, subquery.max_perc
FROM monarchs,
    (SELECT continent, MAX(woman_parli_perc) AS max_perc
    FROM states
    GROUP BY continent) AS subquery
WHERE monarchs.continent = subquery.continent
ORDER BY continent;
-------------------------------------------------------------------------------------------------------------------------------------
-- Subquery inside from:
-------------------------------------------------------------------------------------------------------------------------------------
-- Select fields (with aliases)
SELECT code, count(name) AS lang_num
  -- From languages
  FROM languages
-- Group by code
GROUP BY code;
-------------------------------------------------------------------------------------------------------------------------------------
-- Select fields
SELECT countries.local_name, subquery.lang_num
  -- From countries
  FROM countries,
  	-- Subquery (alias as subquery)
  	(SELECT code, count(name) AS lang_num
  	 FROM languages
  	 GROUP BY code) AS subquery
  -- Where codes match
  WHERE countries.code = subquery.code
-- Order by descending number of languages
ORDER BY subquery.lang_num DESC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Advanced subquery:
-------------------------------------------------------------------------------------------------------------------------------------
-- Select fields
SELECT c.name, c.continent, MAX(e.inflation_rate) AS inflation_rate
  -- From countries
  FROM countries c
  	-- Join to economies
  	INNER JOIN economies e
    -- Match on code
    USING(code)
-- Where year is 2015
WHERE year = 2015

GROUP BY c.name, c.continent;
-------------------------------------------------------------------------------------------------------------------------------------
-- Select the maximum inflation rate as max_inf
SELECT MAX(inflation_rate) AS max_inf
  -- Subquery using FROM (alias as subquery)
  FROM (
      SELECT name, continent, inflation_rate
      FROM countries
      INNER JOIN economies
      USING (code)
      WHERE year = 2015) AS Subquery
-- Group by continent
GROUP BY continent;
-------------------------------------------------------------------------------------------------------------------------------------
-- Select fields
SELECT name, continent, inflation_rate
  -- From countries
  FROM countries
	-- Join to economies
	INNER JOIN economies
	-- Match on code
	ON countries.code = economies.code
  -- Where year is 2015
  WHERE year = 2015
    -- And inflation rate in subquery (alias as subquery)
    AND inflation_rate IN (
        SELECT MAX(inflation_rate) AS max_inf
        FROM (
             SELECT name, continent, inflation_rate
             FROM countries
             INNER JOIN economies
             ON countries.code = economies.code
             WHERE year = 2015) AS subquery
      -- Group by continent
        GROUP BY continent);
-------------------------------------------------------------------------------------------------------------------------------------
-- Subquery challenge:
-------------------------------------------------------------------------------------------------------------------------------------
-- Select fields
SELECT code, inflation_rate, unemployment_rate
  -- From economies
  FROM economies
  -- Where year is 2015 and code is not in
  WHERE year = 2015 AND code NOT IN
  	-- Subquery
  	(SELECT code
  	 FROM countries
  	 WHERE (gov_form = 'Constitutional Monarchy' OR gov_form LIKE '%Republic%'))
-- Order by inflation rate
ORDER BY inflation_rate ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Course review:
-------------------------------------------------------------------------------------------------------------------------------------
Types of joins
> INNER JOIN
  > Self-joins
> OUTER JOIN
  > LEFT JOIN
  > RIGHT JOIN
  > FULL JOIN
> CROSS JOIN
> Semi-join / Anti-join
-------------------------------------------------------------------------------------------------------------------------------------
-- Final challenge:
-------------------------------------------------------------------------------------------------------------------------------------
-- Select fields
SELECT DISTINCT c.name, e.total_investment, e.imports
  -- From table (with alias)
  FROM countries AS c
    -- Join with table (with alias)
    LEFT JOIN economies AS e
      -- Match on code
      ON (c.code = e.code
      -- and code in Subquery
        AND c.code IN (
          SELECT l.code
          FROM languages AS l
          WHERE official = 'true'
        ) )
  -- Where region and year are correct
  WHERE e.year = 2015 AND c.region = 'Central America'
-- Order by field
ORDER BY c.name, e.total_investment, e.imports;
-------------------------------------------------------------------------------------------------------------------------------------
-- Final challenge (2):
-------------------------------------------------------------------------------------------------------------------------------------
-- Select fields
SELECT c.region, c.continent , AVG(p.fertility_rate) AS avg_fert_rate
  -- From left table
  FROM countries AS c
    -- Join to right table
    INNER JOIN populations AS p
      -- Match on join condition
      ON c.code = p.country_code
  -- Where specific records matching some condition
  WHERE p.year = 2015
-- Group appropriately
GROUP BY c.region, c.continent
-- Order appropriately
ORDER BY avg_fert_rate;
-------------------------------------------------------------------------------------------------------------------------------------
-- Final challenge (3):
-------------------------------------------------------------------------------------------------------------------------------------
-- Select fields
SELECT cities.name, cities.country_code, cities.city_proper_pop, cities.metroarea_pop,  
      -- Calculate city_perc
     city_proper_pop / metroarea_pop * 100 AS city_perc
  -- From appropriate table
  FROM cities
  -- Where 
  WHERE name IN
    -- Subquery
    (SELECT capital
     FROM countries
     WHERE (continent = 'Europe'
        OR continent LIKE '%America'))
       AND metroarea_pop IS NOT NULL
-- Order appropriately
ORDER BY city_perc DESC
-- Limit amount
LIMIT 10;