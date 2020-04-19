-------------------------------------------------------------------------------------------------------------------------------------
-- Title: Beyond window functions
-------------------------------------------------------------------------------------------------------------------------------------
-- Pivoting:
-------------------------------------------------------------------------------------------------------------------------------------
-- Enter CROSSTAB
CREATE EXTENTION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB($$
    source_sql TEXT
    $$) AS ct (column_1 DATA_TYPE_1,
               column_2 DATA_TYPE_2,
               ...,
               column_n DATA_TYPE_N);
-------------------------------------------------------------------------------------------------------------------------------------
-- Enter CROSSTAB

-- Before:
SELECT
    Country, Year, COUNT(*) AS Awards
FROM Summer_Medals
WHERE
    Country IN ('CHN','RUS','USA')
    AND Year IN (2008, 2012)
    AND Medal = 'Gold'
GROUP BY Country, Year
ORDER BY Country ASC, Year ASC;

-- After:
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB($$
    SELECT
        Country, Year, COUNT(*) :: INTEGER AS Awards
    FROM Summer_Medals
    WHERE
        Country IN ('CHN','RUS','USA')
        AND Year IN (2008, 2012)
        AND Medal = 'Gold'
    GROUP BY Country, Year
    ORDER BY Country ASC, Year ASC;
$$) AS ct (Country VARCHAR, "2008" INTERGER, "2012" INTEGER)

ORDER BY Country ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Source query
WITH Country_Awards AS (
    SELECT
        Country, Year, COUNT(*) AS Awards
    FROM Summer_Medals
    WHERE
        Country IN ('CHN','RUS','USA')
        AND Year IN (2004, 2008, 2012)
        AND Medal = 'Gold' AND Sport = 'Gymnastics'
    GROUP BY Country, Year
    ORDER BY Country ASC, Year ASC)
    
    SELECT
        Country, Year,
        RANK() OVER
            (PARTITION BY Year ORDER BY Awards DESC) :: INTEGER
            AS RANK
        FROM Country_Awards
        ORDER BY Country ASC, Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Pivot Query
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB($$
...
$$) AS ct (Country VARCHAR,
        "2004" INTEGER,
        "2008" INTEGER,
        "2012" INTEGER)
ORDER BY Country ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- A basic pivot:
-------------------------------------------------------------------------------------------------------------------------------------
-- Create the correct extention to enable CROSSTAB
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB($$
  SELECT
    Gender, Year, Country
  FROM Summer_Medals
  WHERE
    Year IN (2008, 2012)
    AND Medal = 'Gold'
    AND Event = 'Pole Vault'
  ORDER By Gender ASC, Year ASC;
-- Fill in the correct column names for the pivoted table
$$) AS ct (Gender VARCHAR,
           "2008" VARCHAR,
           "2012" VARCHAR)

ORDER BY Gender ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Pivoting with ranking:
-------------------------------------------------------------------------------------------------------------------------------------
-- Count the gold medals per country and year
SELECT
  Country,
  Year,
  COUNT(*) AS Awards
FROM Summer_Medals
WHERE
  Country IN ('FRA', 'GBR', 'GER')
  AND Year IN (2004, 2008, 2012)
  AND Medal = 'Gold'
GROUP BY Country, Year
ORDER BY Country ASC, Year ASC
-------------------------------------------------------------------------------------------------------------------------------------
WITH Country_Awards AS (
  SELECT
    Country,
    Year,
    COUNT(*) AS Awards
  FROM Summer_Medals
  WHERE
    Country IN ('FRA', 'GBR', 'GER')
    AND Year IN (2004, 2008, 2012)
    AND Medal = 'Gold'
  GROUP BY Country, Year)

SELECT
  -- Select Country and Year
  Country,
  Year,
  -- Rank by gold medals earned per year
  RANK() OVER
    (PARTITION BY Year ORDER BY Awards DESC) :: INTEGER AS rank
FROM Country_Awards
ORDER BY Country ASC, Year ASC;
-------------------------------------------------------------------------------------------------------------------------------------
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB($$
  WITH Country_Awards AS (
    SELECT
      Country,
      Year,
      COUNT(*) AS Awards
    FROM Summer_Medals
    WHERE
      Country IN ('FRA', 'GBR', 'GER')
      AND Year IN (2004, 2008, 2012)
      AND Medal = 'Gold'
    GROUP BY Country, Year)

  SELECT
    Country,
    Year,
    RANK() OVER
      (PARTITION BY Year
       ORDER BY Awards DESC) :: INTEGER AS rank
  FROM Country_Awards
  ORDER BY Country ASC, Year ASC;
-- Fill in the correct column names for the pivoted table
$$) AS ct (Country VARCHAR,
           "2004" INTEGER,
           "2008" INTEGER,
           "2012" INTEGER)

Order by Country ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- ROLLUP and CUBE:
-------------------------------------------------------------------------------------------------------------------------------------
-- The old way
SELECT
    Country, Medal, COUNT(*) AS Awards
