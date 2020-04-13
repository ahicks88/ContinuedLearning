Sorting and grouping

setwd("C:/Users/Andrew Hicks/Documents/Analytics/GitHub/ContinuedLearning/DataCamp/SQL/SQL Fundamental/Introduction to SQL/Datasets")
-------------------------------------------------------------------------------------------------------------------------------------
-- Sorting single columns
SELECT name FROM people
ORDER BY name;

SELECT name FROM people
ORDER BY name;

SELECT birthdate, name FROM people
ORDER BY birthdate;

-- Sorting single columns (2)
SELECT title FROM films
WHERE (release_year = 2000 OR release_year = 2012);

SELECT * FROM films
WHERE release_year <> 2015
ORDER BY duration;

SELECT title, gross FROM films
WHERE title LIKE 'M%'
ORDER BY title;

-- Sorting single columns (DESC)
SELECT imdb_score, film_id FROM reviews
ORDER BY imdb_score DESC;

SELECT title FROM films
ORDER BY title DESC;

SELECT title, duration FROM films
ORDER BY duration DESC;

-- Sorting multiple columns
SELECT birthdate, name FROM people
ORDER BY birthdate, name;

SELECT release_year, duration, title FROM films
ORDER BY release_year, duration;

SELECT certification, release_year, title FROM films
ORDER BY certification, release_year;

SELECT name, birthdate FROM people
ORDER BY name, birthdate;

-- GROUP BY practice
SELECT release_year, count(*) FROM films
GROUP BY release_year;

SELECT release_year, AVG(duration) FROM films
GROUP BY release_year;

SELECT release_year, MAX(budget) FROM films
GROUP BY release_year;

SELECT imdb_score, count(*) FROM reviews
GROUP BY imdb_score;

-- GROUP BY practice (2)
SELECT release_year, MIN(gross) FROM films
GROUP BY release_year;

SELECT language, SUM(gross) FROM films
GROUP BY language;

SELECT country, SUM(budget) FROM films
GROUP BY country;

SELECT release_year, country, MAX(budget) FROM films
GROUP BY release_year, country
ORDER BY release_year, country;

SELECT country, release_year, MIN(gross) FROM films
GROUP BY release_year, country
ORDER BY country, release_year;

-- HAVING a great time
SELECT release_year FROM films
GROUP BY release_year
HAVING COUNT(id) > 200;

-- All together now
SELECT release_year, budget, gross FROM films;

SELECT release_year, budget, gross FROM films
WHERE release_year > 1990;

SELECT release_year FROM films
WHERE release_year > 1990
GROUP BY release_year;

SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross FROM films
WHERE release_year > 1990
GROUP BY release_year;

SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross FROM films
WHERE release_year > 1990
GROUP BY release_year
HAVING AVG(budget) > 60000000;

SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross FROM films
WHERE release_year > 1990
GROUP BY release_year
HAVING AVG(budget) > 60000000
ORDER BY AVG(gross) DESC;

-- All together now (2)
-- select country, average budget, average gross
SELECT country, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
-- from the films table
FROM films
-- group by country 
GROUP BY country
-- where the country has more than 10 titles
HAVING COUNT(title) > 10
-- order by country
ORDER BY country
-- limit to only show 5 results
LIMIT 5;

-- A taste of things to come
SELECT title, imdb_score
FROM films
JOIN reviews
ON films.id = reviews.film_id
WHERE title = 'To Kill a Mockingbird';

SELECT imdb_score FROM reviews
JOIN films
ON reviews.film_id = films.id
WHERE title = 'To Kill a Mockingbird';
