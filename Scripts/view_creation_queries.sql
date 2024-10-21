
--Create a View to hold Common apps present in both appStore and playStore tables 
CREATE VIEW common_apps AS
SELECT  DISTINCT(a.name), 
		SUM(CAST(a.review_count AS INTEGER) + p.review_count) AS total_review, 
		ROUND(AVG(a.rating + p.rating)/2,2) AS avg_rating, 
		a.primary_genre  AS genres,
		CASE WHEN a.price >= CAST(REPLACE(p.price,'$','') AS DECIMAL) THEN a.price
		ELSE CAST(REPLACE(p.price,'$','') AS DECIMAL) END AS high_price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
	ON a.name = p.name
GROUP By a.name, a.primary_genre, high_price

--Create a View to hold UNCommon apps present either in appStore or playStore tables 
CREATE VIEW uncommon_apps AS
--This CTE will return combine data from both the tables
WITH app_play_data_combine AS (
	SELECT distinct(name), CAST(review_count AS INTEGER) AS total_review, rating, primary_genre AS genres, price 
	FROM app_store_apps
	UNION 
	SELECT distinct(name), review_count, rating, genres, CAST(REPLACE(price,'$','') AS DECIMAL) AS price FROM 			play_store_apps
	)
--Following query is finding uncommon app name+genre data from both the tables
SELECT name, total_review, rating, genres, price
FROM app_play_data_combine 
WHERE name NOT IN (
	SELECT distinct(a.name)
	FROM app_store_apps as a
	INNER JOIN play_store_apps AS p ON a.name = p.name
	) 
ORDER BY name

--Union of all apps
SELECT * FROM common_apps
UNION ALL
SELECT * FROM uncommon_apps
ORDER BY total_review DESC



