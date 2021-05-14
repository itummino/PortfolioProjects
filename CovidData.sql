--SELECT * FROM PortfolioProject..CovidDeaths
--ORDER BY 3,4

--SELECT * FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

--SELECT location, date, total_cases, new_cases, total_deaths, population 
--FROM PortfolioProject..CovidDeaths ORDER BY location, date


-- Total cases VS total deaths in United States
-- Shows the likelihood of death if you are diagnosed with Covid in U.S.
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths 
WHERE location = 'United States' 
ORDER BY 1,2

-- Total cases vs population in U.S.
-- Shows what percentage of the population contracted Covid in U.S.
SELECT location, date, population, total_cases, (total_cases/population)*100 as CovidPercentage
FROM PortfolioProject..CovidDeaths 
WHERE location = 'United States'
ORDER BY 1,2

-- Countries with highest Covid infection rate compared to the population
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as CovidPercentage
FROM PortfolioProject..CovidDeaths 
GROUP BY location, population
ORDER BY CovidPercentage DESC

-- Countries with highest Covid death count compared to the population
SELECT location, population, MAX(CAST(total_deaths as INT)) as TotalDeaths, MAX((total_deaths/population))*100 as CovidDeathPercentage
FROM PortfolioProject..CovidDeaths 
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY TotalDeaths DESC

SELECT location, MAX(CAST(total_deaths as INT)) as TotalDeaths
FROM PortfolioProject..CovidDeaths 
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeaths DESC

-- Let's break things down by continent
-- Showing continents with highest death count
SELECT continent, MAX(CAST(total_deaths as INT)) as TotalDeaths
FROM PortfolioProject..CovidDeaths 
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeaths DESC

-- Global numbers by date
SELECT date, SUM(new_cases) as total_cases, 
SUM(CAST(new_deaths as INT)) as total_deaths, 
SUM(CAST(new_deaths as INT))/SUM(new_cases)*100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY date
ORDER BY 1, 2

-- Shows the total death percentage globally, along with total cases and total deaths
SELECT SUM(new_cases) as total_cases, 
SUM(CAST(new_deaths as INT)) as total_deaths, 
SUM(CAST(new_deaths as INT))/SUM(new_cases)*100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 1, 2

-- Joining covid Vaccinations data with covid Deaths data
SELECT * FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location and dea.date = vac.date


-- Total population vs vaccinations, use CTE
WITH PopVsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent IS NOT NULL
) 
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopVsVac
--As of 5/5/21, out of 585,0343 people in Singapore, Asia, a total of 55,206 people were vaccinated (0.94% of the population) 
--As of 5/5/21, roughly 14% of the population is vaccinated in Albania, compared to 1.13% total vaccinated 3/28/21



-- Total population vs vaccinations, use TEMP TABLE
DROP TABLE IF EXISTS #PercentPopVaccinated --use this always in case you need to edit and re-run so it won't throw errors
CREATE TABLE #PercentPopVaccinated (
continent nvarchar(255),
location nvarchar(255),
date DATETIME,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
INSERT INTO #PercentPopVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent IS NOT NULL

SELECT *, (RollingPeopleVaccinated/population)*100
FROM #PercentPopVaccinated



-- Creating Views to store data for later 
CREATE VIEW GlobalVaccinationRate as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent IS NOT NULL

CREATE VIEW USCovidDeathRate as 
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeaths 
WHERE location = 'United States'

CREATE VIEW USPopInfectionRate as 
SELECT location, date, population, total_cases, (total_cases/population)*100 as CovidPercentage
FROM PortfolioProject..CovidDeaths 
WHERE location = 'United States'

CREATE VIEW GlobalHighestInfectionRate as 
SELECT location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))*100 as CovidPercentage
FROM PortfolioProject..CovidDeaths 
WHERE continent IS NOT NULL
GROUP BY location, population

