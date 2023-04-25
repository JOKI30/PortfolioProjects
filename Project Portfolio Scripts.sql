SELECT * 
FROM [Portfolio Project]..CovidDeaths
ORDER BY  3,4

--SELECT * 
--FROM [Portfolio Project]..CovidVaccinations
--ORDER BY  3,4



SELECT location, date,total_cases, new_cases, total_deaths, population
FROM [Portfolio Project]..CovidDeaths
ORDER BY 1,2


SELECT location, date, total_cases,total_deaths, CAST(total_cases AS FLOAT)/CAST(total_deaths AS FLOAT) AS DeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2


SELECT location, date, total_cases, Population, CAST(total_cases AS FLOAT)/CAST(total_deaths AS FLOAT) AS DeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2

SELECT location, date, total_cases, Population, (total_cases/population)*100 AS DeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2


SELECT location, date, total_cases, Population, (total_cases/population)*100 AS DeathPercentage
FROM [Portfolio Project]..CovidDeaths
WHERE location LIKE '%states%'
ORDER BY 1,2


Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths
--Where location like '%states%'
order by 1,2

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
FROM [Portfolio Project]..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected DESC


SELECT Location, MAX(CAST(Total_deaths as int)) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
WHERE Location LIKE '%Canada%'
GROUP BY Location
ORDER BY TotalDeathCount DESC

 


SELECT Location, MAX(CAST(Total_deaths as int)) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
--WHERE location like '%Canada%'
WHERE continent is NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount DESC


SELECT continent, MAX(CAST(Total_deaths as int)) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
--WHERE location like '%Canada%'
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC



 






Select  date, total_cases,total_deaths, CAST(total_cases AS FLOAT)/CAST(total_deaths AS FLOAT) as DeathPercentage
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
WHERE continent is not null 
GROUP BY date
order by 1,2



Select date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From [Portfolio Project]..CovidDeaths
--Where location like '%states%'
where continent is not null 
Group By date
order by 1,2

--SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 AS DeathPercentage
--FROM [Portfolio Project]..CovidDeaths
----Where location like '%states%'
--WHERE continent is NOT NULL
--GROUP BY date
--ORDER BY 1,2


Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
FROM [Portfolio Project]..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


SELECT * 
FROM [Portfolio Project]..CovidVaccinations

SELECT * 
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date =vac.date


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
order by 2,3

WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
AS 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM [Portfolio Project]..CovidDeaths dea
JOIN [Portfolio Project]..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null
ORDER by 2,3


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


--CTE

WITH PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
AS 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac

--TEMP TABLE 

DROP TABLE IF exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated


--GLOBAL NUMBERS 

SELECT SUM(new_cases) as total_cases, SUM(CAST(new_deaths as int)) as total_deaths, SUM(CAST
(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
FROM [Portfolio Project]..CovidDeaths
--Where location like '%states%'
WHERE continent is not null
GROUP BY DATE 
ORDER BY 1,2

SELECT continent, MAX(CAST(Total_deaths as int)) AS TotalDeathCount
FROM [Portfolio Project]..CovidDeaths
--WHERE location like '%Canada%'
WHERE continent is NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

--Creating View to store data for later visualizations


CREATE VIEW PercentPopulationVaccinated AS 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio Project]..CovidDeaths dea
Join [Portfolio Project]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

SELECT * 
FROM PercentPopulationVaccinated

