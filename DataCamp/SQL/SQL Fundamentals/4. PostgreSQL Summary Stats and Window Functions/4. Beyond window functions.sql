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

-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------------------------------
