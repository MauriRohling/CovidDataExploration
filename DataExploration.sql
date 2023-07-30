-- Highest death rate on total population
SELECT location AS 'Location', MAX(total_cases) AS 'Total Cases', population AS 'Population', (MAX(total_cases) * 1.0 /MAX(population))*100 AS 'Death %'
FROM CovidDeaths cd
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 2 DESC

-- Highest death rate on infections
SELECT location AS Location, (MAX(total_deaths) * 1.0 /MAX(total_cases))*100 AS 'Death %', MAX(total_cases) AS 'Total Cases', MAX(total_deaths) AS 'Total Deaths'
FROM CovidDeaths cd
WHERE continent IS NOT NULL
GROUP BY location
HAVING MAX(total_cases) > 10 -- ignore irrelevant numbers
ORDER BY 2 DESC

-- Highest infection rate on population
SELECT location AS Location, (MAX(total_cases) * 1.0 /MAX(population))*100 AS 'Infection %', MAX(total_cases) AS 'Total Cases',  MAX(population) AS Population
FROM CovidDeaths cd
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 'Infection %' DESC