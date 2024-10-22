-- CREATE VIEW common_apps AS
Top 10 for genres?

For every 0.5 point in rating an app recieves, its lifespan is increased by 1 year, e.g., 0 rating = 1 year, 1.0 rating = 3 years, 4.0 rating = 9 years

SELECT distinct(a.name), SUM(CAST(a.review_count AS INTEGER) + p.review_count) AS total_review, ROUND(AVG(a.rating + p.rating)/2,2) AS avg_rating,
	CASE WHEN a.price >= CAST(REPLACE(p.price,'$','') AS DECIMAL) THEN a.price
	ELSE CAST(REPLACE(p.price,'$','') AS DECIMAL) END AS high_price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name = p.name 
GROUP BY a.name, a.price, p.price
ORDER BY total_review DESC
LIMIT 10;

SELECT DISTINCT(a.name), 
	SUM(CAST(a.review_count AS INTEGER) + p.review_count) AS total_review, 
	ROUND(AVG(a.rating + p.rating)/2,2) AS avg_rating,
	(1 + 2 * ROUND(AVG(a.rating + p.rating)/2,2)) AS year_lifespan,
	ROUND(CAST(size_bytes AS NUMERIC) / 1024, 2) AS gigabytes,
	CASE WHEN CAST(size_bytes AS NUMERIC) > 1000000 THEN ROUND(CAST(size_bytes AS NUMERIC) / 1000000,2) 
	ELSE NULL END AS terabytes,
	CASE WHEN a.price >= CAST(REPLACE(p.price,'$','') AS DECIMAL) THEN a.price
	ELSE CAST(REPLACE(p.price,'$','') AS DECIMAL) END AS high_price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name = p.name 
GROUP BY a.name, a.price, p.price, size_bytes
ORDER BY total_review DESC
LIMIT 10;

SELECT DISTINCT(a.name), 
    SUM(CAST(a.review_count AS INTEGER) + p.review_count) AS total_review, 
    ROUND(AVG(a.rating + p.rating) / 2, 2) AS avg_rating,
    (1 + 2 * ROUND(AVG(a.rating + p.rating) / 2, 2)) AS year_lifespan,
	size_bytes,
    ROUND(CAST(size_bytes AS NUMERIC) / 1024, 2) AS megabytes, 
    ROUND(CAST(size_bytes AS NUMERIC) / (1024 * 1024), 2) AS gigabytes,
    CASE 
        WHEN a.price >= CAST(REPLACE(p.price, '$', '') AS DECIMAL) THEN a.price
        ELSE CAST(REPLACE(p.price, '$', '') AS DECIMAL) 
    END AS high_price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name = p.name 
GROUP BY a.name, a.price, p.price, size_bytes
ORDER BY gigabytes DESC
LIMIT 10;


SELECT *, ROUND(CAST(size_bytes AS NUMERIC) / 1024, 2) AS gigabytes
FROM app_store_apps
WHERE name LIKE 'Instagram'

SELECT *, ROUND(CAST(size_bytes AS NUMERIC) / 1024, 2) AS gigabytes
FROM app_store_apps
WHERE name LIKE 'Instagram'

SELECT name,
CASE 
	WHEN size <> 'Varies with device' 
	AND size LIKE '%M' 
	AND size NOT LIKE '%k' 
	THEN ROUND(CAST(REPLACE(size, 'M', '') AS NUMERIC) / 1024, 2)
    ELSE NULL
END AS gigabytes
FROM play_store_apps
WHERE size <> 'Varies with device'
  AND size LIKE '%M'
  AND size NOT LIKE '%k'
ORDER BY gigabytes DESC;

SELECT name,
CASE 
    WHEN size <> 'Varies with device' 
         AND size LIKE '%M' 
         AND size NOT LIKE '%k' 
    THEN ROUND(CAST(REPLACE(size, 'M', '') AS NUMERIC) / 1024, 2) 
    WHEN size <> 'Varies with device' 
         AND size LIKE '%bytes' 
    THEN ROUND(CAST(REPLACE(size, 'bytes', '') AS NUMERIC) / 1073741824, 2) 
    ELSE NULL
END AS gigabytes
FROM play_store_apps
WHERE size <> 'Varies with device'
  AND (size LIKE '%M' OR size LIKE '%bytes') 
ORDER BY gigabytes DESC;


SELECT *
FROM play_store_apps
WHERE name LIKE 'Trello'

SELECT *
FROM app_store_apps
WHERE name LIKE 'Trello'

SELECT ROUND(CAST(size_bytes AS NUMERIC) / 1024, 2) AS megabytes, 
    ROUND(CAST(size_bytes AS NUMERIC) / (1024 * 1024), 2) AS gigabytes
FROM app_store_apps
WHERE name LIKE 'Trello'

SELECT *
FROM play_store_apps
WHERE name LIKE 'Cytus'

SELECT *
FROM app_store_apps
WHERE name LIKE 'Cytus'

SELECT ROUND(CAST(size_bytes AS NUMERIC) / 1024, 2) AS megabytes, 
    ROUND(CAST(size_bytes AS NUMERIC) / (1024 * 1024), 2) AS gigabytes
FROM app_store_apps
WHERE name LIKE 'Cytus'

SELECT size
FROM play_store_apps
WHERE size <> 'Varies with device'
ORDER BY size DESC;

CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE result
END;

--Create a View to hold UNCommon app name+genre combination dataset from appStore and playStore tables
-- CREATE VIEW uncommon_apps AS
--This CTE will return combine data from both the tables
WITH app_play_data_combine AS (
SELECT NAME, price, primary_genre AS genres FROM app_store_apps
UNION
SELECT NAME, CAST(REPLACE(price,'$','') AS DECIMAL) price , genres FROM play_store_apps
)
--Following query is finding uncommon app name+genre data from both the tables
SELECT NAME, price, genres
FROM app_play_data_combine
WHERE NAME NOT IN (
	SELECT a.name
	FROM app_store_apps as a
	INNER JOIN play_store_apps AS p ON a.name = p.name --AND a.primary_genre = p.genres
) ORDER BY genres, NAME

SELECT *
FROM app_store_apps

SELECT *
FROM play_store_apps

SELECT name, price, CAST(review_count AS INTEGER), rating, primary_genre
FROM app_store_apps
WHERE primary_genre='Games' AND price = 0
ORDER BY review_count DESC

SELECT DISTINCT genres
FROM play_store_apps

SELECT DISTINCT category
FROM play_store_apps

SELECT name, 
	rating, 
	review_count, 
	CAST(REPLACE(REPLACE(install_count, ',', ''), '+', '') AS INTEGER) AS install_count, 
	genres
FROM (
	SELECT DISTINCT ON (name) name, 
	rating, 
	review_count, 
	install_count, 
	genres
FROM play_store_apps
WHERE type = 'Free' AND category = 'GAME' AND rating >= 4.5
ORDER BY name, review_count DESC
) 
AS distinct_play_apps
ORDER BY review_count DESC;

transform size_bytes into gigabytes, then case when for over 1000+ GB into TB

SELECT ROUND(CAST(size_bytes AS NUMERIC) / 1024, 2) AS gigabytes,
CASE
	WHEN gigabytes > 1000 THEN (gigabytes / 1024) AS terabytes
	ELSE 'Null' END
FROM app_store_apps;