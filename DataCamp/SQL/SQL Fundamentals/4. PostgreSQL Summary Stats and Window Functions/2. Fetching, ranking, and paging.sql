-------------------------------------------------------------------------------------------------------------------------------------
-- Title: Fetching, ranking, and paging
-------------------------------------------------------------------------------------------------------------------------------------
-- Fetching:
-------------------------------------------------------------------------------------------------------------------------------------
-- LEAD
WITH Hosts AS (
    SELECT DISTINCT Year, City
    FROM Summer_Metals)

SELECT
    Year, City
    LEAD(City,1) OVER (ORDER BY Year ASC)
        AS Next_City,
    LEAD(City,2) OVER (ORDER BY Year ASC)
        AS After_Next_City,
FROM Hosts
ORDER BY Year ACS;
-------------------------------------------------------------------------------------------------------------------------------------
-- FIRST_VALUE and LAST_VALUE
SELECT 
    Year, City,
    FIRST_VALUE(City) OVER
        (ORDER BY Year ASC) AS First_City,
    LAST_VALUE(City) OVER (
        ORDER BY Year ASC
        RANGE BETWEEN
            UNBOUNDED PRECEDING and
            UNBOUNDED FOLLOWING
        ) AS Last_City
FROM Hosts
ORDER BY Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Future gold medalists:
-------------------------------------------------------------------------------------------------------------------------------------
WITH Discus_Medalists AS (
  SELECT DISTINCT
    Year,
    Athlete
  FROM Summer_Medals
  WHERE Medal = 'Gold'
    AND Event = 'Discus Throw'
    AND Gender = 'Women'
    AND Year >= 2000)

SELECT
  -- For each year, fetch the current and future medalists
  Year,
  Athlete,
  LEAD(Athlete,3) OVER (ORDER BY Year ASC) AS Future_Champion
FROM Discus_Medalists
ORDER BY Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- First athlete by name:
-------------------------------------------------------------------------------------------------------------------------------------
WITH All_Male_Medalists AS (
  SELECT DISTINCT
    Athlete
  FROM Summer_Medals
  WHERE Medal = 'Gold'
    AND Gender = 'Men')

SELECT
  -- Fetch all athletes and the first althete alphabetically
  Athlete,
  FIRST_VALUE(Athlete) OVER (
    ORDER BY Athlete ASC
  ) AS First_Athlete
FROM All_Male_Medalists;
-------------------------------------------------------------------------------------------------------------------------------------
-- Last country by name:
-------------------------------------------------------------------------------------------------------------------------------------
WITH Hosts AS (
  SELECT DISTINCT Year, City
    FROM Summer_Medals)

SELECT
  Year,
  City,
  -- Get the last city in which the Olympic games were held
  LAST_VALUE(city) OVER (
   ORDER BY Year ASC
   RANGE BETWEEN
     UNBOUNDED PRECEDING AND
     UNBOUNDED FOLLOWING
  ) AS Last_City
FROM Hosts
ORDER BY Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Ranking:
-------------------------------------------------------------------------------------------------------------------------------------
-- Spirce table
SELECT
    Country, COUNT(DISTINCT Year) AS games
FROM Summer_Medals
WHERE
    Country N ('GBR','DEN','FRA','ITA','AUT','BEL','NOR','POL','ESP')
GROUP BY Country
ORDER BY Games DESC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Different ranking functions - ROW_NUMBER
WITH Country_Games AS (...)

SELECT 
    Country, Games,
    ROW_NUMBER()
        OVER (ORDER BY Games DESC) AS ROW_NUMBER
FROM Country_Games
ORDER BY Games DESC, COUNTRY ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Different ranking functions - RANK
WITH Country_Games AS (...)

SELECT
    Country, Games,
    ROW_NUMBER()
        OVER (ORDER BY Games DESC) AS Row_N,
    RANK()
        OVER (ORDER BY Games DESC) AS Rank_N
FROM Country_Games
ORDER BY Games DESC, Country ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Different ranking functions - DENSE RANK
WITH Country_Games AS (...)

SELECT
    Country, Games,
    ROW_NUMBER()
        OVER (ORDER BY Games DESC) AS Row_N,
    RANK()
        OVER (ORDER BY Games DESC) AS Rank_N
    DENSE_RANK()
        OVER (ORDER BY Games DESC) AS Dense_Rank_N
FROM Country_Games
ORDER BY Games DESC, Country ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Ranking without partitioning - Source table
SELECT
    Country, Athlete, COUNT(*) AS Medals
