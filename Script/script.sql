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



