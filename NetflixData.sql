---------------------------------- Netflix Originals Study --------------------------------------
SELECT * FROM PortfolioProject..NetflixOriginals

-- no need for this ReleaseData column anymore since I extracted just the release year in Excel before importing to SSMS
ALTER TABLE NetflixOriginals
DROP COLUMN ReleaseDate

--Figuring out which top genres have the most films released
SELECT DISTINCT(Genre), COUNT(Genre) as NumberOfMovies
FROM PortfolioProject..NetflixOriginals
GROUP BY Genre
ORDER BY 2 DESC

-- Grouping movie genres into highest count categories that are more broad, too many genres that are similar
-- Using a CTE first just to see how it would work before I make the changes
WITH genreCTE AS(
SELECT genre,
CASE WHEN Genre LIKE '%action%' THEN 'Action' 
WHEN Genre LIKE '%documentary%' THEN 'Documentary' 
WHEN Genre LIKE 'comedy%' THEN 'Comedy'
WHEN Genre LIKE 'romantic comedy' THEN 'Romantic Comedy'
WHEN Genre LIKE '%drama%' THEN 'Drama'
WHEN Genre LIKE '%science fiction%' THEN 'Science Fiction'
WHEN Genre LIKE '%thriller%' THEN 'Thriller'
WHEN Genre LIKE '%horror%' THEN 'Thriller'
WHEN Genre LIKE '%western%' THEN 'Western'
WHEN Genre LIKE '%anim%' THEN 'Animation'
WHEN Genre LIKE '%family%' THEN 'Family'
WHEN Genre LIKE '%christmas%' THEN 'Family'
ELSE 'Other'
END as GroupedGenre
FROM PortfolioProject..NetflixOriginals )
SELECT DISTINCT (GroupedGenre), COUNT(GroupedGenre) as NumberOfMovies
FROM genreCTE
GROUP BY GroupedGenre
ORDER BY 2 DESC

-- adding the new table and populating the data into it
ALTER TABLE NetflixOriginals
ADD GroupedGenre Nvarchar(255)
UPDATE PortfolioProject..NetflixOriginals
SET GroupedGenre = 
CASE 
WHEN Genre LIKE '%action%' THEN 'Action' 
WHEN Genre LIKE '%documentary%' THEN 'Documentary' 
WHEN Genre LIKE 'comedy%' THEN 'Comedy'
WHEN Genre LIKE 'romantic comedy' THEN 'Romantic Comedy'
WHEN Genre LIKE '%drama%' THEN 'Drama'
WHEN Genre LIKE '%science fiction%' THEN 'Science Fiction'
WHEN Genre LIKE '%thriller%' THEN 'Thriller'
WHEN Genre LIKE '%horror%' THEN 'Thriller'
WHEN Genre LIKE '%western%' THEN 'Western'
WHEN Genre LIKE '%anim%' THEN 'Animation'
WHEN Genre LIKE '%family%' THEN 'Family'
WHEN Genre LIKE '%christmas%' THEN 'Family'
ELSE 'Other'
END 

SELECT GroupedGenre, COUNT(GroupedGenre) as NumberOfMovies
FROM PortfolioProject..NetflixOriginals
WHERE ReleaseYear = 2021
GROUP BY GroupedGenre
ORDER BY 2 DESC

-- deleting 2021 movies because since the year hasn't ended yet, there isn't as much data to be consistent with the previous years
DELETE FROM PortfolioProject..NetflixOriginals
WHERE ReleaseYear = 2021

-- also deleting year 2014 since it was recorded at the end of the year and there's only 1 movie for that year
DELETE FROM PortfolioProject..NetflixOriginals
WHERE ReleaseYear = 2014

SELECT GroupedGenre, COUNT(GroupedGenre) as NumberOfMovies
FROM PortfolioProject..NetflixOriginals
GROUP BY GroupedGenre
ORDER BY 2 DESC