FROM Summer_Medals
WHERE
    Country IN ('CHN','RUS')
    AND Year = 2012
GROUP BY Country, Athlete
HAVING COUNT(*) > 1
ORDER BY Country ASC, Medals DESC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Ranking without partitioning
WITH Country_Medals AS (...)

SELECT
    Country, Athlete, Medals
    DENSE_RANK()
        OVER (ORDER BY Medals DESC) AS Rank_N
FROM Country_Medals
ORDER BY Country ASC, Medals DESC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Ranking with partitioning
WITH Country_Medals AS (...)

SELECT
    Country, Athlete, Medals
    DENSE_RANK()
        OVER (PARTITIONING BY Country
            ORDER BY Medals DESC) AS Rank_N
FROM Country_Medals
ORDER BY Country ASC, Medals DESC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Ranking athletes by medals earned:
-------------------------------------------------------------------------------------------------------------------------------------
WITH Athlete_Medals AS (
  SELECT
    Athlete,
    COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete)

SELECT
  Athlete,
  Medals,
  -- Rank athletes by the medals they've won
  RANK() OVER (ORDER BY Medals DESC) AS Rank_N
FROM Athlete_Medals
ORDER BY Medals DESC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Ranking athletes from multiple countries:
-------------------------------------------------------------------------------------------------------------------------------------

WITH Athlete_Medals AS (
  SELECT
    Country, Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE
    Country IN ('JPN', 'KOR')
    AND Year >= 2000
  GROUP BY Country, Athlete
  HAVING COUNT(*) > 1)

SELECT
  Country,
  -- Rank athletes in each country by the medals they've won
  Athlete,
  DENSE_RANK() OVER (PARTITION BY Country
                ORDER BY Medals DESC) AS Rank_N
FROM Athlete_Medals
ORDER BY Country ASC, RANK_N ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Paging:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
    DISTINCT Discipline
FROM Summer_Medals;
-------------------------------------------------------------------------------------------------------------------------------------
-- Paging
WITH Disciplines AS (
    SELECT
        DISTINCT Discipline
    FROM Summer_Medals)

SELECT Discipline, NTILE(15) OVER() AS Page
FROM Disciplines
ORDER BY Page ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Top, middle, and bottom thirds
WITH Country_Medals AS (
    SELECT
        Country, COUNT(*) AS Medals
    FROM Summer_Medals
    GROUP BY Country)

SELECT Country, Medals,
    NTILE(3) OVER (ORDER BY Medals DESC) AS thirds
FROM Country_Medals;
-------------------------------------------------------------------------------------------------------------------------------------
-- Third averages
WITH Country_Medals AS (...),
     Thirds AS (
        SELECT
            Country, Medals,
            NTILE(3) OVER (ORDER BY Medals DESC) AS Third
        FROM Country_Medals)

SELECT
    Third,
    ROUND(AVG(Medals),2) AS Avg_Medals
FROM Thirds
GROUP BY Third
ORDER BY Third ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Paging events:
-------------------------------------------------------------------------------------------------------------------------------------
WITH Events AS (
  SELECT DISTINCT Event
  FROM Summer_Medals)
  
SELECT
  --- Split up the distinct events into 111 unique groups
  event,
  NTILE(111) OVER (ORDER BY event ASC) AS Page
FROM Events
ORDER BY Event ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Top, middle, and bottom thirds:
-------------------------------------------------------------------------------------------------------------------------------------
WITH Athlete_Medals AS (
  SELECT Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete
  HAVING COUNT(*) > 1)
  
SELECT
  Athlete,
  Medals,
  -- Split athletes into thirds by their earned medals
  NTILE(3) OVER(ORDER BY Medals DESC) AS Third
FROM Athlete_Medals
ORDER BY Medals DESC, Athlete ASC;
-------------------------------------------------------------------------------------------------------------------------------------
WITH Athlete_Medals AS (
  SELECT Athlete, COUNT(*) AS Medals
  FROM Summer_Medals
  GROUP BY Athlete
  HAVING COUNT(*) > 1),
  
  Thirds AS (
  SELECT
    Athlete,
    Medals,
    NTILE(3) OVER (ORDER BY Medals DESC) AS Third
  FROM Athlete_Medals)
  
SELECT
  -- Get the average medals earned in each third
  Third,
  AVG(Medals) AS Avg_Medals
FROM Thirds
GROUP BY Third
ORDER BY Third ASC;
-------------------------------------------------------------------------------------------------------------------------------------

