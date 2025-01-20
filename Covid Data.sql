select * 
from PortfolioProject.. CovidDeaths
where continent is not null
order by 3,4



select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2


-- Looking at total cases vs total Deaths
select location,date,total_cases,total_deaths,round((total_deaths/total_cases)*100,2) as DeathPercentage
from PortfolioProject..CovidDeaths
order by 1,2;


-- Looking at the total cases vs population
-- Shows what percentage of population got covid
select location,date,population,total_cases,round((total_cases/population)*100,2) as PercentOfPopulationInfected
from PortfolioProject..CovidDeaths
--where location like '%states%'
order by 1,2

-- Looking for highest infection rate country in terms of population
select location,population,MAX(total_cases) as highestInfectionCount,round(MAX(total_cases/population)*100,2) as PercentagePopulationInfected
from PortfolioProject..CovidDeaths
group by location,population
order by PercentagePopulationInfected desc

-- Showing countries with highest death count per population
select location,MAX(total_deaths) as TotalDeathCount,round(MAX(total_deaths/population)*100,2) as PercentagePopulationDeath
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

-- Let's break things down by Continent
select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc


-- The right pattern
select location,MAX(total_deaths) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc

-- Showing the continents with highest death count per population
select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

-- Global Numbers
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


--------------------------------------------------------------
-- Let's look at the Vaccination data

select * 
from PortfolioProject.. CovidVaccinations
order by 3,4


select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations as newVacPerDay,
sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as RollingCountPeopleVaccinated
--,(RollingCountPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
order by 2,3



-- Use CTE
with PopvsVac (continent,Location, Date, Population, New_vaccinations,RollingCountPeopleVaccinated)
as
(
select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations as newVacPerDay,
sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as RollingCountPeopleVaccinated
--,(RollingCountPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
--order by 2,3
)
select *, (RollingCountPeopleVaccinated/Population) * 100 as PercentageVaccinated
from PopvsVac


--- TEMP TABLE
DROP Table if exists #percentPopulationVaccinated
create table #percentPopulationVaccinated
(
continent nvarchar(255),
Location nvarchar(255),
date datetime,
population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #percentPopulationVaccinated
select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations as newVacPerDay,
sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingCountPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
--order by 2,3

select *, (RollingPeopleVaccinated/Population) * 100 as PercentageVaccinated
from #percentPopulationVaccinated


----- Creating Views to Store Data for later visualations

Create View PercentPopulationVaccinated as
select dea.continent, dea.location,dea.date, dea.population,vac.new_vaccinations as newVacPerDay,
sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--,(RollingCountPeopleVaccinated/population)*100
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL
--order by 2,3

select * from PercentPopulationVaccinated