----------------- oSA Opp Decline -------------------

------------ Simple data cleaning/standardizing ----------------------
-- sorting through column header names to meet sql criteria and simplifying lengthy column names
SELECT * FROM OSAStats..Master_SA
SELECT SUBSTRING(SalesRegion, CHARINDEX('-', SalesRegion)+1, LEN(SalesRegion)) as OBDRRegion
FROM OSAStats..Master_SA
-- Since Sales Region always starts with 'Outbound BDR - ', removed this in each column to only show region and reduce repetition

-- Creating a new column oBDRregion to reflect this and deleting SalesRegion
ALTER TABLE Master_SA
ADD OBDRRegion Nvarchar(255)
UPDATE Master_SA
SET OBDRRegion = SUBSTRING(SalesRegion, CHARINDEX('-', SalesRegion)+1, LEN(SalesRegion))
ALTER TABLE Master_SA
DROP COLUMN SalesRegion

------- Calculating the Win Rate for Outbound Sales Associates (every row)
--- Win Rate = (Total Won Opps / Total Opps)

-- have to use ISNULL/NULLIF due to "unable to divide by zero" error
SELECT *,
ISNULL(TotalWins / NULLIF(TotalOpps,0),0)*100 as WinRate
FROM OSAStats..Master_SA

--- Average Win Rate grouped by Month
SELECT Date,
ISNULL(AVG(TotalWins) / NULLIF(AVG(TotalOpps),0),0)*100 as AvgWinRate
FROM OSAStats..Master_SA
GROUP BY Date
ORDER BY Date
--- Max Win Rate by Month
SELECT Date,
ISNULL(MAX(TotalWins) / NULLIF(MAX(TotalOpps),0),0)*100 as MaxWinRate
FROM OSAStats..Master_SA
GROUP BY Date
ORDER BY Date


--------------------- MAIN EXERCISE ---------------------
------- Opportunities Created per working day for oSA's -----

-- Total Opportunities Created by Month
SELECT Date, SUM(TotalOpps) as TotalOppsMonthly
FROM OSAStats..Master_SA
GROUP BY Date
ORDER BY Date

ALTER TABLE OSAStats..Master_SA
ADD AvgOppsPerDay Float
UPDATE OSAStats..Master_SA
SET AvgOppsPerDay = (TotalOpps/TotalWorkingDays)
FROM OSAStats..Master_SA a
JOIN OSAStats..Master_Dates b
ON a.Date = b.Date
--- now the table is populated with Avg Opps per working day per specific oSA for every row
SELECT * FROM OSAStats..Master_SA

