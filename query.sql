-- Display all creators
SELECT * FROM Creators;

-- Find creators with more than 100,000 views
SELECT Creator_Name, Views_COUNT
FROM Creators
WHERE Views_COUNT > 100000;

-- Join creators with their brands
SELECT c.Creator_Name, b.Brand_Name
FROM Creators c
JOIN Brands b
ON c.Brand_ID = b.Brand_ID;

SELECT * FROM Creators;

-- remove duplicate
SELECT DISTINCT Game_ID
FROM Esports;

-- Top 5 creators by views
SELECT *
FROM Creators
ORDER BY Views_count DESC
LIMIT 5;

--avg
SELECT AVG(Salary)
FROM Backend;


---grouping game id
SELECT Game_ID,
COUNT(*) AS Players
FROM Lineup
GROUP BY Game_ID;

--no of player required for game
SELECT Game_ID,
COUNT(*) AS Players
FROM Lineup
GROUP BY Game_ID
HAVING COUNT(*) > 4;


--total creator in brand 
SELECT b.Brand_Name,
       COUNT(c.Creator_ID) AS Total_Creators
FROM Brands b
JOIN Creators c
ON b.Brand_ID = c.Brand_ID
GROUP BY b.Brand_Name
ORDER BY Total_Creators DESC;


--highest views creator in brand
SELECT b.Brand_Name,
       MAX(c.Views_Count) AS Highest_Views
FROM Brands b
JOIN Creators c
ON b.Brand_ID = c.Brand_ID
GROUP BY b.Brand_Name;



-- Rank creators based on total views
SELECT
    Creator_Name,
    Views_Count,
    RANK() OVER (ORDER BY Views_Count DESC) AS Creator_Rank
FROM Creators;



-- Find creators whose views are above the average
SELECT
    Creator_Name,
    Views_Count
FROM Creators
WHERE Views_Count >
(
    SELECT AVG(Views_Count)
    FROM Creators
);


-- Find the brand with the maximum creators
SELECT
    b.Brand_Name,
    COUNT(c.Creator_ID) AS Total_Creators
FROM Brands b
JOIN Creators c
ON b.Brand_ID = c.Brand_ID
GROUP BY b.Brand_Name
ORDER BY Total_Creators DESC
LIMIT 1;

-- Calculate total salary by employee position
SELECT
    Position,
    SUM(Salary) AS Total_Salary
FROM Backend
GROUP BY Position
ORDER BY Total_Salary DESC;


-- Count players for every game
SELECT
    e.Game_name,
    COUNT(l.Player_ID) AS Total_Players
FROM Lineup l
join esports e
on e.game_id=l.game_id
GROUP BY Game_name;


-- Find creators who are not assigned to any brand
SELECT
    Creator_Name
FROM Creators
WHERE Brand_ID IS NULL;

-- Categorize creators based on views
SELECT
    Creator_Name,
    Views_Count,
    CASE
        WHEN Views_Count >= 500000 THEN 'Super Popular'
        WHEN Views_Count >= 100000 THEN 'Popular'
        ELSE 'Growing'
    END AS Status
FROM Creators;


-- Find creators with above-average views using CTE
WITH AvgViews AS
(
    SELECT AVG(Views_Count) AS Avg_View
    FROM Creators
)

SELECT
    Creator_Name,
    Views_Count
FROM Creators, AvgViews
WHERE Views_Count > Avg_View;



-- Calculate cumulative views
SELECT
    Creator_Name,
    Views_Count,
    SUM(Views_Count) OVER
    (
        ORDER BY Views_Count
    ) AS Running_Total
FROM Creators;


-- Create a view for popular creators
CREATE VIEW Popular_Creators AS
SELECT
    Creator_ID,
    Creator_Name,
    Views_Count
FROM Creators
WHERE Views_Count > 100000;

-- Display all popular creators
SELECT *
FROM Popular_Creators;


-- Rank creators within each brand
SELECT
    Creator_Name,
    Brand_ID,
    Views_Count,
    RANK() OVER
    (
        PARTITION BY Brand_ID
        ORDER BY Views_Count DESC
    ) AS Brand_Rank
FROM Creators;


-- Display the top 3 creators from every brand based on views

SELECT *
FROM
(
    SELECT
        Creator_Name,
        Brand_ID,
        Views_Count,
        ROW_NUMBER() OVER
        (
            PARTITION BY Brand_ID
            ORDER BY Views_Count DESC
        ) AS Rank_No
    FROM Creators
) t
WHERE Rank_No <= 3;


