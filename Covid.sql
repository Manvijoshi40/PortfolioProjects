Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 1,2



-- Total cases VS Population

Select Location, date, total_cases,(total_cases/Population)*100 AS InfectedPercentage
From PortfolioProject..CovidDeaths
ORDER BY 1,2

 

 --  Total Deaths VS Total cases

Select Location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 AS DeathPercentage
From PortfolioProject..CovidDeaths
ORDER BY 1,2



--  Countries with Highest Infection Rate compared to Population

Select Location,population,MAX(total_cases)AS HighestInfectionCount,MAX((total_cases/Population))*100 AS PopulationInfectedPercentage
From PortfolioProject..CovidDeaths
GROUP BY location,population
ORDER BY PopulationInfectedPercentage desc



--Countries with Death Count compared to Population

Select Location,MAX(cast(total_deaths as int))AS TotalDeathCount
From PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY  TotalDeathCount desc



--Death count divided by Continents

Select continent,MAX(cast(total_deaths as int))AS TotalDeathCount
From PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY  TotalDeathCount desc



--Global Numbers per day

Select date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
WHERE continent is not null 
Group by date
order by 1,2


--Global Numbers total
Select SUM(total_cases), SUM(cast(total_deaths as int)), SUM(cast(total_deaths as int))/SUM(total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
where continent is not null 




-- Total Population VS Vaccinations


Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS int)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent is not null 
ORDER BY 2,3

--Calculation on Partition By in previous query


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
)
Select *, (RollingPeopleVaccinated/Population)*100 VaccinatedPercentage
From PopvsVac

