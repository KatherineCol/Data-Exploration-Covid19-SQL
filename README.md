# COVID19-Data-Exploration.SQL 2022

Analysis for latest updates, on COVID19 globally. Data Source; retrive from https://ourworldindata.org/covid-deaths SQL Data Exploration Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types.


 #### 1. Looking at Total Cases VS Total Deaths
        -- Shows the liklyhood of dying by conutry
          select location, date,total_cases_per_million, total_deaths,    (total_deaths/total_cases_per_million)*1.0 as DeathPercentaje
          From PortafolioProject..CovidDeaths
          WHERE location like'%state%'
          ORDER BY 1,2	
#### 2. Looking at the Total Cases VS The Population
       -- Shows what Population % that has contracted COVID 
          select location, date, population, total_cases_per_million,  (population/total_cases_per_million)*100 as PercentPopulationInfected
         From PortafolioProject..CovidDeaths
         WHERE location like'%state%'
         ORDER BY total_cases_per_million
