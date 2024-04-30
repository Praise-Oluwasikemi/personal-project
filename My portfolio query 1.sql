SELECT *
FROM MyPortfolioProject..CovidDeaths
WHERE continent is not null 
ORDER BY 3,4

--First set of data
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM MyPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
order by 1,2

-- Total Cases versus Total Deaths
-- Shows posibility of dying if you contract covid in your country
SELECT Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM MyPortfolioProject..CovidDeaths
WHERE location LIKE '%states%'
AND continent IS NOT NULL 
ORDER BY 1,2

--coverting data type to integer
ALTER TABLE CovidDeaths
ALTER COLUMN total_cases int
ALTER TABLE CovidDeaths
ALTER COLUMN total_deaths int

--Total Cases VS Total Deaths (Nigeria)
SELECT Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM MyPortfolioProject..CovidDeaths
WHERE location = 'Nigeria'
AND continent IS NOT NULL 
ORDER BY 1,2

-- Total Cases vs Population
-- Shows what percentage of population infected with Covid
SELECT Location, date, Population, total_cases,  (total_cases/population)*100 AS PercentPopulationInfected
FROM MyPortfolioProject..CovidDeaths
ORDER BY 1,2

-- Countries with Highest Infection Rate compared to Population
SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount,  Max((total_cases/population))*100 AS PercentPopulationInfected
FROM MyPortfolioProject..CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected desc

-- Countries with Highest Death Count per Population
SELECT Location, MAX(cast(Total_deaths AS int)) AS TotalDeathCount
FROM MyPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY Location
ORDER BY TotalDeathCount desc

-- break down by CONTINENT
-- Showing contintents with the highest death count per population
SELECT continent, MAX(cast(Total_deaths AS int)) AS TotalDeathCount
FROM MyPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY TotalDeathCount desc

-- GLOBAL NUMBERS
SELECT SUM(new_cases) AS total_cases, SUM(cast(new_deaths AS int)) AS total_deaths, SUM(cast(new_deaths AS int))/SUM(New_Cases)*100 as DeathPercentage
FROM MyPortfolioProject..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 1,2
