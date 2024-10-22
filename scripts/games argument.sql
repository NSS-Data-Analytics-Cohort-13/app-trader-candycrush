select *
FROM play_store_apps

select distinct content_rating
from play_store_apps

select *
FROM app_store_apps

select distinct content_rating
from app_store_apps


SELECT DISTINCT genres
FROM play_store_apps

SELECT DISTINCT category
FROM play_store_apps

SELECT name, price, CAST(review_count AS INTEGER), rating, primary_genre
FROM app_store_apps
WHERE primary_genre='Games' AND price = 0
ORDER BY review_count DESC

SELECT DISTINCT
	p.name, 
	a.rating,
	p.rating, 
	p.review_count, 
	CAST(REPLACE(REPLACE(install_count, ',', ''), '+', '') AS INTEGER) AS install_count, 
	p.genres,
	a.primary_genre,
	p.category
FROM (
	SELECT DISTINCT ON (name) name, 
	rating, 
	review_count, 
	install_count, 
	genres,
	category
FROM play_store_apps 
WHERE type = 'Free' AND category = 'GAME' AND rating >= 4.5
ORDER BY name
) AS p
INNER JOIN app_store_apps AS a
ON p.name = a.name
ORDER BY install_count DESC, p.review_count DESC;

SELECT DISTINCT
	p.name, 
	ROUND(AVG(a.rating + p.rating)/2,2) AS avg_rating,
	(1 + 2 * ROUND(AVG(a.rating + p.rating)/2,2)) AS year_lifespan,
	p.review_count, 
	CAST(REPLACE(REPLACE(install_count, ',', ''), '+', '') AS INTEGER) AS install_count, 
	p.genres,
	a.primary_genre,
	p.category,
	-- CASE
	-- 	WHEN a.content_rating LIKE '4+' AND a.content_rating LIKE '9+' AND p.content_rating ILIKE 'everyone' THEN 'Everyone <10'
	-- 	WHEN a.content_rating LIKE '12+' AND p.content_rating ILIKE 'teen' AND p.content_rating ILIKE 'everyone 10+' THEN 'Teen <12'
	-- 	WHEN a.content_rating LIKE '17+' AND p.content_rating ILIKE 'mature 17+' AND p.content_rating ILIKE 'Adults only 18+' THEN 'Adults 18+'
	-- 	ELSE 'Unrated' END AS content_rating
	a.content_rating,
	p.content_rating
FROM (
	SELECT DISTINCT ON (name) name, 
	rating, 
	review_count, 
	install_count, 
	genres,
	category,
	content_rating
FROM play_store_apps 
WHERE type = 'Free' AND category = 'GAME' AND rating >= 4.5
ORDER BY name
) AS p
INNER JOIN app_store_apps AS a
ON p.name = a.name
GROUP BY p.name, p.review_count, p.genres, a.primary_genre, p.category, p.install_count, a.content_rating, p.content_rating
ORDER BY install_count DESC, p.review_count DESC
LIMIT 10;

CASE
    WHEN condition1 THEN result1
    WHEN condition2 THEN result2
    WHEN conditionN THEN resultN
    ELSE result
END;

SELECT DISTINCT
p.name,
ROUND(AVG(a.rating + p.rating)/2,2) AS avg_rating,
(1 + 2 * ROUND(AVG(a.rating + p.rating)/2,2)) AS year_lifespan,
p.review_count,
CAST(REPLACE(REPLACE(install_count, ',', ''), '+', '') AS INTEGER) AS install_count,
p.genres,
a.primary_genre,
p.category,
-- CASE
-- WHEN a.content_rating LIKE '4+' AND a.content_rating LIKE '9+' AND p.content_rating ILIKE 'everyone' THEN 'Everyone <10'
-- WHEN a.content_rating LIKE '12+' AND p.content_rating ILIKE 'teen' AND p.content_rating ILIKE 'everyone 10+' THEN 'Teen <12'
-- WHEN a.content_rating LIKE '17+' AND p.content_rating ILIKE 'mature 17+' AND p.content_rating ILIKE 'Adults only 18+' THEN 'Adults 18+'
-- ELSE 'Unrated' END AS content_rating 
a.content_rating, p.content_rating
FROM (
SELECT DISTINCT ON (name) name,
rating,
review_count,
install_count,
genres,
category,
content_rating
FROM play_store_apps
WHERE type = 'Free' AND category = 'GAME' AND rating >= 4.5
ORDER BY name
) AS p
INNER JOIN app_store_apps AS a
ON p.name = a.name
GROUP BY p.name, p.review_count, p.genres, a.primary_genre, p.category, p.install_count,
a.content_rating, p.content_rating
ORDER BY install_count DESC, p.review_count DESC
LIMIT 10