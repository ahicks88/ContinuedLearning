-------------------------------------------------------------------------------------------------------------------------------------
-- Title: Introduction to window functions
-------------------------------------------------------------------------------------------------------------------------------------
-- Introduction:
-------------------------------------------------------------------------------------------------------------------------------------
-- Row numbers
SELECT
    Year, Event, Country
FROM Summer_Medals
WHERE
    Medal = 'Gold';
-------------------------------------------------------------------------------------------------------------------------------------
-- Enter row number
SELECT
    Year, Event, Country
    ROW_NUMBER() OVER() AS Row_N
FROM Summer_Medals
WHERE
    Medal = 'Gold';
-------------------------------------------------------------------------------------------------------------------------------------
-- Numbering rows:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
  *,
  -- Assign numbers to each row
  ROW_NUMBER() OVER() AS Row_N
FROM Summer_Medals
ORDER BY Row_N ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Numbering Olympic games in ascending order:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
  Year,
  -- Assign numbers to each year
  ROW_NUMBER() OVER() AS Row_N
FROM (
  SELECT DISTINCT Year 
  FROM Summer_Medals
  ORDER BY Year ASC
) AS Years
ORDER BY Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- ORDER BY:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
    Year, Event, Country
    ROW_NUMBER() OVER (ORDER BY Year DESC) AS Row_N
FROM Summer_Medals
WHERE
    Medal = 'Gold';
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
    Year, Country AS Champion
FROM Summer_Medals
WHERE
    Year IN (1996, 2000, 2004, 2008, 2012)
    AND Gender = 'Men' AND Metal = 'Gold'
    AND Event = 'Discus Throw';
-------------------------------------------------------------------------------------------------------------------------------------
WITH Discus_Gold AS (
    SELECT
        Year, Country AS Champion
    FROM Summer_Medals
    WHERE
        Year IN (1996, 2000, 2004, 2008, 2012)
        AND Gender = 'Men' AND Metal = 'Gold'
        AND Event = 'Discus Throw';
)

SELECT
    Year, Champion
    LAG(Champion, 1) OVER
        (ORDER BY Year ASC) AS Last_Champion
FROM Discus_Gold
ORDER BY Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Numbering Olympic games in descending order:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
  Year,
  -- Assign the lowest numbers to the most recent years
  ROW_NUMBER() OVER (ORDER BY Year DESC) AS Row_N
FROM (
  SELECT DISTINCT Year
  FROM Summer_Medals
) AS Years
ORDER BY Year;
-------------------------------------------------------------------------------------------------------------------------------------
-- Numbering Olympic athletes by medals earned:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
  -- Count the number of medals each athlete has earned
  athlete,
  COUNT(medal) AS Medals
FROM Summer_Medals
GROUP BY Athlete
ORDER BY Medals DESC;
-------------------------------------------------------------------------------------------------------------------------------------
WITH Athlete_Medals AS (
  SELECT
    -- Count the number of medals each athlete has earned
    Athlete,
    COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete)

SELECT
  -- Number each athlete by how many medals they've earned
  Athlete,
  ROW_NUMBER() OVER (ORDER BY Medals DESC) AS Row_N
FROM Athlete_Medals
ORDER BY Medals DESC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Reigning weightlifting champions:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
  -- Return each year's champions' countries
  year,
  country AS champion
FROM Summer_Medals
WHERE
  Discipline = 'Weightlifting' AND
  Event = '69KG' AND
  Gender = 'Men' AND
  Medal = 'Gold';
-------------------------------------------------------------------------------------------------------------------------------------
WITH Weightlifting_Gold AS (
  SELECT
    -- Return each year's champions' countries
    Year,
    Country AS champion
  FROM Summer_Medals
  WHERE
    Discipline = 'Weightlifting' AND
    Event = '69KG' AND
    Gender = 'Men' AND
    Medal = 'Gold')

SELECT
  Year, Champion,
  -- Fetch the previous year's champion
  LAG(Champion,1) OVER
    (ORDER BY Year ASC) AS Last_Champion
FROM Weightlifting_Gold
ORDER BY Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- PARTITION BY:
-------------------------------------------------------------------------------------------------------------------------------------
WITH Discus_Gold AS (
    SELECT
        Year, Event, Country AS Champion
    FROM Summer_Medals
    WHERE
        Year IN (2004, 2008, 2012)
        AND Gender = 'Men' AND Metal = 'Gold'
        AND Event IN ('Discus Throw', 'Triple Jump')
        AND Gender = 'Men')

SELECT 
    Year, Event, Champion
    LAG(Champion) OVER
        (ORDER BY Event ASC, Year ASC) AS Last_Champion
FROM Discus_Gold
-------------------------------------------------------------------------------------------------------------------------------------
WITH Discus_Gold AS (...)

SELECT 
    Year, Event, Champion
    LAG(Champion) OVER
    (PARTITION BY Event
    ORDER BY Event ASC, Year ASC) AS Last_Champion
FROM Discus_Gold
ORDER BY Event ASC, Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
WITH Country_Gold AS (
    SELECT
        DISTINCT Year, Country, Event
    FROM Summer_Metals
    WHERE
        Year IN (2008, 2012)
        AND Country IN ('CHN', 'JPN')
        AND Gender = 'Women' AND Medal = 'Gold')

SELECT
    Year, Country, Event
    ROW_NUMBER() OVER (PARITION BY Year, Country)
FROM Country_Gold;
-------------------------------------------------------------------------------------------------------------------------------------
-- Reigning champions by gender:
-------------------------------------------------------------------------------------------------------------------------------------
WITH Tennis_Gold AS (
  SELECT DISTINCT
    Gender, Year, Country
  FROM Summer_Medals
  WHERE
    Year >= 2000 AND
    Event = 'Javelin Throw' AND
    Medal = 'Gold')

SELECT
  Gender, Year,
  Country AS Champion,
  -- Fetch the previous year's champion by gender
  LAG(Country) OVER (PARTITION BY Gender
            ORDER BY Gender ASC) AS Last_Champion
FROM Tennis_Gold
ORDER BY Gender ASC, Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Reigning champions by gender and event:
-------------------------------------------------------------------------------------------------------------------------------------
WITH Athletics_Gold AS (
  SELECT DISTINCT
    Gender, Year, Event, Country
  FROM Summer_Medals
  WHERE
    Year >= 2000 AND
    Discipline = 'Athletics' AND
    Event IN ('100M', '10000M') AND
    Medal = 'Gold')

SELECT
  Gender, Year, Event,
  Country AS Champion,
  -- Fetch the previous year's champion by gender and event
  LAG(Country) OVER (PARTITION BY gender, event
            ORDER BY Year ASC) AS Last_Champion
FROM Athletics_Gold
ORDER BY Event ASC, Gender ASC, Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
