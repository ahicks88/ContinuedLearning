Subqueries

setwd("C:/Users/Andrew Hicks/Documents/Analytics/GitHub/ContinuedLearning/DataCamp/SQL/SQL Fundamental/Joining Data in SQL/Datasets")

-- Subqueries inside WHERE and SELECT clauses
SELECT AVG(fert_rate)
FROM states;

SELECT name, fert_rate
FROM states;
WHERE continent = 'Asia'
    AND fert_rate < 
        (SELECT AVG(fert_rate)
        FROM states);

SELECT DISTINCT continent
FROM prime_ministers;

SELECT DISTINCT continent,
    (SELECT COUNT(*)
    FROM states
    WHERE prime_ministers.continent = states.continent) AS countries_num
FROM prime_ministers;

-- Subquery inside where
-- Select average life_expectancy
SELECT AVG(life_expectancy)
  -- From populations
  FROM populations
-- Where year is 2015
WHERE year = 2015

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

-- Subquery inside where (2)
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

-- Subquery inside select

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

-- Subquery inside FROM clause
SELECT continent, MAX(women_parli_perc) AS max_perc
FROM states
GROUP BY continent
ORDER BY continent;

SELECT monarchs.continent
FROM monarchs, states
WHERE monarchs.continent = states.continent
ORDER BY continent;

SELECT DISTINCT monarchs.continent, subquery.max_perc
FROM monarchs,
    (SELECT continent, MAX(woman_parli_perc) AS max_perc
    FROM states
    GROUP BY continent) AS subquery
WHERE monarchs.continent = subquery.continent
ORDER BY continent;

-- Subquery inside from
-- Select fields (with aliases)
SELECT code, count(name) AS lang_num
  -- From languages
  FROM languages
-- Group by code
GROUP BY code;

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

-- Advanced subquery



