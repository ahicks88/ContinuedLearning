-- Title: Filtering rows

setwd("C:/Users/Andrew Hicks/Documents/Analytics/GitHub/ContinuedLearning/DataCamp/SQL/SQL Fundamental/Introduction to SQL/Datasets")
-------------------------------------------------------------------------------------------------------------------------------------
-- Simple filtering of numeric values
SELECT * FROM films
where release_year = 2016;

SELECT count(*) FROM films
WHERE release_year < 2000;

SELECT title FROM films
WHERE release_year > 2000;

-- Simple filtering of text
SELECT * FROM films
WHERE language = 'French';

SELECT name, birthdate
FROM people
WHERE birthdate = '1974-11-11';

SELECT COUNT(*) FROM films
WHERE language = 'Hindi';

SELECT * FROM films
WHERE certification = 'R';

-- WHERE AND
SELECT title, release_year FROM films
WHERE language = 'Spanish' AND release_year < 2000;

SELECT * FROM films
WHERE language = 'Spanish' AND release_year > 2000;

SELECT * FROM films
WHERE language = 'Spanish' AND release_year > 2000 AND release_year < 2010;

-- WHERE AND OR (2)
SELECT title, release_year FROM films
WHERE release_year >= 1990 AND release_year < 2000;

SELECT title, release_year FROM films
WHERE release_year >= 1990 AND release_year < 2000
AND (language = 'French' OR language = 'Spanish');

SELECT title, release_year FROM films
WHERE release_year >= 1990 AND release_year < 2000
AND (language = 'French' OR language = 'Spanish')
AND gross >= 2000000;

-- BETWEEN (2)
SELECT title, release_year FROM films
WHERE release_year between 1990 AND 2000;

SELECT title, release_year FROM films
WHERE release_year between 1990 AND 2000
AND budget > 100000000;

SELECT title, release_year FROM films
WHERE release_year between 1990 AND 2000
AND budget > 100000000 AND language = 'Spanish';

SELECT title, release_year FROM films
WHERE release_year between 1990 AND 2000
AND budget > 100000000 AND (language = 'Spanish' OR language = 'French');

-- WHERE IN
SELECT title, release_year from films
WHERE release_year IN (1990, 2000)
AND duration > 120;

SELECT title, language FROM films
WHERE language IN ('English', 'Spanish', 'French');

SELECT title, certification FROM films
WHERE certification IN ('NC-17', 'R');

-- Introduction to NULL and IS NULL
SELECT name FROM people
WHERE deathdate IS NULL;

SELECT title FROM films
WHERE budget IS NULL;

SELECT COUNT(*) FROM films
WHERE language IS NULL;

-- LIKE and NOT LIKE
SELECT name FROM people
WHERE name LIKE 'B%';

SELECT name FROM people
WHERE name LIKE '_r%';

SELECT name FROM people
WHERE name NOT LIKE 'A%';

-- 
