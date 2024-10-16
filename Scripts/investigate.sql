select * from app_store_apps where name ILIKE '%fulnes%'
select distinct(primary_genre), COUNT(primary_genre) as cnt from app_store_apps group by primary_genre order by cnt
select * from play_store_apps where --content_rating = 'Unrated'
select distinct(content_rating) from play_store_apps 
"Unrated","Everyone 10+","Teen","Everyone","Adults only 18+","Mature 17+"