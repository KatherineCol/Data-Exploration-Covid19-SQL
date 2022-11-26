# COVID19-Data-Exploration.SQL 2022

Analysis for latest updates, on COVID19 globally. Data Source; retrive from https://ourworldindata.org/covid-deaths SQL Data Exploration Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types.


 #### 1. Looking at Total Cases VS Total Deaths
        -- Shows the liklyhood of dying by conutry
           SELECT location, date,total_cases_per_million, total_deaths, (total_deaths/total_cases_per_million)*1.0 as DeathPercentaje
           From PortafolioProject..CovidDeaths
           WHERE location like'%states%'
           ORDER BY 1,2	
#### 2. Looking at the Total Cases VS The Population
       -- Shows what Population % that has contracted COVID 
           SELECT location, date, population, total_cases_per_million,  (population/total_cases_per_million)*100 as PercentPopulationInfected
           From PortafolioProject..CovidDeaths
           WHERE location like'%states%'
           ORDER BY total_cases_per_million
           
#### 3. Looking Countries with highest Infeccion rates compared to population 

           SELECT location,population, max(total_cases_per_million) as highestInfectionCount,  max((population/total_cases_per_million))*100 as PercentPopulationInfected
           FROM PortafolioProject..CovidDeaths
           GROUP BY location,population
           --WHERE location like'%state%'
           ORDER BY PercentPopulationInfected desc
           
  #### 4. Showing the countries with the highest death count per population

           SELECT location,max(CAST(total_deaths AS bigint)) as totalDeathsCount
           FROM PortafolioProject..CovidDeaths
           WHERE continent is not null
           GROUP BY location, population
           ORDER BY totalDeathsCount DESC

 #### 5. 7. Total population VS Vaccinations JOIN FUNCTION

           SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
           sum(CONVERT(int,vac.new_vaccinations)) over (Partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
           FROM PortafolioProject..CovidDeaths dea 
           JOIN  PortafolioProject..CovidVaccinations vac
          	ON dea.location= vac.location and dea.date=vac.date
           WHERE dea.continent is not null
           ORDER BY  2,3

         
