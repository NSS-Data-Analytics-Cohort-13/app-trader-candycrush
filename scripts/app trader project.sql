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

SELECT name, currency, price, review_count, rating, content_rating
FROM app_store_apps
WHERE rating >= 4.5 
ORDER BY rating DESC, review_count DESC, price ASC

SELECT *
FROM play_store_apps

SELECT name, category, rating, review_count, install_count, type, price, content_rating
FROM play_store_apps 
WHERE rating IS NOT NULL AND rating >= 5.0 AND install_count = '1,000+' 
ORDER BY install_count DESC, review_count DESC;

ORDER BY price ASC
WHERE type <> 'Free'

SELECT price
FROM play_store_apps
ORDER BY price DESC

SELECT name, price
FROM app_store_apps
WHERE price <> 0
GROUP BY name, price
ORDER BY price DESC

SELECT a.name, p.name, a.rating AS astore_rating, p.rating AS pstore_rating, ROUND((a.rating + p.rating) / 2.0,2) AS average_rating
FROM app_store_apps AS a
JOIN play_store_apps AS p
USING (name)
WHERE a.rating >= 4.5 AND p.rating >= 4.5
ORDER BY a.rating DESC, p.rating DESC
LIMIT 10;

SELECT name, 
	rating,
	ROUND(AVG(CASE WHEN rating >= 4.5 THEN rating END),2) AS astore_rated
FROM app_store_apps
GROUP BY name, rating
ORDER BY rating DESC