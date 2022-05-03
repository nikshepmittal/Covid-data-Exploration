select * from portfolio_project..CovidDeaths$ where continent is not null

select location,date,total_cases,total_deaths
,(total_deaths/total_cases)*100 as deathpercentage from portfolio_project..CovidDeaths$ where location like '%states'  order by 1,2

select location,population,max(total_cases) as maximum_casesin_one_day , max((total_cases/population))*100 as highestinfected_percent
from portfolio_project..CovidDeaths$
group by location,population
order by max(total_cases) desc

select location,population,max(total_deaths) as maximum_deathsin_oneday
from portfolio_project..CovidDeaths$
group by location,population
order by max(total_deaths) desc

select max(cast (total_deaths as int )) as maximum_deathsin_oneday
from portfolio_project..CovidDeaths$
group by location
order by max(total_deaths) desc

--query for  day on which maximum number of deaths occured with the date and grouped by location . 
select location,population,date from portfolio_project..CovidDeaths$ where total_deaths in (select max(cast (total_deaths as int )) as maximum_deathsin_oneday
from portfolio_project..CovidDeaths$ where continent is not null
group by location
)order by location

-- maximum  total deaths by continent in single day 
select location,max(cast (total_deaths as int )) as maximum_deathsin_oneday
from portfolio_project..CovidDeaths$
where continent is null
group by location
order by maximum_deathsin_oneday desc

-- maximum total deaths by continent in single day with date
select top 11 (location),date,cast (total_deaths as int) as totaldeaths from portfolio_project..CovidDeaths$
where continent is null and total_deaths in(select max(cast (total_deaths as int )) as maximum_deathsin_oneday
from portfolio_project..CovidDeaths$
where continent is null
group by location)
order by totaldeaths desc

--query on world level date wise
select date,SUM(new_cases) as total_new_cases,SUM(cast(new_deaths as int)) as total_newdeaths
,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercent
from portfolio_project..CovidDeaths$
where continent is not null
group by date
order by date

--query on total vaccinations upto  a date location wise

select dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as total_vaccinations 
from portfolio_project..CovidDeaths$ dea
join portfolio_project..Covidvaccinations$ vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null

--query on total vaccinations by population percent  upto date location wise(method1)

select dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as total_vaccinations 
,(SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date))/dea.population *100 as percentpopvaccinated 
from portfolio_project..CovidDeaths$ dea
join portfolio_project..Covidvaccinations$ vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null

--query on total vaccinations by population percent  upto date location wise(method2-using CTE)

with popvsvac(location,date,population,new_vaccinations,total_vaccinations) as
(
select dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as total_vaccinations  
from portfolio_project..CovidDeaths$ dea
join portfolio_project..Covidvaccinations$ vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null
)

select * ,(total_vaccinations/population)*100 as vaccinated_population_percent from popvsvac


--create view for future visualizations

create view percentpopulationvaccinated as
select dea.location,dea.date,dea.population,vac.new_vaccinations
,SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as total_vaccinations  
from portfolio_project..CovidDeaths$ dea
join portfolio_project..Covidvaccinations$ vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null














