/*3. Deliverables
a. Develop some general recommendations as to the price range, genre, content rating, or anything else for apps that the company should target.

b. Develop a Top 10 List of the apps that App Trader should buy.

c. Submit a report based on your findings. All analysis work must be done using PostgreSQL, however you may export query results to create charts in Excel for your report.*/

--Create a View to hold Common apps present in both appStore and playStore tables 
CREATE VIEW common_apps AS
SELECT  DISTINCT(a.name), 
SUM(CAST(a.review_count AS INTEGER) + p.review_count) AS total_review, 
ROUND(AVG(a.rating + p.rating)/2,2) AS avg_rating, a.primary_genre  AS genres,
CASE WHEN a.price >= CAST(REPLACE(p.price,'$','') AS DECIMAL) THEN a.price
	ELSE CAST(REPLACE(p.price,'$','') AS DECIMAL) END AS high_price,
ROUND((((ROUND(ROUND(ROUND(AVG(a.rating + p.rating)/2,2)*2,0)/2,1))*2)+1),0) AS lifespan
FROM app_store_apps AS a
INNER JOIN play_store_apps AS p
ON a.name = p.name
GROUP By a.name, a.primary_genre, high_price

--Query to cretae top 10 recommended apps based on overall_profit
SELECT name, genres, high_price, total_review, 
/* Profit is calculated based on assumptions 10000 profit per month times lifespan */
(120000*(lifespan))-
(case when high_price > 0.99 then high_price*10000 else 10000 end + (12000*lifespan))  AS overall_profit, avg_rating
FROM common_apps
ORDER BY overall_profit DESC, total_review DESC limit 10

--Query to cretae top 10 recommended apps based on review count as popularity parameter
SELECT name, genres, high_price, total_review, 
/* Profit is calculated based on assumptions 10000 profit per month times lifespan */
(120000*(lifespan))-
(case when high_price > 0.99 then high_price*10000 else 10000 end + (12000*lifespan))  AS overall_profit, avg_rating
FROM common_apps
ORDER BY total_review DESC limit 10

--Query to find out top app names based on highest review count per genre
SELECT genres, NAME, max_review
FROM( SELECT genres, 
       NAME, 
       MAX(total_review) AS max_review, 
       ROW_NUMBER() OVER(PARTITION BY genres ORDER BY MAX(total_review) DESC) AS rn
FROM common_apps
GROUP BY genres, NAME
 ) AS a
WHERE rn = 1

--Query to cretae top 10 recommended apps based on size of an app in gigabytes
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