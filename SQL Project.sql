
DROP TABLE IF EXISTS NETFLIX; 

CREATE TABLE NETFLIX
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)

);

select * from netflix;
select count(*) from netflix;

-- 14 Business Problems & Solutions

-- 1. Count the number of Movie vs TV Show
select type, count(*) as Type_count from netflix
group by type;


-- 2. Find the most common rating for movies and TV shows
SELECT type, rating FROM
(
SELECT type, rating, count(*), RANK() OVER (PARTITION BY TYPE 
ORDER BY count(*) DESC) AS ranking FROM netflix
GROUP BY 1,2
)
WHERE ranking = 1

--3. List all movies released in a specific year (e.g., 2020)
SELECT * 
FROM netflix
WHERE release_year = 2020;

--4. Find the top 5 countries with the most content on Netflix
SELECT * 
FROM
(
    SELECT 
        TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) AS country_list,
        COUNT(*) AS total_content
    FROM netflix
    GROUP BY 1
) 
WHERE country_list IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;

--5. Find content added in the last 5 years
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

--6. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

--7. List all TV shows with more than 5 seasons
SELECT *
FROM netflix
WHERE type = 'TV Show'
AND SPLIT_PART(duration, ' ', 1)::INT > 5;
  
--8. Count the number of content items in each genre
SELECT 
    TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))) AS genre,
    COUNT(*) AS total_content
FROM netflix
GROUP BY 1;

--9. List all movies that are documentaries
SELECT * 
FROM netflix
WHERE listed_in LIKE '%Documentaries';

--10. Find all content without a director
SELECT * 
FROM netflix
WHERE director IS NULL;

--11. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT * 
FROM netflix
WHERE casts LIKE '%Salman Khan%'
AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
  
--12. Find the top 10 actors who have appeared in the highest number of movies produced in India.
SELECT 
    TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) AS actor,
    COUNT(*)
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

--13. Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
WITH new_netflix_table AS
(
SELECT *,  
CASE WHEN description ILIKE '%kill%'
OR description ILIKE '%violence%'
THEN 'Bad'
ELSE 'Good'
END CONTENT_CATEGORY 
from netflix
)
SELECT CONTENT_CATEGORY, COUNT(*)
FROM new_netflix_table
GROUP BY 1;

--14. Identify the Longest Movie
SELECT 
    *
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;

--15. Find the Indian directors list whose movies are available on netflix
SELECT 
	DISTINCT(TRIM(UNNEST(STRING_TO_ARRAY(director, ',')))) AS director_list
FROM netflix 
WHERE director is NOT NULL
AND country ILIKE '%India%'


