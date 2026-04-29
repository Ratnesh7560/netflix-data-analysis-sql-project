USE netflix;
-- Retrieve all columns and rows from the netflix_titles table --
SELECT *
FROM netflix_titles;
-- Retrieve only the title, type, and release_year columns --
SELECT title,type,release_year 
FROM netflix_titles;
-- Find all records where type is 'Movie' --
SELECT *
FROM netflix_titles
WHERE type = 'Movie';
-- Find all records where type is 'TV Show'. --
SELECT *
FROM netflix_titles
WHERE type = 'TV Show';
-- List all titles released in the year 2020. --
SELECT title
FROM netflix_titles
WHERE release_year = 2020;
-- List all titles in alphabetical order. --
SELECT title
FROM netflix_titles
ORDER BY (title);
-- List all titles ordered by release_year from newest to oldest. --
SELECT title, release_year
FROM netflix_titles
ORDER BY release_year DESC;
-- Show the first 10 records from the table. --
SELECT *
FROM netflix_titles
LIMIT 10;
-- Count the total number of titles in the dataset. --
SELECT COUNT(*) AS total_movies
FROM netflix_titles;
-- Count how many titles are Movies. --
SELECT COUNT(*) AS movies_title
FROM netflix_titles
WHERE type = 'movie';
-- List all unique content ratings (rating column) available. --
SELECT DISTINCT rating
FROM netflix_titles;
-- List all unique countries where content is produced.--
SELECT DISTINCT country
FROM netflix_titles
WHERE country IS NOT NULL
AND country !='';
-- Find all records where the director column is NULL. --
SELECT *
FROM netflix_titles
WHERE director ='';
-- Find all records where the country column is NOT NULL. --
SELECT *
FROM netflix_titles
WHERE country !='';
-- Find all titles that contain the word 'Love'. --
SELECT title
FROM netflix_titles
WHERE title LIKE '%Love%';
-- Find all titles that start with the letter 'A'. --
SELECT title
FROM netflix_titles
WHERE title LIKE 'A%';
-- Find all Movies released after the year 2015.--
SELECT title, release_year
FROM netflix_titles
WHERE type = 'Movie'
AND release_year > 2015;
-- Find all titles that are either from 'United States' or 'India' --
SELECT title, country
FROM netflix_titles
WHERE country = 'United states'
OR country = 'India';
-- List titles with rating 'PG', 'PG-13', or 'G'. --
SELECT title, rating
FROM netflix_titles
WHERE rating IN ('PG','PG-13','G');
-- Find all titles released between 2015 and 2020 (inclusive). --
SELECT title, release_year
FROM netflix_titles
WHERE release_year
BETWEEN 2015 AND 2020;
-- Count the number of unique directors in the dataset. --
SELECT COUNT(DISTINCT director) AS unique_directors
FROM netflix_titles;
-- Find the earliest and latest release years in the dataset. --
SELECT MIN(release_year) AS earliest, MAX(release_year) AS latest
FROM netflix_titles;
-- Select show_id and title, aliasing them as ID and Name. --
SELECT  show_id AS ID, title AS Nme
FROM netflix_titles;
-- Find all titles NOT rated 'TV-MA'. --
SELECT title, rating
FROM netflix_titles
WHERE rating NOT IN ('TV-MA'); 
-- Find the 5 most recently added titles (by date_added).--
SELECT title, date_added
FROM netflix_titles
ORDER BY date_added DESC
LIMIT 5;
-------------------------- Intermediate --------------------
USE netflix;
SELECT * FROM netflix_titles;

