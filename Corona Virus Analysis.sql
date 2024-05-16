-- Q1. Write a code to check NULL values
SELECT *
FROM [Corona Virus Dataset]
WHERE 
    Province IS NULL
    OR [Country Region] IS NULL
    OR Latitude IS NULL
    OR Longitude IS NULL
    OR Date IS NULL
    OR Confirmed IS NULL
    OR Deaths IS NULL
    OR Recovered IS NULL;

--Q2. If NULL values are present, update them with zeros for all columns. 
UPDATE 
    [Corona Virus Dataset]
SET 
    Province = COALESCE(Province,'Not Applicable' ),
    [Country Region] = COALESCE([Country Region], 'Not Applicable'),
    Latitude = COALESCE(Latitude, 0),
    Longitude = COALESCE(Longitude, 0),
    Date = COALESCE(Date, '0000-00-00'),
    Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0);
-- Q3. check total number of rows
SELECT  COUNT(*) AS total_rows
FROM [Corona Virus Dataset];

-- Q4. Check what is start_date and end_date
SELECT 
    MIN(Date) AS start_date,
    MAX(Date) AS end_date
FROM [Corona Virus Dataset];
-- Q5. Number of month present in dataset
SELECT year(date) as year,count(distinct month(date)) as month_count
FROM [Corona Virus Dataset]
group by year(date)
-- Q6. Find monthly average for confirmed, deaths, recovered
SELECT year(date) as year,month(date) as month,avg(Confirmed) as avg_confirmed,avg(Deaths) as avg_deaths,avg(Recovered) as avg_recovered
FROM [Corona Virus Dataset]
group by year(date),month(date)
order by 1 asc,2 asc 
-- Q7. Find most frequent value for confirmed, deaths, recovered each month 
SELECT 
    MonthDate AS Month,
    (
        SELECT TOP 1 Confirmed
        FROM [Corona Virus Dataset]
        WHERE CONVERT(date, Date) = MonthlyMode.MonthDate
        GROUP BY Confirmed
        ORDER BY COUNT(*) DESC
    ) AS MostFrequentConfirmed,
    (
        SELECT TOP 1 Deaths
        FROM [Corona Virus Dataset]
        WHERE CONVERT(date, Date) = MonthlyMode.MonthDate
        GROUP BY Deaths
        ORDER BY COUNT(*) DESC
    ) AS MostFrequentDeaths,
    (
        SELECT TOP 1 Recovered
        FROM [Corona Virus Dataset]
        WHERE CONVERT(date, Date) = MonthlyMode.MonthDate
        GROUP BY Recovered
        ORDER BY COUNT(*) DESC
    ) AS MostFrequentRecovered
FROM (
    SELECT DISTINCT CONVERT(date, Date) AS MonthDate
    FROM [Corona Virus Dataset]
) AS MonthlyMode;
-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT 
    YEAR(Date) AS year,
    MIN(Confirmed) AS min_confirmed,
    MIN(Deaths) AS min_deaths,
    MIN(Recovered) AS min_recovered
FROM [Corona Virus Dataset]
GROUP BY YEAR(Date)
-- Q9. Find maximum values of confirmed, deaths, recovered per year
SELECT 
    YEAR(Date) AS year,
    MAX(Confirmed) AS max_confirmed,
    MAX(Deaths) AS max_deaths,
    MAX(Recovered) AS max_recovered
FROM 
    [Corona Virus Dataset]
GROUP BY 
    YEAR(Date);
-- Q10. The total number of case of confirmed, deaths, recovered each month
SELECT 
    year(date) AS year,
	month(date) AS month,
    SUM(Confirmed) AS total_confirmed,
    SUM(Deaths) AS total_deaths,
    SUM(Recovered) AS total_recovered
FROM [Corona Virus Dataset]
GROUP BY year(date) , month(date)
order by 1 asc,2 asc;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
   year(date) AS year,
	month(date) AS month,
    sum(Confirmed) AS total_confirmed,
    AVG(Confirmed) AS avg_confirmed,
    round(VAR(Confirmed),2) AS variance_confirmed,
    round(STDEV(Confirmed),2) AS stdev_confirmed
FROM 
    [Corona Virus Dataset]
GROUP BY  year(date),month(date)
order by 1 asc,2 asc;
-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
   year(date) AS year,
	month(date) AS month,
    sum(Deaths) AS total_deaths,
    AVG(Deaths) AS avg_deaths,
    round(VAR(Deaths),2) AS variance_deaths,
    round(STDEV(Deaths),2) AS stdev_deaths
FROM 
    [Corona Virus Dataset]
GROUP BY  year(date),month(date)
order by 1 asc,2 asc;
-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
   year(date) AS year,
	month(date) AS month,
    sum(Recovered) AS total_recovered,
    AVG(Recovered) AS avg_recovered,
    round(VAR(Recovered),2) AS variance_recovered,
    round(STDEV(Recovered),2) AS stdev_recovered
FROM 
    [Corona Virus Dataset]
GROUP BY  year(date),month(date)
order by 1 asc,2 asc;
-- Q14. Find Country having highest number of the Confirmed case
SELECT top 1 [Country Region]
FROM [Corona Virus Dataset]
group by [Country Region]
order by sum(confirmed) desc
-- Q15. Find Country having lowest number of the death case
SELECT top 1 [Country Region]
FROM [Corona Virus Dataset]
group by [Country Region]
order by sum(Deaths) asc
-- Q16. Find top 5 countries having highest recovered case
SELECT top 5 [Country Region]
FROM [Corona Virus Dataset]
group by [Country Region]
order by sum(Recovered) desc