FROM Summer_Medals
WHERE
    Year = 2008 AND COuntry IN ('CHN', 'RUS')
GROUP BY Country, Medal
ORDER BY Country ASC, Medal ASC

UNION ALL 

SELECT 
    COUNTRY, 'Total', COUNT(*) AS Awards
FROM Summer_Medals
WHERE
    Year = 2008 AND COuntry IN ('CHN', 'RUS')
GROUP BY Country, 2
ORDER BY Country ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Enter ROLLUP
SELECT
    Country, Metal, COUNT(*) AS Awards
FROM Summer_Medals
WHERE
    Year = 2008 AND Country IN ('CHN', 'RUS')
GROUP BY Country, ROLLUP(Medal)
ORDER BY COuntry ASC, Medal ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Enter CUBE
SELECT
    Country, Medal, COUNT(*) AS Awards
FROM Summer_Medals
WHERE
    Year = 2008 AND Country IN ('CHN', 'RUS')
GROUP BY CUBE(COuntry, Medal)
ORDER BY Country ASC, Medal ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Country-level subtotals:
-------------------------------------------------------------------------------------------------------------------------------------
-- Count the gold medals per country and gender
SELECT
  Country,
  gender,
  COUNT(*) AS Gold_Awards
FROM Summer_Medals
WHERE
  Year = 2004
  AND Medal = 'Gold'
  AND Country IN ('DEN', 'NOR', 'SWE')
-- Generate Country-level subtotals
GROUP BY country, ROLLUP(Gender)
ORDER BY Country ASC, Gender ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- All group-level subtotals:
-------------------------------------------------------------------------------------------------------------------------------------
-- Count the medals per country and medal type
SELECT
  Gender,
  Medal,
  COUNT(*) AS Awards
FROM Summer_Medals
WHERE
  Year = 2012
  AND Country = 'RUS'
-- Get all possible group-level subtotals
GROUP BY CUBE(Gender, Medal)
ORDER BY Gender ASC, Medal ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- A survey of useful functions:
-------------------------------------------------------------------------------------------------------------------------------------
-- Annihilating nulls
SELECT
    COALESCE(Country, 'Both countries') AS Country
    COALESCE(Medal, 'All medals') AS Medal,
    COUNT(*) AS Awards
FROM Summer_Medals
WHERE
    Year = 2008 AND Country IN('CHN', 'RUS')
GROUP BY RULLUP(Country, Medal)
ORDER BY COuntry ASC, Medal ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Query and result
-- Before:
WITH Country_Medals AS (
        Country, COUNT(*) AS medals
    FROM Summer_Medals
    WHERE Year = 2012
        AND Country IN ('CHN','RUS','USA')
        AND Medal = 'Gold'
        AND Sport = 'Gymnastics'
    GROUP BY Country),

    SELECT
        Country
        RANK() OVER (ORDER BY Medals DESC) AS Rank
    FROM Country_Medals
    ORDER BY Rank ASC;

-- After:
WITH Country_Medals AS (...)

    Country_ranks AS (...)

    SELECT STRING_AGG(Country, ', ')
    FROM Country_Medals;
-------------------------------------------------------------------------------------------------------------------------------------
-- Cleaning up results:
-------------------------------------------------------------------------------------------------------------------------------------
SELECT
  -- Replace the nulls in the columns with meaningful text
  COALESCE(Country, 'All countries') AS Country,
  COALESCE(Gender, 'All genders') AS Gender,
  COUNT(*) AS Awards
FROM Summer_Medals
WHERE
  Year = 2004
  AND Medal = 'Gold'
  AND Country IN ('DEN', 'NOR', 'SWE')
GROUP BY ROLLUP(Country, Gender)
ORDER BY Country ASC, Gender ASC;
-------------------------------------------------------------------------------------------------------------------------------------
-- Summarizing results:
-------------------------------------------------------------------------------------------------------------------------------------
WITH Country_Medals AS (
  SELECT
    Country,
    COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE Year = 2000
    AND Medal = 'Gold'
  GROUP BY Country)

  SELECT
    Country,
    -- Rank countries by the medals awarded
    RANK() OVER (ORDER BY Medals DESC) AS Rank
  FROM Country_Medals
  ORDER BY Rank ASC;
-------------------------------------------------------------------------------------------------------------------------------------
WITH Country_Medals AS (
  SELECT
    Country,
    COUNT(*) AS Medals
  FROM Summer_Medals
  WHERE Year = 2000
    AND Medal = 'Gold'
  GROUP BY Country),

  Country_Ranks AS (
  SELECT
    Country,
    RANK() OVER (ORDER BY Medals DESC) AS Rank
  FROM Country_Medals
  ORDER BY Rank ASC)

-- Compress the countries column
SELECT STRING_AGG(Country, ', ')
FROM Country_Ranks
-- Select only the top three ranks
WHERE Rank <= 3;
-------------------------------------------------------------------------------------------------------------------------------------