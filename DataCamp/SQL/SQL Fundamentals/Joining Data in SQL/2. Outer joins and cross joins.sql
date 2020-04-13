Outer joins and cross joins

setwd("C:/Users/Andrew Hicks/Documents/Analytics/GitHub/ContinuedLearning/DataCamp/SQL/SQL Fundamental/Joining Data in SQL/Datasets")

-- LEFT and RIGHT JOINs
SELECT p1.country, prime_minister, preseident
FROM prime_minister AS p1
LEFT JOIN preseidents AS p2
ON p1.country = p2.country;

SELECT right_table.id AS R_id,
       left_table.val AS L_val,
       right_table.val AS R_val
FROM left_table
RIGHT JOIN right_table
ON left_table.id = right_table.id;

-- Left Join
-- Select the city name (with alias), the country code,
-- the country name (with alias), the region,
-- and the city proper population
SELECT c1.name AS city, code, c2.name AS country,
       region, city_proper_pop
-- From left table (with alias)
FROM cities AS c1
  -- Join to right table (with alias)
  INNER JOIN countries AS c2
    -- Match on country code
    ON c1.country_code = c2.code
-- Order by descending country code
ORDER BY code DESC;

SELECT c1.name AS city, code, c2.name AS country,
       region, city_proper_pop
FROM cities AS c1
  -- 1. Join right table (with alias)
  LEFT JOIN countries AS c2
    -- 2. Match on country code
    ON c1.country_code = c2.code
-- 3. Order by descending country code
ORDER BY code DESC;

-- Left Join (2)

/*
5. Select country name AS country, the country's local name,
the language name AS language, and
the percent of the language spoken in the country
*/
SELECT c.name AS country, local_name, l.name AS language, percent
-- 1. From left table (alias as c)
FROM countries AS c
  -- 2. Join to right table (alias as l)
  INNER JOIN languages AS l
    -- 3. Match on fields
    ON c.code = l.code
-- 4. Order by descending country
ORDER BY country DESC;

/*
5. Select country name AS country, the country's local name,
the language name AS language, and
the percent of the language spoken in the country
*/
SELECT c.name AS country, local_name, l.name AS language, percent
-- 1. From left table (alias as c)
FROM countries AS c
  -- 2. Join to right table (alias as l)
  LEFT JOIN languages AS l
    -- 3. Match on fields
    ON c.code = l.code
-- 4. Order by descending country
ORDER BY country DESC;

-- Left Join (3)

-- 5. Select name, region, and gdp_percapita
SELECT name, region, gdp_percapita
-- 1. From countries (alias as c)
FROM countries AS c
  -- 2. Left join with economies (alias as e)
  LEFT JOIN economies AS e
    -- 3. Match on code fields
    ON c.code = e.code
-- 4. Focus on 2010
WHERE year = 2010;

-- Select fields
SELECT region, AVG(gdp_percapita) AS avg_gdp
-- From countries (alias as c)
FROM countries AS c
  -- Left join with economies (alias as e)
  LEFT JOIN economies AS e
    -- Match on code fields
    ON c.code = e.code
-- Focus on 2010
WHERE year = 2010
-- Group by region
GROUP BY region;

-- Select fields
SELECT region, AVG(gdp_percapita) AS avg_gdp
-- From countries (alias as c)
FROM countries AS c
  -- Left join with economies (alias as e)
  LEFT JOIN economies AS e
    -- Match on code fields
    ON c.code = e.code
-- Focus on 2010
WHERE year = 2010
-- Group by region
GROUP BY region
-- Order by descending avg_gdp
ORDER BY avg_gdp DESC;

-- Righ join
-- convert this code to use RIGHT JOINs instead of LEFT JOINs
/*
SELECT cities.name AS city, urbanarea_pop, countries.name AS country,
       indep_year, languages.name AS language, percent
FROM cities
  LEFT JOIN countries
    ON cities.country_code = countries.code
  LEFT JOIN languages
    ON countries.code = languages.code
ORDER BY city, language;
*/

SELECT cities.name AS city, urbanarea_pop, countries.name AS country,
       indep_year, languages.name AS language, percent
FROM languages
  RIGHT JOIN countries
    ON languages.code = countries.code
  RIGHT JOIN cities
    ON countries.code = cities.country_code
ORDER BY city, language;

