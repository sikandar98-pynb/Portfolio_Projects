-- importing the data into the SQL
select * 
 from Portfolio_Project.dbo.[covid deaths]
  where continent is not null

select * 
 from Portfolio_Project.dbo.[covid vaccines]
  where continent is not null

-- cleaning and transforming the data 
-- Cleaning the first table - covid deaths:
select date 
 from Portfolio_Project.dbo.[covid deaths]

Alter table [covid deaths]
   alter column date date;

select total_cases 
 from Portfolio_Project.dbo.[covid deaths]

 update Portfolio_Project.dbo.[covid deaths]
  Set total_cases=0
   where total_cases is null

select population 
 from Portfolio_Project.dbo.[covid deaths]

 update Portfolio_Project.dbo.[covid deaths]
 set population=0
  where population is null

select new_cases 
 from Portfolio_Project.dbo.[covid deaths]

 update Portfolio_Project.dbo.[covid deaths]
  set new_cases = 0 
   where new_cases is null

select total_deaths 
 from Portfolio_Project.dbo.[covid deaths]
 
update Portfolio_Project.dbo.[covid deaths]
  set total_deaths= 0 
   where total_deaths is null

Alter table Portfolio_Project.dbo.[covid deaths]
 ADD case_year int  
 
update Portfolio_Project.dbo.[covid deaths]
 SET case_year = Year(date)

Alter table Portfolio_Project.dbo.[covid deaths]
 ADD case_month int 

 update Portfolio_Project.dbo.[covid deaths]
 SET case_month = month(date)

Alter table Portfolio_Project.dbo.[covid deaths]
 ADD month_name varchar(100)

update Portfolio_Project.dbo.[covid deaths]
 SET month_name = 
   CASE 
    when case_month =1 then 'January'
	when case_month =2 then 'Febuary'
	when case_month =3 then 'March'
	when case_month =4 then 'April'
	when case_month =5 then 'May'
	when case_month =6 then 'June'
	when case_month =7 then 'July'
	when case_month =8 then 'August'
	when case_month =9 then 'September'
	when case_month =10 then 'October'
	when case_month =11 then 'November'
	when case_month =12 then 'December'
	else 'none'
	end;

Alter table Portfolio_Project.dbo.[covid deaths]
 alter column total_deaths float

ALter table Portfolio_Project.dbo.[covid deaths]
 alter column new_cases float

ALter table Portfolio_Project.dbo.[covid deaths]
 alter column total_cases float

select location,continent, date,case_year,case_month,month_name,total_cases,new_cases, total_deaths 
 from Portfolio_Project.dbo.[covid deaths]
  order by 1,3

-- cleaning table two i.e the covid vaccines

select new_tests,total_tests,people_vaccinated, people_fully_vaccinated
 from Portfolio_Project.dbo.[covid vaccines]
  where continent is not null

update Portfolio_Project.dbo.[covid vaccines]
  set new_tests= 0 
   where new_tests is null
update Portfolio_Project.dbo.[covid vaccines]
  set total_tests=0
 where total_tests is null 

update Portfolio_Project.dbo.[covid vaccines]
  set people_vaccinated=0
   where people_vaccinated is null

update Portfolio_Project.dbo.[covid vaccines]
  set people_fully_vaccinated = 0
   where  people_fully_vaccinated is null

update Portfolio_Project.dbo.[covid vaccines]
  set new_vaccinations = 0
   where  new_vaccinations is null

update Portfolio_Project.dbo.[covid vaccines]
  set total_vaccinations = 0
   where  total_vaccinations is null

update Portfolio_Project.dbo.[covid vaccines]
  set extreme_poverty = 0
   where  extreme_poverty is null

update Portfolio_Project.dbo.[covid vaccines]
  set female_smokers = 0
   where  female_smokers is null

update Portfolio_Project.dbo.[covid vaccines]
  set male_smokers = 0
   where  male_smokers is null

Alter table Portfolio_Project.dbo.[covid vaccines]
 alter column total_tests float

Alter table Portfolio_Project.dbo.[covid vaccines]
  alter column new_tests float

Alter table Portfolio_Project.dbo.[covid vaccines]
   alter column date date;

Alter table Portfolio_Project.dbo.[covid vaccines]
 ADD case_year int  
 
