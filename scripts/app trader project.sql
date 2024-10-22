-- Purchasing apps for 10,000x price, if app is on both stores purchase price is based off highest price across both stores. Apps earn $5,000 per per month, per store, regarldess of cost. 
-- If the app is on both stores, it'll make $10K per month. App Traders spends $1,000 per month marketing a single app. 
-- If App Trader owns rights to the app in both stores, marketing costs for a single app are $1K per month for placement on both stores.
-- For every 0.5 point in rating an app recieves, its lifespan is increased by 1 year, e.g., 0 rating = 1 year, 1.0 rating = 3 years, 4.0 rating = 9 years. 
-- App store ratings are calculated by taking the average of the scores from both stores and rounding to the nearest 0.5. 
-- App Trader prefers to work with apps that are available in both stores. 

-- TASK: 
-- 1) Develop recommendations for price range, genre, content rating, or anything else App Trader should target. 
-- 2) Develop a top 10 list of the apps App Trader should buy.
-- 3) Submit a report based on your findings. All analysis should happen in postgres, however, you can export results to create charts in Excel.


SELECT *
FROM app_store_apps
WHERE name LIKE 'Trello'

SELECT *
FROM play_store_apps
WHERE name LIKE 'Trello'

WITH PurchasePrice AS (
	SELECT apple_store.Name,
    CASE WHEN apple_store.price <= 1.00 THEN 10000
        ELSE apple_store.price * 10000 END AS PurchasePrice
FROM app_store_apps AS apple_store
UNION
	SELECT play_store.Name,
    CASE WHEN CAST(TRIM(REPLACE(play_store.price,'$','')) AS DECIMAL) <= 1.00 THEN 10000
        ELSE CAST(TRIM(REPLACE(play_store.price,'$','')) AS DECIMAL) * 10000 END AS PurchasePrice
FROM play_store_apps AS play_store
ORDER BY PurchasePrice DESC)
SELECT
    a.name,
    CAST(a.price AS MONEY) AS app_store_price, 
    a.rating, 
    a.review_count AS app_store_review_count, 
    CAST(p.price AS MONEY) AS play_store_price, 
    p.rating, 
    p.review_count AS play_store_review_count,
	P.install_count
FROM app_store_apps AS a
LEFT JOIN play_store_apps AS p 
USING(name)
WHERE a.rating >= 4.0 AND p.rating >= 4.0 and p.install_count LIKE '500,000,000+'
ORDER BY app_store_review_count DESC, play_store_review_count DESC

WITH common_apps AS (
SELECT name
FROM app_store_apps
UNION
SELECT name 
FROM play_store_apps
)
SELECT
    a.name,
    CAST(a.price AS MONEY) AS app_store_price, 
    a.rating, 
    a.review_count AS app_store_review_count, 
    CAST(p.price AS MONEY) AS play_store_price, 
    p.rating, 
    p.review_count AS play_store_review_count,
	p.install_count
FROM app_store_apps AS a
JOIN (
    SELECT DISTINCT name, price, rating, review_count, install_count
    FROM play_store_apps
    WHERE rating >= 4.0
) AS p	
USING(name)
WHERE a.rating >= 4.0 and p.install_count LIKE '500,000,000+'
ORDER BY app_store_review_count DESC, play_store_review_count DESC

SELECT name
FROM app_store_apps
WHERE rating IS NOT NULL
INTERSECT
SELECT name
FROM play_store_apps
WHERE rating IS NOT NULL AND rating = 4.0;

SELECT name, CAST(price AS TEXT), rating, CAST(review_count AS INTEGER)
FROM app_store_apps
WHERE rating IS NOT NULL
UNION
SELECT name, price, rating, CAST(review_count AS INTEGER)
FROM play_store_apps
WHERE rating IS NOT NULL AND rating = 4.0
ORDER BY price ASC, rating DESC, review_count DESC;

SELECT name, price, rating, review_count
FROM (
    SELECT name, CAST(price AS TEXT) AS price, rating, CAST(review_count AS INTEGER) AS review_count
    FROM app_store_apps
    WHERE rating IS NOT NULL    
    UNION
    SELECT name, CAST(price AS TEXT) AS price, rating, CAST(review_count AS INTEGER) AS review_count
    FROM play_store_apps
    WHERE rating IS NOT NULL AND rating = 4.0
) AS combined_data
ORDER BY price ASC, rating DESC, review_count DESC
LIMIT 10;

SELECT DISTINCT a.name, a.rating, p.rating, ROUND((a.rating + p.rating) / 2.0, 2) AS avg_rating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING(name)
WHERE a.rating >= 4.75 AND p.rating >= 4.75
ORDER BY a.rating DESC, p.rating DESC
LIMIT 10;

SELECT a.name, p.name, ROUND((a.rating + p.rating) / 2.0,2) AS average_rating
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
USING(name)
WHERE a.rating >= 4.5 AND p.rating >= 4.5
ORDER BY a.rating DESC, p.rating DESC
LIMIT 10;

SELECT name, 
	rating,
	AVG(CASE WHEN rating >= 4.5 THEN rating END) AS astore_rated
FROM app_store_apps
GROUP BY name, rating
ORDER BY rating DESC

SELECT
    apple_store.Name,
    CASE
        WHEN apple_store.price <= 1.00 THEN 10000
        ELSE apple_store.price * 10000
    END AS PurchasePrice,
    round(((apple_store.rating + play_store.rating) / 2.0),2) AS AverageRating
FROM app_store_apps AS apple_store
	INNER JOIN  play_store_apps AS play_store
		ON apple_store.Name = play_store.Name
ORDER BY AverageRating DESC
LIMIT 10;

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