-- MIN VIEWS
SELECT Creator_Name, Views_count
FROM Creators
WHERE Views_count = (
    SELECT MIN(Views_count)
    FROM Creators
);

--between  50k  and 15000
SELECT Creator_Name, Views_count
FROM Creators
WHERE Views_count BETWEEN 50000 AND 150000;

--in
SELECT Creator_Name, Brand_ID
FROM Creators
WHERE Brand_ID IN (501, 503, 505);

--Brand ID 501 aur 503 ke alawa saare
SELECT Creator_Name, Brand_ID
FROM Creators
WHERE Brand_ID NOT IN (501, 503);

--name start with s
SELECT Creator_Name
FROM Creators
WHERE Creator_Name LIKE 'S%';

--name whicch   include plays
SELECT Creator_Name, Channel_Handle
FROM Creators
WHERE Channel_Handle LIKE '%play%';

-- last character 5
SELECT Creator_Name, Insta_ID
FROM Creators
WHERE Insta_id LIKE '%5';
select * from creators

--null value first
SELECT backend,
       COALESCE(Salary, 0) AS Salary
FROM backend;


--rank creator on the basis of views
SELECT Creator_Name,
       Views_count,
       DENSE_RANK() OVER (ORDER BY Views_count DESC) AS Ranking
FROM Creators;

--compare views with previous creator views
SELECT Creator_Name,
       Views_count,
       LAG(Views_count) OVER (ORDER BY Views_count DESC) AS Previous_Views
FROM Creators;

--views next to creator

SELECT Creator_Name,
       Views_count,
       LEAD(Views_count) OVER (ORDER BY Views_count DESC) AS Next_Views
FROM Creators;


-- divide creator into 4 group according to views.
SELECT Creator_Name,
       Views_count,
       NTILE(4) OVER (ORDER BY Views_count DESC) AS View_Group
FROM Creators;

--union
SELECT Creator_Name AS Name
FROM Creators

UNION

SELECT backend_name AS Name
FROM Backend;

--union all
SELECT Creator_Name AS Name
FROM Creators

UNION ALL

SELECT backend_Name AS Name
FROM Backend;

-- update 
UPDATE Creators
SET Views_count = 65000
WHERE Creator_Name = 'Sarika'
  AND Views_count = 48500;

--delete
DELETE FROM Brands
WHERE Creator_ID = 8;

--alter
ALTER TABLE Creators
ADD City VARCHAR(50);

--CREATOR NAME INDEX  
CREATE INDEX idx_creator_name
ON Creators (Creator_Name);

----Find the creator with the minimum views for each brand.
SELECT Brand_ID,
       MIN(Views_COUNT) AS Min_Views
FROM Creators
GROUP BY Brand_ID;

--Top 2 ranked creators per Brand 
SELECT Creator_Name,
       Brand_ID,
       Views_count
FROM (
    SELECT Creator_Name,
           Brand_ID,
           Views_COUNT,
           DENSE_RANK() OVER (
               PARTITION BY Brand_ID
               ORDER BY Views_COUNT DESC
           ) AS Rank
    FROM Creators
) t
WHERE Rank <= 2;

--Display the creators whose views are higher than the previous creator s views. 
SELECT Creator_Name,
       Views_COUNT,
       Previous_Views
FROM (
    SELECT Creator_Name,
           Views_COUNT,
           LAG(Views_COUNT) OVER (ORDER BY Creator_ID) AS Previous_Views
    FROM Creators
) t
WHERE Views_COUNT > Previous_Views;

--Divide creators into four quartiles based on their views
SELECT Creator_Name,
       Views_COUNT,
       NTILE(4) OVER (ORDER BY Views_COUNT DESC) AS Quartile
FROM Creators;

-- replace null value with salary
SELECT backend_Name,
       COALESCE(Salary, 20000) AS Salary
FROM Backend;


--Create a report that includes the Creator Name, Brand Name, Views, Dense Rank, 
--Previous Views, and Next Views for each creator.
SELECT
    c.Creator_Name,
    b.Brand_Name,
    c.Views_count,
    DENSE_RANK() OVER (ORDER BY c.Views_count DESC) AS Dense_Rank,
    LAG(c.Views_count) OVER (ORDER BY c.Views_count DESC) AS Previous_Views,
    LEAD(c.Views_count) OVER (ORDER BY c.Views_count DESC) AS Next_Views
FROM Creators c
JOIN Brands b
ON c.Brand_ID = b.Brand_ID;

--






