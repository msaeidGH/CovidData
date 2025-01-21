--- Queries used for Tableu

-- 1 - Global Numbers
SELECT 
    --date, 
    SUM(new_cases) as total_cases, 
    SUM(CAST(new_deaths AS INT)) as total_dates, 
    SUM(CAST(new_deaths AS INT)) / SUM(New_Cases) * 100 AS DeathPercentage
FROM 
    PortfolioProject..CovidDeaths
-- WHERE location LIKE '%states%'
WHERE 
    continent IS NOT NULL
--GROUP BY 
--    date
ORDER BY 
    1, 2;

-- 2
select location,MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
and location not in ('world','European Union','International')
group by location
order by TotalDeathCount desc


-- 3 - Looking for highest infection rate country in terms of population
select location,population,MAX(cast(total_cases as int)) as highestInfectionCount,round(MAX(total_cases/population)*100,2) as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
group by location,population
order by PercentagePopulationInfected desc

-- 4 -

-- Looking for highest infection rate country in terms of population
select location,population,date,MAX(cast(total_cases as int)) as highestInfectionCount,round(MAX(total_cases/population)*100,2) as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
group by location,population,date
order by PercentagePopulationInfected desc

----------------------------------------------------------------
----------------------------------------------------------------