-- Count the number of Movies vs TV Shows. --
SELECT type, COUNT(*)
FROM netflix_titles
GROUP BY type;
-- Count how many titles were added each year (by release_year). --
SELECT release_year, COUNT(*) AS Total
FROM netflix_titles
GROUP BY release_year
ORDER BY release_year;
-- Find the top 10 countries by number of titles produced. --
SELECT country, COUNT(*) AS total
FROM netflix_titles
WHERE country IS NOT NULL
AND TRIM(country) != ''
GROUP BY country
ORDER BY total DESC
LIMIT 10;
-- Find all countries that have produced more than 100 titles.--
SELECT country, COUNT(*) AS total
FROM netflix_titles
GROUP BY country
HAVING COUNT(*) > 100;
-- List ratings that appear more than 500 times. --
SELECT rating, COUNT(*) AS total
FROM netflix_titles
GROUP BY rating
HAVING COUNT(*) > 500;
-- Find the top 5 directors with the most titles on Netflix.--
SELECT director, COUNT(*) AS TOP_5
FROM netflix_titles
WHERE director !=''
GROUP BY director
ORDER BY TOP_5 DESC
LIMIT 5;
SELECT UPPER (title) AS upper
FROM netflix_titles;
-- Find the length of each title and show titles longer than 50 characters. --
SELECT title, LENGTH(title) AS title_length
FROM netflix_titles
WHERE LENGTH(title) > 50;
-- Extract the first word of each title. --
SELECT title, SUBSTRING_INDEX (title,' ',1) AS first_word
FROM netflix_titles;
-- Extract the year portion from the date_added column. --
SELECT title, YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) AS year_added
FROM netflix_titles
WHERE date_added IS NOT NULL;
-- Find all titles added in the month of January. --
SELECT title, date_added
FROM netflix_titles
WHERE TRIM(date_added) LIKE '%September%';
-- Add a column 'era' that labels titles before 2010 as 'Classic', 2010-2019 as 'Modern', and 2020+ as 'Recent'. --
SELECT title, release_year,
CASE
WHEN release_year < 2010 THEN 'Classic'
WHEN release_year BETWEEN 2010 AND 2019 THEN 'Modern'
WHEN release_year >= 2020 THEN 'Recent'
ELSE 'Unknown'
END AS Era
FROM netflix_titles;
-- Label each title as 'Short' if duration is under 60 min, otherwise 'Long' (for Movies only). --
SELECT title, duration,
CASE
WHEN CAST(REGEXP_SUBSTR(duration,'[0-9]+') AS UNSIGNED) < 60 THEN 'Short' 
ELSE 'Long' END AS length_cat
FROM netflix_titles
WHERE type = 'Movie';
-- Find all titles with a release_year greater than the average release_year --
SELECT title, release_year
FROM netflix_titles
WHERE release_year > (SELECT AVG(release_year) FROM netflix_titles);
-- Find the director who has the most titles and show all their titles. --
SELECT director, title
FROM netflix_titles
WHERE director = (SELECT director 
FROM netflix_titles 
WHERE director != ''
GROUP BY director
ORDER BY COUNT(*) DESC
LIMIT 1);
USE netflix;
-- Find all titles from countries that have produced more than 50 titles.--
SELECT title,country
FROM netflix_titles
WHERE country IN (SELECT country
FROM netflix_titles
GROUP BY country
HAVING COUNT(*) >10);
-- Find the average release year for Movies vs TV Shows.--
SELECT type, AVG(release_year) AS avg_release_year
FROM netflix_titles
GROUP BY type;
-- Find the most common rating for Movies. --
SELECT rating, COUNT(*) AS total
FROM netflix_titles
WHERE type = 'Movie'
GROUP BY rating
ORDER BY total DESC
LIMIT 1;
-- Combine title and release_year into one string like 'Title (2020)'. --
SELECT concat(title, ' ( ',release_year,' ) ') AS combine
FROM netflix_titles;
-- Find all titles and remove any leading/trailing spaces from the title column. --
SELECT TRIM(title) AS clean_title 
FROM netflix_titles;
-- Find Indian Movies rated 'TV-14' released after 2010. --
SELECT title AS after_2010
FROM netflix_titles
WHERE type = 'Movie'
AND country LIKE '%India%'
AND rating = 'TV-14'
AND release_year >=2010
LIMIT 10;
-- Calculate what percentage of all titles are Movies--
SELECT ROUND(100.0 * SUM(CASE WHEN type='Movie' THEN 1 ELSE 0 END) / COUNT(*), 2) AS movie_pct 
FROM netflix_titles;
-- Count titles grouped by both type and rating. --
SELECT type, rating, COUNT(*) AS total
FROM netflix_titles
GROUP BY type,rating
ORDER BY type, total DESC;
-- Find all titles that do NOT contain a colon (:) in the title. --
SELECT title 
FROM netflix_titles 
WHERE title NOT LIKE '%:%';
-- Count how many records have a NULL value in the director column. --
SELECT COUNT(*) AS missing_directors 
FROM netflix_titles 
WHERE director IS NULL;





 


