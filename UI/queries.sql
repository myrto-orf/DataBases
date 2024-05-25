-- 3.1.1 
SELECT cookID, AVG(value) AS average_score
FROM score
GROUP BY cookID

-- 3.1.2
-- SELECT EthnicCuisine.CuisineID
-- can also be used
SELECT EthnicCuisine.CuisineName, AVG(score.value) AS average_score
FROM score
JOIN event ON score.EventID = event.EventID
JOIN recipe ON event.RecipeID = recipe.RecipeID
JOIN EthnicCuisine ON recipe.CuisineID = EthnicCuisine.CuisineID
GROUP BY EthnicCuisine.CuisineID

-- 3.2.1
-- change where EthnicCuisine.CuisineID = 13
-- to get results for a different cuisine
SELECT cook.cookID
FROM cook
JOIN Expertise ON Expertise.CookID = cook.CookID
JOIN EthnicCuisine ON EthnicCuisine.CuisineID = Expertise.CuisineID
where EthnicCuisine.CuisineID = 13

-- 3.2.2
-- change WHERE Season.Year = 2001
-- to get results for a different season - year
SELECT event.ContestantID
FROM event
JOIN Episode ON event.EpisodeID = Episode.EpisodeID
JOIN Season ON Episode.SeasonID = Season.SeasonID
WHERE Season.Year = 2001

-- 3.3
SELECT cook.CookID, COUNT(*) AS appearance_count
FROM cook
JOIN event ON cook.CookID = event.ContestantID
WHERE (DATEDIFF(CURDATE(), cook.BirthDate) / 365.25) < 30
GROUP BY cook.CookID 

-- 3.4
SELECT cook.CookID
FROM cook
WHERE CookID NOT IN
(SELECT distinct(judge.CookID) FROM judge)

-- 3.5
-- usually returns empty set because
-- the cooks are too many and the appearance_count-threshold too high
SELECT 
    judge.CookID, 
    season.SeasonID,
    COUNT(*) AS appearance_count
FROM 
    judge
JOIN 
    episode ON judge.EpisodeID = episode.EpisodeID
JOIN 
    season ON episode.SeasonID = season.SeasonID
GROUP BY
    judge.CookID, 
    season.SeasonID
HAVING
    appearance_count > 3


-- 3.6 do once food label data is added

-- 3.7
-- Step 1: Find the maximum number of appearances
-- Step 2: Find the cooks with at least 5 fewer appearances

SELECT cook.CookID, COUNT(*) AS appearance_count
FROM cook
JOIN event ON cook.CookID = event.ContestantID
GROUP BY cook.CookID
HAVING COUNT(*) <= (
    SELECT MAX(appearance_count) - 5
    FROM (
        SELECT cook.CookID, COUNT(*) AS appearance_count
        FROM cook
        JOIN event ON cook.CookID = event.ContestantID
        GROUP BY cook.CookID
    ) AS subquery
)

-- 3.8 do once equipment data is added

-- 3.9

SELECT season.year, 
AVG(NutritionalTable.CarbsPerPortion) AS average_carbs
FROM event
JOIN episode ON event.EpisodeID = episode.EpisodeID
JOIN NutritionalTable ON event.RecipeID = NutritionalTable.RecipeID
JOIN season ON episode.SeasonID = Season.SeasonID
GROUP BY season.year

-- 3.10

WITH CuisineAppearances AS (
    SELECT 
        EthnicCuisine.CuisineID,
        COUNT(*) AS cuisine_appearance,
        season.Year
    FROM 
        event
    JOIN 
        recipe ON event.RecipeID = recipe.RecipeID
    JOIN 
        EthnicCuisine ON recipe.CuisineID = EthnicCuisine.CuisineID
    JOIN 
        episode ON event.EpisodeID = episode.EpisodeID
    JOIN 
        season ON episode.SeasonID = season.SeasonID
    GROUP BY 
        EthnicCuisine.CuisineID,
        season.Year
)
SELECT 
    c1.CuisineID,
    c1.cuisine_appearance AS appearance_year_1,
    c2.cuisine_appearance AS appearance_year_2,
    c1.Year AS year_1,
    c2.Year AS year_2
FROM 
    CuisineAppearances c1
JOIN 
    CuisineAppearances c2 ON c1.CuisineID = c2.CuisineID
                        AND c1.cuisine_appearance = c2.cuisine_appearance
                        AND c1.Year + 1 = c2.Year
                        AND c1.cuisine_appearance > 2

-- 3.11

SELECT score.CookID AS judgeID, event.ContestantID, SUM(score.Value) AS total_score
FROM score
JOIN event ON score.EventID = event.EventID
GROUP BY score.CookID,
    event.ContestantID
ORDER BY total_score DESC
LIMIT 5

-- 3.12

SELECT event.EpisodeID, AVG(recipe.DifficultyLevel) as avg_difficulty
FROM event
JOIN recipe ON event.RecipeID = recipe.RecipeID
GROUP BY event.EpisodeID
ORDER BY avg_difficulty DESC
LIMIT 1

-- 3.13

SELECT 
    combined.EpisodeID, 
    SUM(FIELD(cook.TrainingLevel, 'C cook', 'B cook', 'A cook', 'sous chef', 'chef')) AS summed_training_level
FROM 
    (
        SELECT event.EpisodeID, event.ContestantID AS CookID
        FROM event
        UNION ALL
        SELECT judge.EpisodeID, judge.CookID
        FROM judge
    ) AS combined
JOIN 
    cook ON combined.CookID = cook.CookID
GROUP BY 
    combined.EpisodeID
ORDER BY summed_training_level ASC
LIMIT 1

-- 3.14
-- do once the,atic unit data are added

-- 3.15

SELECT fg.GroupID
FROM FoodGroup fg
LEFT JOIN (
    SELECT DISTINCT FoodGroup.GroupID
    FROM event
    JOIN recipe ON event.RecipeID = recipe.RecipeID
    JOIN quantity ON recipe.RecipeID = quantity.RecipeID
    JOIN ingredient ON quantity.IngredientID = ingredient.IngredientID
    JOIN FoodGroup ON ingredient.GroupID = FoodGroup.GroupID
) present ON fg.GroupID = present.GroupID
WHERE present.GroupID IS NULL;


