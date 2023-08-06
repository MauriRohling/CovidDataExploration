---------- DEATH DATA ---------- 

---------- BY COUNTRIES ----------

-- Country with highest infection rate over population
SELECT location AS Location, (MAX(total_cases) * 1.0 /MAX(population))*100 AS InfectionPercentage, MAX(total_cases) AS TotalCases,  MAX(population) AS Population
FROM CovidDeaths cd
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY InfectionPercentage DESC

-- Country with highest death rate over infections
SELECT location AS Location, (MAX(total_deaths) * 1.0 /MAX(total_cases))*100 AS DeathPercentage, MAX(total_cases) AS TotalCases, MAX(total_deaths) AS TotalDeaths
FROM CovidDeaths cd
WHERE continent IS NOT NULL
GROUP BY location
HAVING MAX(total_cases) > 10 -- ignore irrelevant numbers
ORDER BY 2 DESC

-- Country with highest death rate over total population
SELECT location, (MAX(total_deaths) * 1.0 /MAX(population))*100 AS DeathPercentage, MAX(total_cases) AS TotalCases, population
FROM CovidDeaths cd
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY 2 DESC

-- Country with most deaths
SELECT location, MAX(total_deaths) TotalDeaths
FROM CovidDeaths cd
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY 2 DESC



---------- BY CONTINENTS ----------

-- Continent with highest infection rate over population
SELECT location AS Location, (MAX(total_cases) * 1.0 /MAX(population))*100 AS InfectionPercentage, MAX(total_cases) AS TotalCases,  MAX(population) AS Population
FROM CovidDeaths cd
WHERE continent IS NULL
GROUP BY location
ORDER BY InfectionPercentage DESC

-- Continent with highest death rate over infections
SELECT location AS Location, (MAX(total_deaths) * 1.0 /MAX(total_cases))*100 AS DeathPercentage, MAX(total_cases) AS TotalCases, MAX(total_deaths) AS TotalDeaths
FROM CovidDeaths cd
WHERE continent IS NULL
GROUP BY location
HAVING MAX(total_cases) > 10 -- ignore irrelevant numbers
ORDER BY 2 DESC

-- Continent with highest death rate over total population
SELECT location, (MAX(total_deaths) * 1.0 /MAX(population))*100 AS DeathPercentage, MAX(total_deaths) AS TotalDeaths, population
FROM CovidDeaths cd
WHERE continent IS NULL
GROUP BY location, population
ORDER BY 2 DESC

-- Continent with most deaths
SELECT location, MAX(total_deaths) TotalDeaths
FROM CovidDeaths cd
WHERE continent IS NULL
GROUP BY location
ORDER BY 2 DESC

---------- VACCINATION DATA ---------- 

WITH PopVsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS
(
	SELECT dth.continent, dth.location, dth.date, dth.population, dth.new_vaccinations
	, SUM(vac.new_vaccinations) OVER (PARTITION BY dth.location ORDER BY dth.location, dth.date) AS RollingPeopleVaccinated
	FROM CovidDeaths dth
	JOIN CovidVaccinations vac
		ON dth.location = vac.location
		AND dth.date = vac.date
	WHERE dth.continent IS NOT NULL AND dth.location = 'Brazil'
)
SELECT *, (RollingPeopleVaccinated * 1.0/population) * 100 RollingPeopleVaccinatedPercentage
FROM PopVsVac

