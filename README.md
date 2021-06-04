# Isabel's Current Projects 📍
↩️[Homepage](https://itummino.github.io/Isabel-Tummino)

# [U.S. College Study](https://github.com/itummino/PortfolioProjects/blob/main/CollegeData.sql) ![image](https://user-images.githubusercontent.com/84094369/120266976-053e6400-c271-11eb-878b-386c5a803d44.png)
## *An Economic Take on College Career Paths, Post-Grad Unemployment Rates & Gender/Location Salary Differences*
![](/images/mapcollege.jpg)
### Sources/Procedure:
- Imported university post-grad salaries data from [Kaggle/Wall Street Journal](https://www.kaggle.com/wsj/college-salaries?select=salaries-by-college-type.csv)
- Imported university majors/careers 2012-2014 data from [American Community Survey](https://github.com/fivethirtyeight/data/tree/master/college-majors)
- Extracted and organized 4 different CSV spreadsheets worth of college data 
- Altered specific column names to match across different tables in order to perform various JOINs on primary keys
- Used SQL data cleaning to remove unneccessary data fields and customized queries to discover economic trends in different college types (Ivy league, Private, Public Universities) 
- Grouped together common college major categories (manipulated the datasets to view narrowed down options, too many majors on the CSVs originally)
#### 👉[Click here to view my SQL Code](https://github.com/itummino/PortfolioProjects/blob/main/CollegeData.sql)

### Points of Interest: 
- Calculated the unemployment rate for college grads based on employed/unemployed graduate numbers and created a new column to reflect the formula across every row
- Highlighted the top 5 major studies in each of the top 5 career path categories linked to the highest employment numbers (technical/scientific fields)
- College majors that have the highest average unemployment rates post-graduation (Liberal Arts studies fed this narrative unfortunately)
- Total figures of overall students employed and unemployed based on grouping by major category
- Identified male/female dominated fields and JOINed with employment data to see the correlation
- Analyzed the underrepresentation of women in STEM fields
- Compared avg starting salaries and mid-career salaries spanned across all majors and college types to see the long-term economic gain from varying academic paths 
- Created a location column based on the college name to see post-grad salaries based on different college locations (used this to create a map visualization)

### Data Visualizations:
- Created SQL views to store/condense the data in SSMS and then export into Tableau for data vizzes
- Built 2 detailed/condensed vizzes in Tableau Public for final analysis (linked below):

#### [Post-Grad Salaries Based on College Type, Location & Major](https://public.tableau.com/app/profile/isabel.tummino/viz/U_S_CollegeStudy/Dashboard1)
#### [Career Paths, Gender Differences, Unemployment Rates](https://public.tableau.com/app/profile/isabel.tummino/viz/U_S_CollegeStudy-CareerPathsGenderDifferencesUnemploymentRates/Dashboard1)
------------------------------------------------------------------------------------------------------------------------------------

# [Covid-19 Analysis](https://github.com/itummino/PortfolioProjects/blob/main/CovidData.sql) ![image](https://user-images.githubusercontent.com/84094369/120266911-dcb66a00-c270-11eb-9df0-c20d82d87cad.png)
## *A Global Look into Confirmed Cases, Death Rates, & Vaccinations Data*
![](/images/covid19.jpg)  
### Sources/Procedure:
- Imported global Covid-19 data from [OurWorldInData](https://ourworldindata.org/covid-deaths) from pandemic start (Feb 2020) to (May 2021) into Microsoft SQL Server Management Studio
- Extracted and organized case/deaths data and vaccinations data into two separate CSVs to perform table JOINs
- Used SQL data cleaning and complex queries to determine aggregate figures of total cases VS the population, analyzing trends between both the United States and around the globe
#### 👉[Click here to view my SQL Code](https://github.com/itummino/PortfolioProjects/blob/main/CovidData.sql)

### Points of Interest: 
- Countries with the highest infection rate and highest death count compared to the population
- Trends of cases/deaths over time, created a death percentage to visualize data more accurately
- Calculated the percentage of the U.S. population that contracted Covid-19 vs global figures
- Total population versus recorded vaccinations over time, calculated a global vaccination rate and used TEMP table and CTE 
- All new vaccines administered in the US over time
- Total vaccinations administered globally according to income bracket (low, lower middle, upper middle, high income)

### Data Visualizations:
- Created SQL views to store/condense the data in SSMS and then export into Tableau for data vizzes
- Built 3 different vizzes in Tableau Public for final analysis (linked below): 

#### [Global Covid-19 Data](https://public.tableau.com/app/profile/isabel.tummino/viz/GlobalCovid19Data/GlobalCovidData)
#### [US Covid-19 Data](https://public.tableau.com/app/profile/isabel.tummino/viz/U_S_Covid19Data/U_S_CovidData)
#### [Global Vaccinations Data](https://public.tableau.com/app/profile/isabel.tummino/viz/VaccinationsData/GlobalVaccinationData)
------------------------------------------------------------------------------------------------------------------------------------

# [Netflix Study](https://github.com/itummino/PortfolioProjects/blob/main/NetflixData.sql) 
## *The Evolution of Netflix Originals - Movies Edition*
![image](/images/smallnetflix.jpg)



### Sources/Procedure:
- Imported Netflix original movies and IMDB ratings data from 2014-2021 into one CSV from [Kaggle](https://www.kaggle.com/luiscorter/netflix-original-films-imdb-scores) which was downloaded from this [Wikipedia source](https://en.wikipedia.org/wiki/Lists_of_Netflix_original_films)
- Used SQL data cleaning to remove unneccessary data fields, and removed data that was collected at the end of 2014 and the current year (2021) that had incomplete data to achieve consistency
- Wrote a series of CASE statements to group together common movie genres into more broad categories (manipulated the datasets to view narrowed down options, there were too many similar movie genres on the original dataset) and created a new table to reflect the grouped genres after testing results with a CTE table
- Created a new column that divides movie ratings into 4 different performance categories based on a CASE statement, so that I could use this to group together weak/strong ratings that correlate with genres
#### 👉[Click here to view my SQL Code](https://github.com/itummino/PortfolioProjects/blob/main/NetflixData.sql)

### Points of Interest: 
- Calculated how many Netflix original movies have received poor ratings (less than 3 stars) from 2015-2020 and also the latter to find the highest reviews
- Analyzed how many bad/average/good/great reviews there were for each movie genre, and compared the data by year to see the progression and volume over time
- Discovered that since 2015, Netflix has greatly expanded their genre selection for their originals and there have been increasingly higher overall reviews
- Calculated the average rating per genre, as well as the max(highest) and min(lowest) rating of all time
- Used a filter on the years I extracted from the Release Date to navigate through movie trends over time (created a year splitter in Power BI)

### Data Visualizations:
- Created SQL views to store/condense the data in SSMS and then exported into Microsoft Power BI for data visualization as final analysis (linked below):

[Power BI - Netflix Study](https://app.powerbi.com/reportEmbed?reportId=e1e8cc0d-89df-456a-8363-a5adab85367e&autoAuth=true&ctid=2c94bed6-d675-4d3d-a53b-7b461fd6acc2&config=eyJjbHVzdGVyVXJsIjoiaHR0cHM6Ly93YWJpLXVzLW5vcnRoLWNlbnRyYWwtcmVkaXJlY3QuYW5hbHlzaXMud2luZG93cy5uZXQvIn0%3D)
- If you do not have a Microsoft Power BI account or are unable to view the above link (access issue) here is a non-interactive lower quality PDF of the dashboard that you can view:
#### [Netflix Study](https://raw.githubusercontent.com/itummino/PortfolioProjects/main/images/Nextflix%20Study.PNG)
------------------------------------------------------------------------------------------------------------------------------------

# [Nashville Housing Data](https://github.com/itummino/PortfolioProjects/blob/main/HousingData.sql) ![image](https://user-images.githubusercontent.com/84094369/120267077-39198980-c271-11eb-9e1b-5d23b5c690d4.png)
- This dataset was used strictly for data cleaning, here to showcase my SQL skills and ability to standardize data for efficiency and ease of use
- Removing duplicates with CTE tables, removing rows with NULL values, breaking up address columns using PARSENAME
- Removed inconsistencies with CASE statements and windows functions, converted DateTimes, used self JOIN
#### 👉[Click here to view my SQL Code](https://github.com/itummino/PortfolioProjects/blob/main/HousingData.sql)


