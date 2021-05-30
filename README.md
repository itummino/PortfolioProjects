# Isabel's Projects
Data Analyst Portfolio

# [Covid-19 Analysis ~ Cases, Deaths, Vaccinations Data](https://github.com/itummino/PortfolioProjects/blob/main/CovidData.sql)
- Imported global Covid-19 data from ourworldindata.org from pandemic start (Feb 2020) to current (May 2021) into Microsoft SQL Server Management Studio
- Extracted and organized case/deaths data and vaccinations data into two separate CSVs to perform table JOINs
- Used SQL data cleaning and complex queries to determine aggregate figures of total cases VS the population, analyzing trends between both the United States and around the globe
- Points of interest: 
    - Countries with the highest infection rate and highest death count compared to the population, also 
    - Trends of cases/deaths over time, created a death percentage to visualize data more accurately
    - Percentage of the U.S. population that contracted Covid vs global figures
    - Total population versus recorded vaccinations over time, created a global vaccination rate and used TEMP table and CTE 
    - All new vaccines administered in the US over time
    - Total vaccinations administered globally according to income bracket (low, lower middle, upper middle, high income)
- Created views to store/condense the data in SSMS and then export into Tableau for data visualizations

- Built 3 different Tableau vizzes:
    - [Global Covid-19 Data](https://public.tableau.com/app/profile/isabel.tummino/viz/GlobalCovid19Data/GlobalCovidData)
    - [US Covi-19 Data](https://public.tableau.com/app/profile/isabel.tummino/viz/U_S_Covid19Data/U_S_CovidData)
    - Global Vaccinations Data](https://public.tableau.com/app/profile/isabel.tummino/viz/VaccinationsData/GlobalVaccinationData)
