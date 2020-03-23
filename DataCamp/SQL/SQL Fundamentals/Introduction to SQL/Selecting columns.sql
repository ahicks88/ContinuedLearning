-- Title: Selecting columns

setwd("C:/Users/Andrew Hicks/Documents/Analytics/GitHub/ContinuedLearning/DataCamp/SQL/SQL Fundamental/Introduction to SQL/Datasets")

-- Onboarding | Query Result
SELECT name FROM people;

-- Onboarding | Errors
-- Try running me!
SELECT 'DataCamp <3 SQL'
AS result;

-- Onboarding | Bullet Exercises
SELECT 'SQL'
AS result;

SELECT 'SQL is'
AS result;

SELECT 'SQL is cool!'
AS result;

-- SELECTing single columns
SELECT title
FROM films;

SELECT release_year
FROM films;
    
SELECT name
FROM people;

-- SELECTing multiple columns
SELECT title
FROM films;

SELECT title, release_year
FROM films;

SELECT title, release_year, country
FROM films;

SELECT *
FROM films;

-- SELECT DISTINCT
SELECT DISTINCT country
FROM films;

SELECT DISTINCT certification
FROM films;

SELECT DISTINCT role
FROM roles;

-- Learning to COUNT
SELECT COUNT(*)
FROM reviews;

-- Practice with COUNT
SELECT count(DISTINCT id)
FROM people;

SELECT COUNT(birthdate)
FROM people;

SELECT COUNT(DISTINCT birthdate)
FROM people;

SELECT COUNT(DISTINCT language)
FROM films;

SELECT COUNT(DISTINCT country)
FROM films;




