------Gathering/importing/exploring data

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

-- Breaking things down by continent
-- Showing continents with highest death count
SELECT continent, MAX(CAST(total_deaths as INT)) as TotalDeaths
FROM PortfolioProject..CovidDeaths 
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeaths DESC

-- Global case numbers by date
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
SELECT *, (RollingPeopleVaccinated/population)*100 as 'GlobalVaccinationRate'
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
CREATE VIEW GlobalVaccinations as 
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

CREATE VIEW GlobalCaseNumber as
SELECT date, SUM(new_cases) as total_cases, 
SUM(CAST(new_deaths as INT)) as total_deaths, 
SUM(CAST(new_deaths as INT))/SUM(new_cases)*100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY date

DROP VIEW IF EXISTS dbo.GlobalCaseNumber


-- Global Visualizations (covid deaths):

-- Shows the total death percentage globally, along with total cases and total deaths (no locations)
SELECT SUM(new_cases) as total_cases, 
SUM(CAST(new_deaths as INT)) as total_deaths, 
SUM(CAST(new_deaths as INT))/SUM(new_cases)*100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 1, 2

-- Shows the total death count due to Covid in each continent
SELECT location, SUM(cast(new_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is null and location not in ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount desc

-- Shows the percentage of the population infected with covid as well as the highest amount infected by country globally,
-- ordered by the highest percentage of the population infected (no dates)
SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected desc

-- Shows the percentage of the population infected with covid as well as the highest amount infected by country globally,
-- ordered by the highest percentage of the population infected and the date
SELECT Location, Population, date, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
GROUP BY Location, Population, date
ORDER BY PercentPopulationInfected desc


-- US Visualizations (covid deaths):

-- Shows the total death percentage in the US, along with total cases and total deaths
SELECT SUM(new_cases) as total_cases, 
SUM(CAST(new_deaths as INT)) as total_deaths, 
SUM(CAST(new_deaths as INT))/SUM(new_cases)*100 as DeathPercentage 
FROM PortfolioProject..CovidDeaths
WHERE location = 'United States' 
ORDER BY 1, 2

-- Shows what percentage of the population contracted Covid in US over time
SELECT location, date, population, total_cases, (total_cases/population)*100 as CovidPercentage
FROM PortfolioProject..CovidDeaths 
WHERE location = 'United States'
----------------------------------------------------------

-- New Vaccinations Data:

SELECT * FROM PortfolioProject..Vaccinations

-- Shows total vaccinations adminstered according to income bracket
SELECT entity as 'Income Bracket', MAX(total_vaccinations) as TotalVaccinations
FROM PortfolioProject..Vaccinations
WHERE entity LIKE '%income'
GROUP BY entity
ORDER BY MAX(total_vaccinations) DESC

--Adding dates to see trends over time 
SELECT entity as 'Income Bracket', MAX(total_vaccinations) as TotalVaccinations, day as 'Date'
FROM PortfolioProject..Vaccinations
WHERE entity LIKE '%income'
GROUP BY entity, day
ORDER BY MAX(total_vaccinations) DESC


--- Shows total number of vaccinations adminstered in each country as of 5/18/21, and divided by the country's population
-- gives us the global vaccination rate (excludes continents, income, etc)
SELECT entity as 'Location', MAX(total_vaccinations) as TotalVaccinations, dea.population, (MAX(total_vaccinations)/dea.population)*100 as 'GlobalVaccinationRate'
FROM PortfolioProject..Vaccinations vac
JOIN PortfolioProject..CovidDeaths dea 
ON dea.location = vac.entity 
WHERE entity != 'World' AND entity NOT LIKE '%income' AND entity NOT LIKE '%America' AND entity NOT LIKE 'Europe%' AND entity != 'Asia' AND entity != 'Australia' AND entity != 'Africa'
GROUP BY entity, population
ORDER BY MAX(total_vaccinations) DESC

-- All new vaccinations administered in the US over time
SELECT dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations as INT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
ON dea.location = vac.location and dea.date = vac.date
WHERE dea.location = 'United States'

