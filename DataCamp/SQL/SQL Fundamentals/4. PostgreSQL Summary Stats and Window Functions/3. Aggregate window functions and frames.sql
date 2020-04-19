-------------------------------------------------------------------------------------------------------------------------------------
-- Title: Aggregate window functions and frames
-------------------------------------------------------------------------------------------------------------------------------------
-- Aggregate window functions:
-------------------------------------------------------------------------------------------------------------------------------------
-- Source table
SELECT
    Year, COUNT(*) AS Medals
FROM Summer_Medals
WHERE
    Country = 'BRA'
    AND Medal = 'Gold'
    AND Year >= 1992
GROUP BY Year
ORDER BY Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Aggregate functions: MAX Result
WITH Brazil_Medals AS (...)

SELECT MAX(Medals) AS Max_Medals
FROM Brazil_Medals
-------------------------------------------------------------------------------------------------------------------------------------
-- Aggregate functions: SUM Result
WITH Brazil_Medals AS (...)

SELECT SUM(Medals) AS Total_Medals
FROM Brazil_Medals
-------------------------------------------------------------------------------------------------------------------------------------
-- MAX Window function
WITH Brazil_Medals AS (...)

SELECT
    Year, Medals,
    MAX(Medals)
        OVER (ORDER BY Year ASC) AS Max_Medals
FROM Brazil_Medals;
-------------------------------------------------------------------------------------------------------------------------------------
-- SUM Window function
WITH Brazil_Medals AS (...)

SELECT
    Year, Medals,
    SUM(Medals)
        OVER (ORDER BY Year ASC) AS Medals_RT
FROM Brazil_Models;
-------------------------------------------------------------------------------------------------------------------------------------
-- Partitioning with aggregate window functions
WITH Medals AS (...)
SELECT Year, Country, Medals,
    SUM(Meals) OVER (...)
FROM Medals;

WITH Medals AS (...)
SELECT Year, Country, Medals,
    SUM(Meals) OVER (PARTITION BY Country ...)
FROM Medals;
-------------------------------------------------------------------------------------------------------------------------------------
-- Running totals of athlete medals:
-------------------------------------------------------------------------------------------------------------------------------------
WITH Athlete_Medals AS (
  SELECT
    Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'USA' AND Medal = 'Gold'
    AND Year >= 2000
  GROUP BY Athlete)

SELECT
  -- Calculate the running total of athlete medals
  athlete,
  medals,
  SUM(medals) OVER (ORDER BY athlete ASC) AS Max_Medals
FROM Athlete_Medals
ORDER BY Athlete ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Maximum country medals by year:
-------------------------------------------------------------------------------------------------------------------------------------
WITH Country_Medals AS (
  SELECT
    Year, Country, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country IN ('CHN', 'KOR', 'JPN')
    AND Medal = 'Gold' AND Year >= 2000
  GROUP BY Year, Country)

SELECT
  -- Return the max medals earned so far per country
  country,
  year,
  medals,
  MAX(medals) OVER (PARTITION BY Country
                ORDER BY year ASC) AS Max_Medals
FROM Country_Medals
ORDER BY Country ASC, Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Minimum country medals by year:
-------------------------------------------------------------------------------------------------------------------------------------
WITH France_Medals AS (
  SELECT
    Year, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'FRA'
    AND Medal = 'Gold' AND Year >= 2000
  GROUP BY Year)

SELECT
  year,
  medals,
  MIN(medals) OVER (ORDER BY year ASC) AS Min_Medals
FROM France_Medals
ORDER BY Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Frames:
-------------------------------------------------------------------------------------------------------------------------------------
LAST_VALUE(City) OVER(
    ORDER BY Year ASC  
    RANGE BETWEEN
        UNBOUNDED PRECEDING AND
        UNBOUNDED FOLLOWING
) AS Last_City;
-------------------------------------------------------------------------------------------------------------------------------------
ROWS BETWEEN 3 PRECEDING AND CURRENT ROW;
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING;
-------------------------------------------------------------------------------------------------------------------------------------
-- Source table
SELECT
    Year, COUNT(*) AS Medals
FROM Summer_Medals
WHERE
    Country = 'RUS'
    AND Medal = 'Gold'
