--Viewing all the Covid deaths data for all the countries  
Select * 
From covid_explo_sql..CovidDeaths
where continent is not null 
Order by 3,4

--Viewing all the Vaccinations data for all the countries
Select * 
From covid_explo_sql..CovidVaccination
where continent is not null 
Order by 3,4

-- Showing the percentage possibility of dying after contracting the disease in Nigeria
-- by looking at the total deaths over total cases 

Select Location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From covid_explo_sql..CovidDeaths
Where Location = 'nigeria'
order by 1,2

-- Showing the percentage possibility of dying after contracting the disease by country
-- by looking at the total deaths over total cases 
Select Location, MAX(total_cases) as Latest_total_cases, MAX(Convert(int,total_deaths)) as Latest_total_deaths,(MAX(total_deaths)/MAX(total_cases))*100 as DeathPercentage
From covid_explo_sql..CovidDeaths
Group by location
order by DeathPercentage desc

-- Showing the percentage of the population that has been infected in Nigeria
-- by looking at the total_cases over the population  

Select Location, date, total_cases, Population,(total_cases/population)*100 as infectedPercentage
From covid_explo_sql..CovidDeaths
Where Location  = 'nigeria'
order by 1,2

Select Location, MAX(total_cases) as Total_Cases, MAX(Population) as Total_Population,(MAX(total_cases)/MAX(population))*100 as infectedPercentage
From covid_explo_sql..CovidDeaths
Where Location = 'nigeria'
Group by Location
order by 1,2 

-- Showing Countries with highest infection percentage rate 
-- by looking at latest total cases over the population
Select Location, Population,MAX(total_cases) as Latest_Total_Cases,MAX((total_cases/population))*100 as infectedPercentage
From covid_explo_sql..CovidDeaths
where continent is not null
Group by location, population
order by infectedPercentage desc

-- Showing Continents with highest infection percentage rate 
-- by looking at latest total cases over the population
Select Location, Population,MAX(total_cases) as Latest_Total_Cases,MAX((total_cases/population))*100 as infectedPercentage
From covid_explo_sql..CovidDeaths
where continent is null
Group by location, population
order by infectedPercentage desc

-- Showing countries with highest latest total death counts also as percentages of the whole population
Select Location, MAX(cast(total_deaths as int)) as Latest_Total_Deaths, population,MAX((total_deaths/population)) * 100 as deathPercentagePopulation
From covid_explo_sql..CovidDeaths
where continent is not null
Group by location, population
order by Latest_Total_Deaths desc

-- Showing continents with highest latest total death counts also as percentages of the whole population
Select Location, MAX(cast(total_deaths as int)) as Latest_Total_Deaths,population,MAX((total_deaths/population)) * 100 as deathPercentagePopulation
From covid_explo_sql..CovidDeaths
where continent is null
Group by location, population
order by Latest_Total_Deaths desc

-- Showing the percentage infection rate for countries
-- by looking at the total cases over the population
Select Location, Population,MAX(total_cases) as Latest_Total_Cases,MAX((total_cases/population))*100 as infectedPercentage
From covid_explo_sql..CovidDeaths
where continent is not null
Group by location, population
order by population desc,infectedPercentage desc

-- Showing the percentage infection rate for continents
-- by looking at the total cases over the population
Select Location, Population,MAX(total_cases) as Latest_Total_Cases,MAX((total_cases/population))*100 as infectedPercentage
From covid_explo_sql..CovidDeaths
where continent is null
Group by location, population
order by population desc,infectedPercentage desc

-- Showing the World infected death percentage per day
-- by taking the total deaths over total cases  for each day 

Select date,  sum(total_cases) as total_cases, sum(cast(total_deaths as int)) as total_deaths,
sum(cast(total_deaths as int))/sum(total_cases)*100 as DeathPercentage
From covid_explo_sql..CovidDeaths
where continent is not null
Group by date 
order by 1, 2

-- Showing the World infection rate per day

Select date, population,  sum(total_cases) as total_cases, sum(total_cases)/population *100 as DeathPercentage
From covid_explo_sql..CovidDeaths
where location = 'world'
Group by date, population 
order by 1, 2

--Showing the Vaccination rate for each country 
-- by joining the death and vaccination tables then taking new vaccinations over population 
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations, 
(vac.new_vaccinations/ dea.population) * 100 as VaccinationsRate
From covid_explo_sql..CovidDeaths dea 
Join covid_explo_sql..CovidVaccinations vac 
	on dea.date = vac.date
	and dea.location = vac .location
where dea.continent is not null 
order by 1,2,3

-- Showing new vaccinations with a rolling sum and percentage for each country
-- using CTE 

With Population_rolling_Vaccination (Continent, Location, Date, Population, New_Vaccinations, rolling_total_vaccinations) 
as 
(
Select dea.continent,dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER 
(Partition by dea.location Order by dea.location, dea.date) as rolling_total_vaccinations
From covid_explo_sql..CovidDeaths dea 
Join covid_explo_sql..CovidVaccinations vac 
	on dea.date = vac.date
	and dea.location = vac .location
where dea.continent is not null 
)

Select * , (rolling_total_vaccinations / population) * 100 as rolling_vaccinations_Percentage
From Population_rolling_Vaccination











