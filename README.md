# COVID19-Data-Exploration.SQL 2022

Analysis for latest updates, on COVID19 globally. Data Source; retrive from https://ourworldindata.org/covid-deaths SQL Data Exploration Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types.


 #### 1. Looking at Total Cases VS Total Deaths
         -- Shows the liklyhood of dying by conutry
          select location, date,total_cases_per_million, total_deaths, (total_deaths/total_cases_per_million)*1.0 as DeathPercentaje
from PortafolioProject..CovidDeaths
WHERE location like'%state%'
ORDER BY 1,2	
