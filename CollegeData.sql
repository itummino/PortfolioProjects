U.S. Colleges/Majors Study
---------------- All Majors Employed/Unemployed -------------------------------

SELECT * FROM CollegeData..AllMajorsEmployed

--- First to delete unecessary columns 
ALTER TABLE CollegeData..AllMajorsEmployed
DROP COLUMN Major_Code, P25th, P75th

--- Need to calculate unemployment rate
-- unemployment rate = (# unemployed / total labor force) * 100
SELECT *, (Unemployed/Total)*100 as UnemploymentRate
FROM CollegeData..AllMajorsEmployed

-- Creating UnemploymentRate column
ALTER TABLE CollegeData..AllMajorsEmployed
ADD UnemploymentRate Float
UPDATE CollegeData..AllMajorsEmployed
SET UnemploymentRate = (Unemployed/Total)*100

-- Grouping together college majors to see the average unemployment rate for each major 
-- As predicted, non-STEM majors such as liberal arts, humanities, communications, psych, social sciences, law have the highest unemployment rates
SELECT Major_category, AVG(UnemploymentRate) as AvgUnemploymentRate 
FROM CollegeData..AllMajorsEmployed
GROUP BY Major_category
ORDER BY 2 DESC

-- Grouping together major categories to see the total numbers of students employed vs unemployed
SELECT Major_category, SUM(Employed) as TotalEmployed, SUM(Unemployed) as TotalUnemployed
FROM CollegeData..AllMajorsEmployed
GROUP BY Major_category
ORDER BY TotalEmployed DESC 

-- Spotlighting specific majors to create Views for Tableau
----Which specific career paths in major categories have the highest employment turnaround? 
-- 5 for 5 outlook on college career paths, "Trying to decide on a college major that won't leave you unemployed post grad?"

-- ENGINEERING, popularity of top 5 Engineering career paths as well as total students employed post-grad
SELECT TOP 5 Major, Total, Employed
FROM CollegeData..AllMajorsEmployed
WHERE Major LIKE '%Engineering'
ORDER BY Employed DESC

-- BIO/SCIENCES
SELECT TOP 5 Major, Total, Employed
FROM CollegeData..AllMajorsEmployed
WHERE Major_category = 'Biology & Life Science'
ORDER BY Employed DESC

-- BUSINESS
SELECT TOP 5 Major, Total, Employed
FROM CollegeData..AllMajorsEmployed
WHERE Major_category = 'Business'
ORDER BY Employed DESC

-- MATH/COMP SCI
SELECT TOP 5 Major, Total, Employed
FROM CollegeData..AllMajorsEmployed
WHERE Major_category = 'Computers & Mathematics'
ORDER BY Employed DESC

-- HUMANITIES/ARTS
SELECT TOP 5 Major, Total, Employed
FROM CollegeData..AllMajorsEmployed
WHERE Major_category = 'Humanities & Liberal Arts'
ORDER BY Employed DESC

------------------- STEM Majors By Gender ---------------------------

SELECT * FROM CollegeData..STEMByGender

--- First to delete unecessary columns 
ALTER TABLE CollegeData..STEMByGender
DROP COLUMN Major_Code, Rank

-- Total number of students enrolled in STEM fields based on Men vs Women
-- How underrepresented are women in STEM fields?
SELECT Major_category, SUM(Total) as Total, SUM(Men) as TotalMen, SUM(Women) as TotalWomen
FROM CollegeData..STEMByGender
GROUP BY Major_category
ORDER BY 2 DESC 

---College career paths dominated by either males or females---
-- Top 10 majors where women are overrepresented and men are underrepresented
SELECT TOP 10 Major, Total, Men, Women
FROM CollegeData..STEMByGender
WHERE Women > Men
ORDER BY 2 DESC 
-- Top 10 majors where men are overrepresented and women are underrepresented
SELECT TOP 10 Major, Total, Men, Women
FROM CollegeData..STEMByGender
WHERE Men > Women
ORDER BY 2 DESC 

-- JOIN with AllMajorsEmployed table to see employment numbers side-by-side gender
SELECT a.Major_category, SUM(a.Total) as Total, SUM(Men) as TotalMen, SUM(Women) as TotalWomen, AVG(UnemploymentRate) as AvgUnemploymentRate
FROM CollegeData..STEMByGender a
JOIN CollegeData..AllMajorsEmployed b
ON a.Major = b.Major and a.Major_category = b.Major_category
GROUP BY a.Major_Category
ORDER BY 5 DESC 

-- JOIN to show all Engineering majors with total men/women, as well as unemployment rates
SELECT a.Major, a.Total, a.Men, a.Women, b.UnemploymentRate
FROM CollegeData..STEMByGender a
JOIN CollegeData..AllMajorsEmployed b
ON a.Major = b.Major and a.Major_category = b.Major_category
WHERE a.Major_category = 'Engineering'
ORDER BY 5 ASC

----------------- Salaries by Major/Career Path -----------------------------

SELECT * FROM CollegeData..SalaryByMajor

-- shows majors/careers that have the highest median starting salaries (career paths that start out at the top of the salary pyramid)
SELECT Major, StartingSalary FROM CollegeData..SalaryByMajor
ORDER BY StartingSalary DESC
-- shows majors/careers that have the highest median mid-career salaries (career paths that pay off after experience)
SELECT Major, MidCareerSalary FROM CollegeData..SalaryByMajor
ORDER BY MidCareerSalary DESC
-- shows majors/careers that have the largest increase for change in salary from start to mid-career
SELECT * FROM CollegeData..SalaryByMajor
ORDER BY PercentChange DESC

-- JOIN salary data with AllMajorsEmployed to combine salaries with unemployment numbers
-- In order to JOIN, we need to change the column name CollegeMajor in SalaryByMajor table to just "Major" to match AllMajorsEmployed
---- MySQL code:
ALTER TABLE SalaryByMajor 
RENAME COLUMN CollegeMajor TO Major
---- SQLServer Transact SQL code: 
sp_rename 'SalaryByMajor.CollegeMajor', 'Major', 'COLUMN'

SELECT a.Major, a.StartingSalary, a.MidCareerSalary, b.UnemploymentRate
FROM CollegeData..SalaryByMajor a
JOIN CollegeData..AllMajorsEmployed b
ON a.Major = b.Major 
ORDER BY StartingSalary DESC

--Engineering majors that have the highest median starting salaries vs the amount of students actually employed post-grad
SELECT TOP 6 a.Major, a.Employed, a.Unemployed, b.StartingSalary
FROM CollegeData..AllMajorsEmployed a
JOIN CollegeData..SalaryByMajor b ON a.Major = b.Major
WHERE a.Major LIKE '%Engineering%'
ORDER BY StartingSalary DESC

----------------- Salaries by College Institution/Location -----------------------

SELECT * FROM CollegeData..SalaryByCollege

-- shows type of college vs average starting & mid-career salaries for each type of institution
SELECT CollegeType, AVG(CAST(StartingSalary AS INT)) as AvgStartingSalary, AVG(CAST(MidCareerSalary AS INT)) as AvgMidCareerSalary
FROM CollegeData..SalaryByCollege
GROUP BY CollegeType
ORDER BY 2 DESC

-- shows avg starting salaries by college location, starting with highest salaries first
SELECT Location, AVG(CAST(StartingSalary AS INT)) as AvgStartingSalary
FROM CollegeData..SalaryByCollege
GROUP BY location
ORDER BY 2 DESC

-- college type vs avg starting salaries after graduating from a college in MA
SELECT CollegeType, AVG(CAST(StartingSalary AS INT)) as AvgStartingSalary
FROM CollegeData..SalaryByCollege
WHERE Location = 'MA'
GROUP BY CollegeType
ORDER BY 2 DESC

-- college type vs avg starting salaries after graduating from a college in CA
-- Did you know there are no Ivy League schools in CA??
SELECT CollegeType, AVG(CAST(StartingSalary AS INT)) as AvgStartingSalary
FROM CollegeData..SalaryByCollege
WHERE Location = 'CA'
GROUP BY CollegeType
ORDER BY 2 DESC

-- college type vs avg starting salaries after graduating from a college in NY
SELECT CollegeType, AVG(CAST(StartingSalary AS INT)) as AvgStartingSalary
FROM CollegeData..SalaryByCollege
WHERE Location = 'NY'
GROUP BY CollegeType
ORDER BY 2 DESC

-- top 10 U.S. colleges median Starting salaries
SELECT TOP 10 CollegeName, StartingSalary
FROM CollegeData..SalaryByCollege
GROUP BY CollegeName, StartingSalary
ORDER BY 2 DESC

-- top 10 Massachusetts colleges median Starting salaries
SELECT TOP 10 CollegeName, StartingSalary
FROM CollegeData..SalaryByCollege
WHERE Location = 'MA'
GROUP BY CollegeName, StartingSalary
ORDER BY 2 DESC

-- All Ivy League colleges median starting salaries & mid-career salaries
SELECT CollegeName, StartingSalary, MidCareerSalary
FROM CollegeData..SalaryByCollege
WHERE CollegeType = 'Ivy League'
GROUP BY CollegeName, StartingSalary, MidCareerSalary
ORDER BY 2 DESC
-- Interesting finding in this data:
-- Ivy league schools do not yield the highest salaries post-grad, but in fact Private Engineering colleges do