-- Need the Avg Opportunities per working day per oSA, so we need to count the number of employees each month
SELECT DISTINCT COUNT(EmployeeName) as oSACount, Date
FROM OSAStats..Master_SA
GROUP BY Date
ORDER BY Date
-- Started from 78 oSA's in Jan 2019 to 195 in October 2019, steady increase in employee count
-- Since more employees (oSA's) were hired each month over the course of the year, the avg opportunities available for each oSA per day decreases 
--even though the amount of total opportunities increases each month

SELECT DISTINCT COUNT(EmployeeName) as oSACount, Date
FROM OSAStats..Master_SA
WHERE OfficeLocation = 'Boston'
GROUP BY Date
ORDER BY Date

SELECT DISTINCT COUNT(EmployeeName) as oSACount, Date
FROM OSAStats..Master_SA
WHERE OfficeLocation = 'Omaha'
GROUP BY Date
ORDER BY Date
-- a lot more employees hired in Boston than Omaha 

-- JOINing the Master_Dates table with Master_SA to get the total avg opportunities per working day per oSA grouped by month
SELECT a.Date, (SUM(TotalOpps/TotalWorkingDays))/(COUNT(DISTINCT EmployeeName)) as TotalOppsPerWorkingDayPerOSA
FROM OSAStats..Master_SA a
JOIN OSAStats..Master_Dates b
ON a.Date = b.Date
GROUP BY a.Date
ORDER BY 1
-- now we have the Opps per working day per oSA, and we can see that it's declining


------------------- Extra Stats -------------------

--- Looking at average connect rates, show rates and win rates per month
SELECT Date, AVG(ConnectRate)*100 as AvgConnectRate, AVG(ShowRate)*100 as AvgShowRate, 
ISNULL(AVG(TotalWins) / NULLIF(AVG(TotalOpps),0),0)*100 as AvgWinRate, AVG(AvgOppsPerDay) as AvgOppsPerDay
FROM OSAStats..Master_SA
GROUP BY Date
ORDER BY Date

--- Rates per month by office Location
SELECT Date, AVG(ConnectRate)*100 as AvgConnectRate, AVG(ShowRate)*100 as AvgShowRate, 
ISNULL(AVG(TotalWins) / NULLIF(AVG(TotalOpps),0),0)*100 as AvgWinRate, AVG(AvgOppsPerDay) as AvgOppsPerDay
FROM OSAStats..Master_SA
WHERE OfficeLocation = 'Boston'
GROUP BY Date
ORDER BY Date

SELECT Date, AVG(ConnectRate)*100 as AvgConnectRate, AVG(ShowRate)*100 as AvgShowRate, 
ISNULL(AVG(TotalWins) / NULLIF(AVG(TotalOpps),0),0)*100 as AvgWinRate, AVG(AvgOppsPerDay) as AvgOppsPerDay
FROM OSAStats..Master_SA
WHERE OfficeLocation = 'Omaha'
GROUP BY Date
ORDER BY Date

-- total opps per working day per oSA in the Boston office
SELECT a.Date, (SUM(TotalOpps/TotalWorkingDays))/(COUNT(DISTINCT EmployeeName)) as TotalOppsPerWorkingDayPerOSA
FROM OSAStats..Master_SA a
JOIN OSAStats..Master_Dates b
ON a.Date = b.Date
WHERE OfficeLocation = 'Boston'
GROUP BY a.Date
ORDER BY 1

-- total opps per working day per oSA in the Omaha office
SELECT a.Date, (SUM(TotalOpps/TotalWorkingDays))/(COUNT(DISTINCT EmployeeName)) as TotalOppsPerWorkingDayPerOSA
FROM OSAStats..Master_SA a
JOIN OSAStats..Master_Dates b
ON a.Date = b.Date
WHERE OfficeLocation = 'Omaha'
GROUP BY a.Date
ORDER BY 1

-- Total Opps for oSA's grouped by Region Manager
-- this will show which managers yielded the most opportunities per working day for each oSA
SELECT a.ManagerName, (SUM(TotalOpps/TotalWorkingDays))/(COUNT(DISTINCT EmployeeName)) as TotalOppsPerWorkingDayPerOSA
FROM OSAStats..Master_SA a
JOIN OSAStats..Master_Dates b
ON a.Date = b.Date
GROUP BY a.ManagerName
ORDER BY 2 DESC

-- this shows which managers yielded the highest avg connect rates, show rates, and total wins for oSA's through the year
SELECT ManagerName, AVG(ConnectRate)*100 as AvgConnectRate, AVG(ShowRate)*100 as AvgShowRate, SUM(TotalWins) as TotalWins
FROM OSAStats..Master_SA
GROUP BY ManagerName
ORDER BY 4 DESC

-- Looking into sales stats showing how successful oSA's are when they're paired with 2 AE's
SELECT a.Date, SUM(TotalWins) as TotalWins, (SUM(TotalOpps/TotalWorkingDays))/(COUNT(DISTINCT EmployeeName)) as TotalOppsPerWorkingDayPerOSA
FROM OSAStats..Master_SA a
JOIN OSAStats..Master_Dates b
ON a.Date = b.Date
WHERE RepB IS NOT NULL
GROUP BY a.Date
ORDER BY 1

-- Looking into sales stats showing how successful oSA's are when they're paired with 1 AE
SELECT a.Date, SUM(TotalWins) as TotalWins, (SUM(TotalOpps/TotalWorkingDays))/(COUNT(DISTINCT EmployeeName)) as TotalOppsPerWorkingDayPerOSA
FROM OSAStats..Master_SA a
JOIN OSAStats..Master_Dates b
ON a.Date = b.Date
WHERE RepB IS NULL
GROUP BY a.Date
ORDER BY 1
-- Conclusion: Sales rates for SA's are much higher when they are paired with 2 AE's rather than 1
-- In both cases, total oops per working day are declining over the year


-- Total count of Ramped employees vs Unramped employees
SELECT DISTINCT RampStatus, COUNT(RampStatus) as Total
FROM OSAStats..Master_SA
GROUP BY RampStatus

-- Count of Ramped oSA's grouped by month
SELECT Date, COUNT(RampStatus) as TotalRamped
FROM OSAStats..Master_SA
WHERE RampStatus = 'Ramped'
GROUP BY Date
ORDER BY 1

-- Count of Unramped oSA's grouped by month
SELECT Date, COUNT(RampStatus) as TotalUnramped
FROM OSAStats..Master_SA
WHERE RampStatus = 'Unramped'
GROUP BY Date
ORDER BY 1

--- shows on average the oSA opportunities declining from the start of 2019 to the end
SELECT Date, AVG(TotalOpps) as AvgOpps
FROM OSAStats..Master_SA
GROUP BY Date
ORDER BY Date

--- shows on average the AE opportunities declining from the start of 2019 to the end
SELECT Date, AVG(TotalOpps) as AvgOpps
FROM OSAStats..Master_AE
GROUP BY Date
ORDER BY Date

-- shows avg opportunities grouped by oSA role progression (SA 1 vs SA 2 vs SA 3)
SELECT Date, Role, AVG(TotalOpps) as AvgOpps
FROM OSAStats..Master_SA
GROUP BY Date, Role
ORDER BY Date

-- Looking into Total Opportunities for Ramped Employees that are holding quota
SELECT * FROM OSAStats..Master_SA
WHERE RampStatus = 'Ramped'
ORDER BY Date, TotalOpps DESC

-- Total Opps for Ramped oSA's based on their Role and Tenure at the company, grouped by month
SELECT Role, SUM(TotalOpps), AVG(Tenure), AVG(WinRate)
FROM OSAStats..Master_SA
--WHERE RampStatus = 'Ramped'
GROUP BY Role
ORDER BY 2 DESC

-- Total Opps and Total Wins for Ramped AE's, grouped by role
SELECT Date, AVG(TotalOpps) as AvgOpps, AVG(TotalWins) as AvgWins
FROM OSAStats..Master_AE
WHERE RampStatus = 'Ramped'
GROUP BY Date
ORDER BY Date

