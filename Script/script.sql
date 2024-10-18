select *
from app_store_apps

select *
from play_store_apps

SELECT a.name, p.name, a.rating AS astore_rating, p.rating AS pstore_rating, ROUND((a.rating + p.rating) / 2.0,2) AS average_rating
FROM app_store_apps AS a
FULL JOIN play_store_apps AS p
USING(name)
WHERE a.rating >= 4.5 AND p.rating >= 4.5
ORDER BY a.rating DESC, p.rating DESC


SELECt apple_store.Name,  
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

SELECT
    apple_store.Name,
    CASE
        WHEN apple_store.price <= 1.00 THEN 10000
        ELSE apple_store.price * 10000
    END AS PurchasePrice
FROM app_store_apps AS apple_store
--WHERE apple_store.name = 'Toca Life: City'
UNION
SELECT
    play_store.Name,
    CASE
        WHEN CAST(TRIM(REPLACE(play_store.price,'$','')) AS DECIMAL) <= 1.00 THEN 10000
        ELSE CAST(TRIM(REPLACE(play_store.price,'$','')) AS DECIMAL) * 10000
    END AS PurchasePrice
FROM play_store_apps AS play_store
--WHERE play_store.name = 'Toca Life: City'
ORDER BY PurchasePrice DESC

SELECT distinct(a.name), SUM(CAST(a.review_count AS INTEGER) + p.review_count) AS total_review, AVG(a.rating + p.rating) AS avg_rating,
	CASE WHEN a.price >= CAST(REPLACE(p.price,'$','') AS DECIMAL) THEN a.price
	ELSE CAST(REPLACE(p.price,'$','') AS DECIMAL) END AS high_price
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name = p.name
GROUP BY a.name, a.price, p.price
ORDER BY total_review DESC

LIMIT 10;