GROUP BY Year
ORDER BY Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- MAX without a frame
WITH Russia_Model AS (...)

SELECT 
    Year, Medals,
    MAX(Medals)
        OVER (ORDER BY Year ASC) AS Max_Medals
FROM Russia_Medals
ORDER BY Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- MAX with a frame
WITH Russia_Model AS (...)

SELECT 
    Year, Medals,
    MAX(Medals)
        OVER (ORDER BY Year ASC
            ROWS BETWEEN
            1 PRECEDING AND CURRENT ROW)
        AS Max_Medals_Last
FROM Russia_Medals
ORDER BY Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Current and following rows
WITH Russia_Model AS (...)

SELECT 
    Year, Medals,
    MAX(Medals)
        OVER (ORDER BY Year ASC
            ROWS BETWEEN
            CURRENT ROW AND 1 FOLLOWING)
        AS Max_Medals_Next
FROM Russia_Medals
ORDER BY Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Moving maximum of Scandinavian athletes' medals:
-------------------------------------------------------------------------------------------------------------------------------------
WITH Scandinavian_Medals AS (
  SELECT
    Year, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country IN ('DEN', 'NOR', 'FIN', 'SWE', 'ISL')
    AND Medal = 'Gold'
  GROUP BY Year)

SELECT
  -- Select each year's medals
  year,
  medals,
  -- Get the max of the current and next years'  medals
  MAX(medals) OVER (ORDER BY year ASC
             ROWS BETWEEN CURRENT ROW
             AND 1 FOLLOWING) AS Max_Medals
FROM Scandinavian_Medals
ORDER BY Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Moving maximum of Chinese athletes' medals:
-------------------------------------------------------------------------------------------------------------------------------------
WITH Chinese_Medals AS (
  SELECT
    Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'CHN' AND Medal = 'Gold'
    AND Year >= 2000
  GROUP BY Athlete)

SELECT
  -- Select the athletes and the medals they've earned
  athlete,
  medals,
  -- Get the max of the last two and current rows' medals 
  MAX(medals) OVER (ORDER BY athlete ASC
            ROWS BETWEEN 2 PRECEDING
            AND CURRENT ROW) AS Max_Medals
FROM Chinese_Medals
ORDER BY Athlete ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Moving averages and totals:
-------------------------------------------------------------------------------------------------------------------------------------
-- Source table
SELECT
    Year, COUNT(*) AS Medals
FROM Summer_Medals
WHERE
    Country = 'USA'
    AND Medal = 'Gold'
    AND Year >= 1980
GROUP BY Year
ORDER BY Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Moving average
WITH US_Medals AS (...)

SELECT
    Year, Medals,
    AVG(Medals) OVER
        (ORDER BY Year ASC
        ROW BETWEEN
        2 PRECEDING AND CURRENT ROW) AS Medals_MA
FROM US_Medals
ORDER BY Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Moving total
WITH US_Medals AS (...)

SELECT
    Year, Medals,
    SUM(Medals) OVER
        (ORDER BY Year ASC
        ROW BETWEEN
        2 PRECEDING AND CURRENT ROW) AS Medals_MT
FROM US_Medals
ORDER BY Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Moving average of Russian medals:
-------------------------------------------------------------------------------------------------------------------------------------
WITH Russian_Medals AS (
  SELECT
    Year, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country = 'RUS'
    AND Medal = 'Gold'
    AND Year >= 1980
  GROUP BY Year)

SELECT
  Year, Medals,
  --- Calculate the 3-year moving average of medals earned
  AVG(medals) OVER
    (ORDER BY Year ASC
     ROWS BETWEEN
     2 PRECEDING AND CURRENT ROW) AS Medals_MA
FROM Russian_Medals
ORDER BY Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Moving total of countries' medals:
-------------------------------------------------------------------------------------------------------------------------------------
WITH Country_Medals AS (
  SELECT
    Year, Country, COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Year, Country)

SELECT
  Year, Country, Medals,
  -- Calculate each country's 3-game moving total
  SUM(medals) OVER
    (PARTITION BY country
     ORDER BY Year ASC
     ROWS BETWEEN
     2 PRECEDING AND CURRENT ROW) AS Medals_MA
FROM Country_Medals
ORDER BY Country ASC, Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