update Portfolio_Project.dbo.[covid vaccines]
 SET case_year = Year(date)

Alter table Portfolio_Project.dbo.[covid vaccines]
 ADD case_month int 

 update Portfolio_Project.dbo.[covid vaccines]
 SET case_month = month(date)

Alter table Portfolio_Project.dbo.[covid vaccines]
 ADD month_name varchar(100)

update Portfolio_Project.dbo.[covid vaccines]
 SET month_name = 
   CASE 
    when case_month =1 then 'January'
	when case_month =2 then 'Febuary'
	when case_month =3 then 'March'
	when case_month =4 then 'April'
	when case_month =5 then 'May'
	when case_month =6 then 'June'
	when case_month =7 then 'July'
	when case_month =8 then 'August'
	when case_month =9 then 'September'
	when case_month =10 then 'October'
	when case_month =11 then 'November'
	when case_month =12 then 'December'
	else 'none'
	end;
-- carrying out analysis and saving as views to be used in Power Bi for Vizualization.

-- 1. analysis to find insights in the data of covid deaths:

 select location,sum(total_deaths) as 'total deaths'
  from Portfolio_Project.dbo.[covid deaths]
  where continent is not null
   group by(location)
    order by 'total deaths' desc


--2. Find the death percentage by dividing the total deaths by total cases
-- showing the likelihood of death percentage in the month of May,2021 if you are living in India.
 select location,case_year,month_name,total_cases, total_deaths,(total_deaths/total_cases)*100 as 'Death Percentage'
  from Portfolio_Project.dbo.[covid deaths]
   where total_cases <> 0 and location like '%india' and case_year=2021 and case_month = 5 and continent is not null

--3. Looking at total cases by population
-- shows what percentage of population got covid
 select location,case_year,sum(population) as 'Total Population',sum(total_cases) as 'Total Cases', (sum(total_cases)/sum(population))*100 as 'Infection Percentage' 
   from Portfolio_Project.dbo.[covid deaths]
   where total_cases <> 0 and location like '%india' and case_month = 4
    group by location,case_year

--4. Analysing the countries to find the highest Infection Rates compared to the population
select location,population,MAX(total_cases) as 'Total Cases', MAX((total_cases/population))*100 as 'Infection Percentage'
 from Portfolio_Project.dbo.[covid deaths]
  where population <> 0 and continent is not null
  Group by location,population 
   order by 'Infection Percentage' DESC

--5. Analysing the countries to find the highest death rates compared to the population
select location,population,MAX(total_deaths) as 'Total Deaths', MAX((total_deaths/population))*100 as 'Death Percentage'
 from Portfolio_Project.dbo.[covid deaths]
  where population<>0 and continent is not null
   Group by location,population
    order by 'Total Deaths' DESC

--6. Show the continents with highest death counts per continent
 select continent,MAX(population) as 'Population',MAX(total_deaths) as 'Total Deaths', MAX((total_deaths/population))*100 as 'Death Percentage'
 from Portfolio_Project.dbo.[covid deaths]
  where population<>0 and continent is not null
   Group by continent
    order by 'Total Deaths' DESC

--7. Show global numbers
select continent,case_year as 'Year', SUM(total_cases) as 'Total Cases',SUM(total_deaths) as 'Total Deaths', SUM(population) as 'Population',MAX((total_deaths/population))*100 as 'Death Percentage',(sum(total_cases)/sum(population))*100 as 'Infection Percentage' 
 from Portfolio_Project.dbo.[covid deaths]
  where population<>0 and continent is not null
   Group by continent,case_year
   order by 'Year', 'Total Deaths' asc

--8. Show total cases, total new cases, total deaths, total Death Percentage and infection percentage
select SUM(total_cases) as 'Total Cases',SUM(new_cases) as 'Total New Deaths',SUM(total_deaths) as 'Total Deaths',SUM(cast(total_deaths as int)) as 'Total New Deaths',SUM((total_deaths/population))*100 as 'Death Percentage',SUM((total_cases/population))*100 as 'Infection Percentage' 
 from Portfolio_Project.dbo.[covid deaths]
  where population<>0 and continent is not null

-- analysis of table 2 i.e. covid vaccines
-- 1.showing the number of vaccines per location
select location, SUM(total_tests) as 'Total Tests',SUM(new_tests) as 'Total New Tests'
 from Portfolio_Project..[covid vaccines]
  where continent is not null
   GROUP BY location 
    ORDER BY 1 ASC
