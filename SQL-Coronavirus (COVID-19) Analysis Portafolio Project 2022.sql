/* Coronavirus (COVID-19) Analysis Portafolio Project 2022

Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


select *
from PortafolioProject..CovidVaccinations
where continent is not null
order by 3,4

select location, date, new_cases, total_deaths, population
from PortafolioProject..CovidDeaths
order by 1,2

select * 
from PortafolioProject..CovidDeaths

 -- 1. Looking at Total Cases VS Total Deaths
 -- Shows the liklyhood of dying by conutry

select location, date,total_cases_per_million, total_deaths,(total_deaths/total_cases_per_million)*1.0 as DeathPercentaje
from PortafolioProject..CovidDeaths
WHERE location like'%state%'
ORDER BY 1,2	

-- 2. Looking at the Total Cases VS The Population
-- Shows what Population % that has contracted COVID 

select location, date, population, total_cases_per_million, (population/total_cases_per_million)*100 as PercentPopulationInfected
from PortafolioProject..CovidDeaths
WHERE location like'%state%'
ORDER BY total_cases_per_million


-- 3. Looking Countries with highest Infeccion rates compared to population 

select location,population, max(total_cases_per_million) as highestInfectionCount, max((population/total_cases_per_million))*100 as PercentPopulationInfected
from PortafolioProject..CovidDeaths
group by location,population
--WHERE location like'%state%'
order by PercentPopulationInfected desc

-- 4. Showing the countries with the highest death count

select location,max(CAST(total_deaths AS bigint)) as totalDeathsCount
from PortafolioProject..CovidDeaths
where continent is not null
group by location,population
--WHERE location like'%state%'
order by totalDeathsCount DESC


-- 5. Continents with the highest Death Count per Continent 
--Break down by Continents

select continent,max(CAST(total_deaths AS bigint)) as totalDeathsCount
from PortafolioProject..CovidDeaths
--WHERE location like'%state%'
where continent is not null
group by Continent 
order by totalDeathsCount DESC

-- 6. Global Numbers 

select --date,
sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,sum(cast(new_deaths as int))/sum(new_cases)* 100 as DeathPercentage 
from PortafolioProject..CovidDeaths
WHERE Continent  is not null
--group by date
ORDER BY 1,2	

-- 7. Total population VS Vaccinations 

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortafolioProject..CovidDeaths dea 
join PortafolioProject..CovidVaccinations vac
	on dea.location= vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3

-- 8. Use of CTE

WITH PopvsVac (continent,location, date, population,new_vaccinations,RollingPeopleVaccinated)
as
(select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from PortafolioProject..CovidDeaths dea 
join PortafolioProject..CovidVaccinations vac
	on dea.location= vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
Select *,(RollingPeopleVaccinated/population)*100 as PercentPopulationVaccinated
from PopvsVac

-- 9. TEMP Table 

Drop Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vacinations numeric,
RollingPeopleVaccinated numeric
)
Insert Into #PercentPopulationVaccinated
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from PortafolioProject..CovidDeaths dea 
join PortafolioProject..CovidVaccinations vac
	on dea.location= vac.location
	and dea.date=vac.date
--where dea.continent is not null
--order by 2,3

Select *,(RollingPeopleVaccinated/population)*100 as PercentPopulationVaccinated
from  #PercentPopulationVaccinated


-- 10. Creating View to store data for later visualizations 

CREATE VIEW PercentPopulationVaccinated AS
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
sum(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
from PortafolioProject..CovidDeaths dea 
join PortafolioProject..CovidVaccinations vac
	on dea.location= vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3

Select *
from PercentPopulationVaccinated