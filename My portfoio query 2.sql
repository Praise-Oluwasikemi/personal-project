SELECT *
FROM MyPortfolioProject..CovidVaccination

--join the two tables
SELECT *
FROM MyPortfolioProject..CovidDeaths AS dea
JOIN MyPortfolioProject..CovidVaccination AS vac
ON dea.location = vac.location
AND dea.date = vac.date    

-- Total Population vs Vaccinations
--Shows %Population that has recieved at least one Covid Vaccine
 SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location ORDER BY dea.location) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM MyPortfolioProject..CovidDeaths dea
JOIN MyPortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3


-- Using CTE (Common Table Expression) to perform Calculation on Partition By in previous query
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
( 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations AS bigint)) OVER (Partition by dea.location ORDER BY dea.location) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM MyPortfolioProject..CovidDeaths dea
JOIN MyPortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL 
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac


-- Using Temp Table to perform Calculation on Partition By in previous query
DROP Table IF exists #PercentPopulationVaccinated
CREATE Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM MyPortfolioProject..CovidDeaths dea
JOIN MyPortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated


-- Creating View to store data for visualizations that will be made later
CREATE VIEW PercentPopulationVaccinatedd AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM MyPortfolioProject..CovidDeaths dea
JOIN MyPortfolioProject..CovidVaccination vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL

select*
from PercentPopulationVaccinatedd