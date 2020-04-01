Sorting and grouping

setwd("C:/Users/Andrew Hicks/Documents/Analytics/GitHub/ContinuedLearning/DataCamp/SQL/SQL Fundamental/Introduction to SQL/Datasets")

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