-- shows the average, highest and lowest ratings grouped by each genre category, beginning with the highest rating averages
SELECT GroupedGenre, AVG(Rating) as AvgRating, MIN(Rating) as LowestRating, MAX(Rating) as HighestRating 
FROM PortfolioProject..NetflixOriginals
GROUP BY GroupedGenre
ORDER BY 2 DESC

-- want to find the movie with the highest rating
SELECT TOP 1 MovieTitle, Rating from PortfolioProject..NetflixOriginals
ORDER BY Rating DESC

-- want to find 5 lowest movie ratings
SELECT TOP 5 MovieTitle, Genre, Rating from PortfolioProject..NetflixOriginals
ORDER BY Rating 


--------------- analyzing movie ratings data into 4 diff performance categories -------------------

-- First way using NTILE ordered by highest rating:
SELECT *, ntile(4) OVER (ORDER BY rating DESC) as Ranking
FROM PortfolioProject..NetflixOriginals

-- showing the rating categories by grouped genres ordered by highest rating:
SELECT *, ntile(4) OVER (PARTITION BY GroupedGenre ORDER BY rating DESC) as Ranking
FROM PortfolioProject..NetflixOriginals
-- Then we can set 1 = Great, 2 = Good, 3 = Average, 4 = Bad

-- OR to be more specific about rating categories, but slightly different results...

-- Bad
SELECT * FROM NetflixOriginals 
WHERE Rating <= 3
-- Average
SELECT * FROM NetflixOriginals 
WHERE Rating > 3 AND Rating <= 6
-- Good
SELECT * FROM NetflixOriginals 
WHERE Rating > 6 AND Rating <= 8
-- Great
SELECT * FROM NetflixOriginals 
WHERE Rating > 8 AND Rating <= 10

-- Creating CASE statement to watch it work successfully before I add a new table 
SELECT *,
CASE 
WHEN Rating <= 3 THEN 'Bad'
WHEN Rating > 3 AND Rating <= 6 THEN 'Average'
WHEN Rating > 6 AND Rating <= 8 THEN 'Good'
ELSE 'Great'
END as RatingCategory
FROM PortfolioProject..NetflixOriginals

-- adding table dimensions to database
ALTER TABLE NetflixOriginals
ADD RatingCategory Nvarchar(255)
UPDATE PortfolioProject..NetflixOriginals
SET RatingCategory = 
CASE 
WHEN Rating <= 3 THEN 'Bad'
WHEN Rating > 3 AND Rating <= 6 THEN 'Average'
WHEN Rating > 6 AND Rating <= 8 THEN 'Good'
ELSE 'Great'
END

------------ analyzing the RatingCategory to see how Netflix Originals did in terms of audience reviews ------------
SELECT RatingCategory, COUNT(RatingCategory) as RatingCount
FROM PortfolioProject..NetflixOriginals
GROUP BY RatingCategory
ORDER BY 2 DESC

------------------------- Questionnaire --------------------
-- find the total number of movies considered great in 2019
SELECT COUNT(MovieTitle) FROM PortfolioProject..NetflixOriginals WHERE RatingCategory = 'Great' AND ReleaseYear = 2019
-- answer was 2

-- find the total amount of movies considered great in 2015
SELECT COUNT(MovieTitle) FROM PortfolioProject..NetflixOriginals WHERE RatingCategory = 'Great' AND ReleaseYear = 2015
-- answer was 1....the volume of netflix original movies was small at the time though

-- What year had the highest amount of movies considered great?
SELECT ReleaseYear, COUNT(*) FROM PortfolioProject..NetflixOriginals as RatingCount WHERE RatingCategory = 'Great' 
GROUP BY ReleaseYear
ORDER BY 2 DESC
-- 2020 was the year with the highest rated Netflix original movies (7)

-- How many movies total have recevied 'bad' reviews?
SELECT COUNT(*) FROM PortfolioProject..NetflixOriginals WHERE RatingCategory = 'Bad'
-- Only 3 Netflix original movies recevied reviews less than 3 stars from 2015-2020
