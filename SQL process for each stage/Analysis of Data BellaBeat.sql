-- 1. Work out average daily steps from dailyactivity
SELECT avg(TotalSteps) FROM dailyactivity;				-- the average steps being 7638 to 1.d.p.
SELECT max(TotalSteps) FROM dailyactivity;				-- the max daily steps is 36019
SELECT min(TotalSteps) FROM dailyactivity;				-- minimum shows as 0, so i will investigate this observation

-- There are 4 observations/days which were not tracked at all across 4 different individuals
-- There are also 77/940 records where 0 total steps were recorded.
SELECT * FROM dailyactivity								-- I inserted count to determine how many observations did not record their total steps
WHERE TotalSteps = 0
ORDER BY Calories ASC;

-- Determine how many participants didn't record totalsteps 
SELECT count(DISTINCT(Id)) FROM dailyactivity			-- 15/33 participants did not track one or more days of their dailyactivity. 
WHERE TotalSteps = 0

SELECT count(DISTINCT(Id)) FROM dailyactivity             -- 25/33 participants exceeded the recommended daily steps of 10,000 with 303 observations in total, cont.
WHERE TotalSteps > 10000;

SELECT count(*) FROM dailyactivity					     	-- cont. with 303/940 observations in total
WHERE TotalSteps > 10000;

-- 2. What days are users the most active and what days are users the least active
-- Create a new table with relevant dailyactivity information and add a column called 'day' to describe what day each observation is.
CREATE TABLE dailyactivitywithdayname
SELECT d.Id, d.ActivityDate, d.TotalSteps, d.TotalDistance, d.SedentaryMinutes, d.VeryActiveMinutes
FROM dailyactivity d;

ALTER TABLE dailyactivitywithdayname
ADD COLUMN day text;

UPDATE dailyactivitywithdayname
SET day=dayname(ActivityDate);  							-- column day has been updated with day name using Activity Date.

SELECT DAY, AVG(TotalSteps) FROM dailyactivitywithdayname 	-- On average Saturday is the most active day with users achieving 8153 steps
GROUP BY day												-- On average Sunday is least active day with users achieving 6933 steps
ORDER BY AVG(Totalsteps) DESC;

-- 3. How many calories do users burn on average
SELECT avg(calories) FROM dailyactivity;						-- 2304 calories are burned on average by users 

-- 4.  Determine if tracker distance and total distance match
-- As there is not much context provided for these columns, i will not provide recommendations regarding distance
SELECT * FROM dailyactivity
WHERE trackerdistance <> totaldistance;  -- this shows that are 14 records do not meet this criteria

-- 5. Validation check for Total distance SUM for dailyactivity
-- 251/940 rows show that the SUM of column does not equal TotalDistance
-- 256/940 rows show that the SUM of column does not equal TrackerDistance
SELECT COUNT(*) FROM dailyactivity
WHERE (VeryActiveDistance + ModeratelyActiveDistance + LightActiveDistance) <> TotalDistance;

SELECT COUNT(*) FROM dailyactivity
WHERE (VeryActiveDistance + ModeratelyActiveDistance + LightActiveDistance) <> TrackerDistance;

-- 6. Check average VeryActiveMinutes
SELECT avg(VeryActiveMinutes) FROM dailyactivity;				-- 21 minutes is the average VeryActiveMinutes of activity

-- 7. Check average SedentaryMinutes
SELECT avg(SedentaryMinutes) FROM dailyactivity;  				-- 991 minutes is the average SedentaryMinutes of activity

-- 8. How many users work out for 60 minutes or more if they have SedentaryMinutes of more than 991 minutes
-- 12/33 users on average carry out more than 60 minutes of activity if they are sedentary for more than 991 minutes per day.
SELECT Count(*) FROM dailyactivity
WHERE SedentaryMinutes >991 AND VeryActiveMinutes >60; 		

-- 9. Create a new table dailyactivitywithsleep joining dailyactivity and sleepday together
CREATE TABLE dailyactivitywithsleep AS
SELECT da.Id,da.ActivityDate, da.TotalSteps,da.SedentaryMinutes,da.VeryActiveMinutes,da.Calories, 
sd.TotalMinutesAsleep,sd.TotalSleepRecords,sd.TotalTimeInBed 
FROM dailyactivity da
INNER JOIN sleepday sd
ON da.Id = sd.Id AND da.ActivityDate = sd.SleepDate;

				
-- 10. Create a new table hourlyintensities by joining hourlyintensities and hourlysteps tables together 
CREATE TABLE hourlyintensitiesandsteps 
SELECT hi.Id, hi.ActiveDate, hi.ActiveHour, hi.TotalIntensity, hi.AverageIntensity, hs.StepTotal
FROM hourlyintensities hi
INNER JOIN hourlysteps hs
ON hi.Id = hs.Id AND hi.ActiveDate = hs.ActiveDate AND hi.ActiveHour = hs.ActiveHour;

-- 11. What hour is most popular for activity
SELECT avg(StepTotal) FROM hourlyintensitiesandsteps; 				-- average is 320 steps an hour for users
-- Calculate sum of step total for each hour to determine hour of most activity.
-- 18:00 is the hour of most activity by users with 03:00 being the hours of least activity 
SELECT ActiveHour, sum(StepTotal) 
FROM hourlyintensitiesandsteps
WHERE StepTotal >=320 
GROUP BY ActiveHour
ORDER BY sum(StepTotal) DESC;

-- 12. Calculate average BMI of participants in weightloginfo
SELECT avg(BMI) FROM weightloginfo;					-- 25.2 to 1.d.p is the average BMI of the 8 participants in weightloginfo