--2. show the number of total tests and the % of positive rate
select location, SUM(total_tests) as 'Total Tests', SUM(cast(positive_rate as float)) as '% of Positive rates'
 from Portfolio_Project.dbo.[covid vaccines]
  where continent is not null and positive_rate is not null
   GROUP BY location
    ORDER BY 1 ASC

--Analyse via joining the two tables
--1. Showing the Total Vaccinations V/s Total Population 
select dea.continent,dea.location, dea.date,dea.population as 'Population',vac.new_vaccinations
,SUM(convert(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,
dea.date) as 'Rolling_people_vaccinated'
 from Portfolio_Project.dbo.[covid deaths] dea
 join Portfolio_Project.dbo.[covid vaccines] vac
  on dea.location = vac.location 
   and dea.date = vac.date
   where dea.continent is not null and dea.population <>0
   order by 2,3

-- USE CTE

with populationvsvaccinated(continent,location,date,population,new_Vacinations,Rolling_people_Vaccinated)
as
(
select dea.continent,dea.location, dea.date,dea.population as 'Population',vac.new_vaccinations
,SUM(convert(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location,dea.date) as 'Rolling_people_vaccinated'
 from Portfolio_Project.dbo.[covid deaths] dea
 join Portfolio_Project.dbo.[covid vaccines] vac
  on dea.location = vac.location 
   and dea.date = vac.date
   where dea.continent is not null and dea.population <>0
  --order by 2,3
   )
select * ,(Rolling_people_Vaccinated/population)*100 as 'Percentageofpeoplevaccinated'
 from populationvsvaccinated

--2. Showing the Total Deaths V/s Vaccines:

Select dea.continent, dea.location, dea.date, dea.total_deaths, vac.total_vaccinations as 'Total Vaccinations'
,SUM(cast(vac.total_vaccinations as float)) OVER (Partition by dea.location order by dea.location,dea.date) as 'Rolling_people_vaccinated'
from Portfolio_Project.dbo.[covid deaths] dea
 join Portfolio_Project.dbo.[covid vaccines] vac
  on dea.location = vac.location 
   and dea.date = vac.date
   where dea.continent is not null and dea.population <>0
  --order by 2,3 DESC

-- with temp Table:
Create Table deathspervaccinations
(Continent varchar(255),
location varchar(255),
date date,
total_deaths numeric,
total_vaccinations numeric,
Rolling_people_vaccinated numeric
)
Insert into deathspervaccinations
Select dea.continent, dea.location, dea.date, dea.total_deaths, 
vac.total_vaccinations as 'Total Vaccinations',SUM(cast(vac.total_vaccinations as float)) OVER (Partition by dea.location order by dea.location,dea.date) as 'Rolling_people_vaccinated'
from Portfolio_Project.dbo.[covid deaths] dea
 join Portfolio_Project.dbo.[covid vaccines] vac
  on dea.location = vac.location 
   and dea.date = vac.date
   where dea.continent is not null and dea.population <>0
  --order by 2,3 DESC

select *,(total_deaths/Rolling_people_vaccinated )*100 as 'Percentage_death_v/s_vaccine'
 from deathspervaccinations 
  where Rolling_people_vaccinated<> 0
  order by 2,3 Desc

-- Total Vaccinations v/s Population
Select dea.continent, dea.location, dea.date, dea.population, vac.total_vaccinations as 'Total Vaccinations'
,SUM(cast(vac.total_vaccinations as float)) OVER (Partition by dea.location order by dea.location,dea.date) as 'Rolling_people_vaccinated'
from Portfolio_Project.dbo.[covid deaths] dea
 join Portfolio_Project.dbo.[covid vaccines] vac
  on dea.location = vac.location 
   and dea.date = vac.date
   where dea.continent is not null and dea.population <>0
   --order by 2,3 DESC
Create Table vaccineperpopulation 
(Continent varchar(255),
location varchar(255),
date date,
population numeric,
total_vaccinations numeric,
Rolling_people_vaccinated numeric
)
Insert into vaccineperpopulation
Select dea.continent, dea.location, dea.date, dea.population, 
vac.total_vaccinations as 'Total Vaccinations',SUM(cast(vac.total_vaccinations as float)) OVER (Partition by dea.location order by dea.location,dea.case_month) as 'Rolling_people_vaccinated'
from Portfolio_Project.dbo.[covid deaths] dea
 join Portfolio_Project.dbo.[covid vaccines] vac
  on dea.location = vac.location 
   and dea.date = vac.date
   where dea.continent is not null and dea.population <>0
  --order by 2,3 DESC

select *,(total_vaccinations/population)*100 as 'PeopleVaccinated_by_Population'
 from  vaccineperpopulation
  where Rolling_people_vaccinated<> 0 and population<>0 and location like '%india%'
  order by 2,3 Desc

-- Creating Views to import for futher visualizations:

--1. Create a view to select the number of total cases, total deaths and %deathsbycases
CREATE VIEW death_vs_cases AS
SELECT location,date,month_name,total_deaths as 'Total Deaths',total_cases as 'Total Cases',(total_deaths/total_cases)*100 as 'DeathsvsCases'
 from Portfolio_Project..[covid deaths]
 where continent is not null and total_cases<>0
--2. Create a view to select the number of infection rate,deathrate per population
CREATE VIEW infection_death_rate as
SELECT location,date,month_name,population,total_cases as 'Total Cases',total_deaths as 'Total Deaths',(total_cases/population)*100 as 'InfectionRate',
(total_deaths/population)*100 as 'DeathRate'
 from Portfolio_Project.dbo.[covid deaths]
 where continent is not null and total_cases<>0
 --3. Create view to select the total_vaccines,new_vaccines
 CREATE VIEW vaccines as
 SELECT location,date,month_name,total_vaccinations as 'Total Vaccines', new_vaccinations as 'New Vaccines'
  from Portfolio_Project.dbo.[covid vaccines]
   where continent is not null
--4. Create a view to check the number of people vaccinated partially and fully compared to the population
CREATE VIEW vaccinesbypopulation as
SELECT dea.location,dea.date,dea.month_name,dea.population,vac.people_vaccinated,vac.people_fully_vaccinated,
(vac.people_vaccinated/dea.population)*100 as'First_Dose',(vac.people_fully_vaccinated/dea.population)*100 as 'Fully_Vaccinated'
from  Portfolio_Project.dbo.[covid deaths] dea
 join Portfolio_Project.dbo.[covid vaccines] vac
  on dea.location = vac.location 
   and dea.date = vac.date
   where dea.continent is not null and dea.population <>0
--5.selecting a view to show the number of covid patients and the reason
CREATE VIEW REASON as
select location,date,month_name,extreme_poverty as 'Extreme Poverty',cardiovasc_death_rate as 'Cardiovascular Death',diabetes_prevalence as 'Diabetic'
,SUM(cast(female_smokers as float)+cast(male_smokers as float)) as 'Smokers'
from Portfolio_Project.dbo.[covid vaccines]
 where continent is not null
 group by location,date,month_name,extreme_poverty,cardiovasc_death_rate,diabetes_prevalence
--6.Create a view to vizualise the population, death%, total tests,total vaccines
CREATE VIEW PercentagePopulation as
select dea.location, dea.date,dea.month_name,dea.population,(dea.total_deaths/vac.people_fully_vaccinated)*100 as 'DeathperVaccination',
(dea.total_deaths/vac.total_tests)*100 as 'DeathperTest',(vac.people_fully_vaccinated/dea.population)*100 as 'Vacinated People'
,(dea.total_deaths/vac.people_vaccinated)*100 as 'DeathperFirstDose',(vac.people_vaccinated/dea.population)*100 as 'PeopleWithFirstDose'
 from Portfolio_Project.dbo.[covid deaths] dea
 join Portfolio_Project.dbo.[covid vaccines] vac
  on dea.location = vac.location 
   and dea.date = vac.date
   where dea.continent is not null and dea.population <>0 and vac.total_tests<>0 and vac.total_vaccinations<>0 and vac.people_vaccinated<>0
   and vac.people_fully_vaccinated <>0
--7. View that would Include Dates for mapping 
create view DateDim as 
select date,case_month,month_name,case_year
 from Portfolio_Project.dbo.[covid deaths]
--8. Create view that would include Locations for Mapping
create view Location as
 select location 
 from Portfolio_Project.dbo.[covid deaths]
