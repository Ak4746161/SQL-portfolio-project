select  *
from covid_deaths$

select *
from covid_vaccinations$


-- Infection rate in whole period country wise

Select location,population,date, MAX(total_cases) as HighestInfectionCount, 
MAX((total_cases/population))*100 as PercentagePopulationInfected
From covid_deaths$
GROUP BY location, population, date
order by PercentagePopulationInfected desc

-- Countries with highest Infection rate compared to population

Select location,population, MAX(total_cases) as HighestInfectionCount, 
MAX((total_cases/population))*100 as PercentagePopulationInfected
From covid_deaths$
GROUP BY location, population
order by PercentagePopulationInfected desc

-- Countries with highest death count per population

Select continent, MAX(total_deaths) as TotalDeathCount
From covid_deaths$
Where continent is not null
GROUP BY continent
order by TotalDeathCount desc

--Global numbers

Select SUM(new_cases) as Total_cases, SUM(new_deaths) as Total_deaths 
,(SUM(new_deaths)/SUM(new_cases))*100 as DeathPercentage
From covid_deaths$
Where continent is not null
order by 1,2


-- Total population vs Total Vaccination

Select deaths.continent, deaths.location, deaths.date, deaths.population, vacci.new_vaccinations
, SUM(vacci.new_vaccinations) OVER (Partition BY deaths.location Order By deaths.location,deaths.date)
as RollingCountOfPeopleVaccinated
From covid_deaths$ as deaths
Join covid_vaccinations$ vacci
     ON deaths.location = vacci.location
	 and deaths.date = vacci.date
Where deaths.continent is not null
order by 2,3


-- Percentage of Population Vaccinated

With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingCountOfPeopleVaccinated)
as
(
Select deaths.continent, deaths.location, deaths.date, deaths.population, vacci.new_vaccinations
, SUM(vacci.new_vaccinations) OVER (Partition BY deaths.location Order By deaths.location,deaths.date)
as RollingCountOfPeopleVaccinated
From covid_deaths$ as deaths
Join covid_vaccinations$ vacci
     ON deaths.location = vacci.location
	 and deaths.date = vacci.date
Where deaths.continent is not null
)
Select *, (RollingCountOfPeopleVaccinated/Population)*100 AS percentagePeopleVaccinated
From PopvsVac