--Full Joins
SELECT  left_table.id AS L_id,
        right_table.id AS R_id,
        left_table.val AS L_val,
        right_table.val AS R_val
FROM left_table
FULL JOIN right_table
USING (id);

SELECT p1.country AS pm_co, p2.country AS pres_co,
    prime_minister, president
FROM prime_ministers AS p1
FULL JOIN presidents AS p2
ON p1.country = p2.country

-- Full Join
SELECT name AS country, code, region, basic_unit
-- 3. From countries
FROM countries
  -- 4. Join to currencies
  FULL JOIN currencies
    -- 5. Match on code
    USING (code)
-- 1. Where region is North America or null
WHERE region = 'North America' OR region IS null
-- 2. Order by region
ORDER BY region;

SELECT name AS country, code, region, basic_unit
-- 1. From countries
FROM countries
  -- 2. Join to currencies
  LEFT JOIN currencies
    -- 3. Match on code
    USING (code)
-- 4. Where region is North America or null
WHERE region = 'North America' OR region IS null
-- 5. Order by region
ORDER BY region;

SELECT name AS country, code, region, basic_unit
FROM countries
  -- 1. Join to currencies
  INNER JOIN currencies
    USING (code)
-- 2. Where region is North America or null
WHERE region = 'North America' OR region IS NULL
-- 3. Order by region
ORDER BY region;

-- Full join (2)

SELECT countries.name, code, languages.name AS language
-- 3. From languages
FROM languages
  -- 4. Join to countries
  FULL JOIN countries
    -- 5. Match on code
    USING (code)
-- 1. Where countries.name starts with V or is null
WHERE countries.name LIKE 'V%' OR countries.name IS null
-- 2. Order by ascending countries.name
ORDER BY countries.name ASC;

SELECT countries.name, code, languages.name AS language
FROM languages
  -- 1. Join to countries
  LEFT JOIN countries
    -- 2. Match using code
    USING (code)
-- 3. Where countries.name starts with V or is null
WHERE countries.name LIKE 'V%' OR countries.name IS NULL
ORDER BY countries.name;

SELECT countries.name, code, languages.name AS language
FROM languages
  -- 1. Join to countries
  INNER JOIN countries
    USING (code)
-- 2. Where countries.name starts with V or is null
WHERE countries.name LIKE 'V%' OR countries.name IS NULL
ORDER BY countries.name;

-- Full join (3)

-- 7. Select fields (with aliases)
SELECT c1.name AS country, region, l.name AS language, basic_unit, frac_unit
-- 1. From countries (alias as c1)
FROM countries AS c1
  -- 2. Join with languages (alias as l)
  FULL JOIN languages AS l
    -- 3. Match on code
    USING(code)
  -- 4. Join with currencies (alias as c2)
  FULL JOIN currencies AS c2
    -- 5. Match on code
    USING(code)
-- 6. Where region like Melanesia and Micronesia
WHERE region LIKE 'M%esia';

-- CROSSing the rubicon
SELECT prime_minister, president
FROM prime_ministers AS p1
CROSS JOIN presidents AS p2
WHERE p1.continent IN ('North America', 'Oceania');

-- A table of two cities
-- 4. Select fields
SELECT c.name AS city, l.name AS language
-- 1. From cities (alias as c)
FROM cities AS c        
  -- 2. Join to languages (alias as l)
  CROSS JOIN languages AS l
-- 3. Where c.name like Hyderabad
WHERE c.name LIKE 'Hyder%';

-- 5. Select fields
SELECT c.name AS city, l.name AS language
-- 1. From cities (alias as c)
FROM cities AS c  
  -- 2. Join to languages (alias as l)
  INNER JOIN languages AS l
    -- 3. Match on country code
    ON l.code = c.country_code
-- 4. Where c.name like Hyderabad
WHERE c.name LIKE 'Hyder%';

-- Outer challenge
-- Select fields
SELECT c.name AS country, c.region, p.life_expectancy AS life_exp
-- From countries (alias as c)
FROM countries AS c
  -- Join to populations (alias as p)
LEFT JOIN populations as p
    -- Match on country code
ON c.code = p.country_code
-- Focus on 2010
WHERE p.year = 2010
-- Order by life_exp
ORDER BY life_exp
-- Limit to 5 records
LIMIT 5;