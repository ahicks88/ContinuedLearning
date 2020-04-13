Set theory clauses

setwd("C:/Users/Andrew Hicks/Documents/Analytics/GitHub/ContinuedLearning/DataCamp/SQL/SQL Fundamental/Joining Data in SQL/Datasets")
-------------------------------------------------------------------------------------------------------------------------------------
-- State of the UNION
SELECT *
FROM monarchs;

SELECT prime_minister AS leader, country
FROM prime_ministers
UNION
SELECT monarch, country
FROM monarchs
ORDER BY country;

SELECT prime_minister AS leader, country
FROM prime_ministers
UNION ALL
SELECT monarch, country
FROM monarchs
ORDER BY country
LIMIT 10;

-- Union
-- Select fields from 2010 table
SELECT *
  -- From 2010 table
  FROM economies2010
	-- Set theory clause
	UNION
-- Select fields from 2015 table
 SELECT *
  -- From 2015 table
  FROM economies2015
-- Order by code and year
ORDER BY code, year;

-- Union (2)
-- Select field
SELECT country_code
  -- From cities
  FROM cities
	-- Set theory clause
UNION
-- Select field
SELECT code
  -- From currencies
  FROM currencies
-- Order by country_code
ORDER BY country_code;

-- Union all
-- Select fields
SELECT code, year
  -- From economies
  FROM economies
	-- Set theory clause
	UNION ALL
-- Select fields
SELECT country_code, year
  -- From populations
  FROM populations
-- Order by code, year
ORDER BY code, year;

-- INTERSECTional data science
SELECT country
FROM prime_ministers
INTERSECT
SELECT country
FROM presidents;

SELECT country, prime_minister AS leader
FROM prime_ministers
INTERSECT
SELECT country, president
FROM presidents;

-- Intersect
-- Select fields
SELECT code, year
  -- From economies
  FROM economies
	-- Set theory clause
	INTERSECT
-- Select fields
SELECT  country_code, year
  -- From populations
  FROM populations
-- Order by code and year
ORDER BY code, year;

-- Intersect (2)
-- Select fields
SELECT code, name
  -- From countries
  FROM countries
	-- Set theory clause
	INTERSECT
-- Select fields
SELECT country_code, name
  -- From cities
  FROM cities;

  -- EXCEPTional
  SELECT monarch, country
  FROM monarchs
  EXCEPT
  SELECT prime_minister, country
  FROM prime_ministers;

  -- Except
  -- Select field
SELECT name
  -- From cities
  FROM cities
	-- Set theory clause
	EXCEPT
-- Select field
SELECT capital
  -- From countries
  FROM countries
-- Order by result
ORDER BY name;

-- Except (2)
-- Select field
SELECT capital
  -- From countries
  FROM countries
	-- Set theory clause
	EXCEPT
-- Select field
SELECT name
  -- From cities
  FROM cities
-- Order by ascending capital
ORDER BY capital ASC;

--Semi-joins and Anti-joins
SELECT name
FROM states
WHERE indep_year < 1800;

SELECT president, country, continent
FROM presidents;

SELECT president, country, continent
FROM presidents
WHERE country IN
    (SELECT name
    FROM states
    WHERE indep_year < 1800);

SELECT president, country, continent
FROM presidents
WHERE ___ LIKE ___
    AND country ___ IN
        (SELECT name
        FROM states
        WHERE indep_year < 1800);

SELECT president, country, continent
FROM presidents
WHERE continent LIKE '%America'
    AND country NOT IN
        (SELECT name
        FROM states
        WHERE indep_year < 1800);

-- Semi-join
-- Select code
SELECT code
  -- From countries
  FROM countries
-- Where region is Middle East
WHERE region = 'Middle East';

/*
SELECT code
  FROM countries
WHERE region = 'Middle East';
*/

-- Select field
SELECT DISTINCT name
  -- From languages
  FROM languages
-- Order by name
ORDER BY name;

-- Select distinct fields
SELECT DISTINCT name
  -- From languages
  FROM languages
-- Where in statement
WHERE code IN
  -- Subquery
  (SELECT code
   FROM countries
   WHERE region = 'Middle East')
-- Order by name
ORDER BY name;

-- Diagnosing problems using anti-join
-- Select statement
SELECT COUNT(*)
  -- From countries
  FROM countries
-- Where continent is Oceania
WHERE continent = 'Oceania';

-- 5. Select fields (with aliases)
SELECT c1.code, c1.name, c2.basic_unit AS currency
  -- 1. From countries (alias as c1)
  FROM countries AS c1
  	-- 2. Join with currencies (alias as c2)
  	INNER JOIN currencies AS c2
    -- 3. Match on code
    ON c1.code = c2.code
-- 4. Where continent is Oceania
WHERE c1.continent = 'Oceania';

-- 3. Select fields
SELECT name, code
  -- 4. From Countries
  FROM countries
  -- 5. Where continent is Oceania
  WHERE continent = 'Oceania'
  	-- 1. And code not in
  	AND code NOT IN
  	-- 2. Subquery
  	(SELECT code
  	 FROM currencies);

-- Set theory challenge

-- Select the city name
SELECT name
  -- Alias the table where city name resides
  FROM  cities AS c1
  -- Choose only records matching the result of multiple set theory clauses
  WHERE country_code IN
(
    -- Select appropriate field from economies AS e
    SELECT e.code
    FROM economies AS e
    -- Get all additional (unique) values of the field from currencies AS c2  
    UNION ALL
    SELECT DISTINCT c2.code
    FROM currencies AS c2
    -- Exclude those appearing in populations AS p
    EXCEPT
    SELECT p.country_code
    FROM populations AS p
);
