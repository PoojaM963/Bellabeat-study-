Bellabeat-study-
# How can a wellness technology company play it smart?

## About the company - Bellabeat

Urška Sršen and Sando Mur founded ‘Bellabeat’ in 2013. This company manufactures health-focused products for women, collecting data on activity, sleep, stress and reproductive health. This data then provides a clearer outlook about health and habits to its users. Urška Sršen believes that Bellabeat has the potential to become a larger competitor in the global smart device market by analysing smart device fitness data, in order to gain valuable insight into how consumers use their smart devices.

As Junior Data Analyst, part of the marketing analyst team at Bellabeat, we’ve been asked to focus on one Bellabeat product and analyse smart device usage data. Any insights will therefore help to guide marketing strategy for the company. We must present to Bellabeat’s executive team along with high-level recommendations for Bellabeat’s marketing strategy.

## ASK: Statement of Business Task
Analyse smart device usage data in order to gain insights into how consumers use non-Bellabeat smart devices. Select one Bellabeat product to apply these insights to in your presentation to help guide marketing strategy for the company – the product I will focus on is ‘Leaf’. This is a wellness tracker, worn as bracelet, necklace or clip and connects to the Bellabeat app to track activity, sleep and stress. 
Stakeholders: Urška Sršen (Co-founder and CCO) and Sando Mur (Co-founder, key member of executive team)
Questions to answer during analysis:
### 1. What are some trends in smart device usage?
### 2. How could these trends apply to Bellabeat customers?
### 3. How could these trends help influence Bellabeat marketing strategy?

## PREPARE: Description of data sources used
The data which will be used for analysis comes from a public Kaggle dataset uploaded by Mobius - FitBit Fitness Tracker Data . These datasets were generated from surveys via Amazon Mechanical Turk of thirty eligible FitBit users - who have consented to the submission of personal tracker data including minute-level output for physical activity, heart rate, and sleep monitoring. Data collected ranges from 03/12/2016 – 05/12/2016 and acknowledgements include Furberg, Robert; Brinton, Julia; Keating, Michael; Ortiz, Alexa. 
The datasets come in the form of 18 CSV files including both long and wide formats and will be stored within a personal document folder upon my device. There may be some limitation so an addition of another dataset may help to address these.

### Limitations to consider (ROCCC):
+	Sample size – With a low confidence interval, a sample size of 30 is not sufficient to represent a population – unreliable.
+	Omission of data – Some participants didn’t wear their device for the 30 days and not all sleep records for users was collected and recorded
+	Historic data – Data collected ranges from 03/12/2016 – 05/12/2016, data is outdated and not current.
+	Duration of data collection – data is only representative of one month of the whole year.
+ Lack of demographic information – age, location and gender not recorded, this information could help clear up any bias when it came to analysis and recommendations.
+	Survey – data may not be entirely accurate as reported by users themselves and collected by unknown third party.

I will be using 5 of the 13 datasets as they contain information that will be most useful in providing insights. From a quick inspection using excel, I decided the datasets I will use are as follows: 
-	dailyactivity
-	sleepday
-	hourlyintensities
-	hourlysteps 
-	weightloginfo

Tools used: MySQL Workbench 8.0 to clean and analyse data as some datasets were too large to be used with Excel. I will then use Tableau for initial exploration of the data set and to create a static visualisation describing trends and using these insights to provide recommendations.

## PROCESS: Cleaning and transforming data
-- 1. Check that all rows of csv files have been imported to MySQL workbench
Prior to importing these files successfully, I faced some importation issues (all rows of datasets were not being imported) with the import wizard’s chosen datatype INT for column, ‘Id’ of some tables. I changed the datatype INT to BIGINT for columns ‘Id’ this allowed for larger values for this column to be imported. 

```
-- 1. Check all rows of .CSV files have been imported to MySQL workbench
SELECT COUNT(*) FROM dailyactivity;        -- All 940 rows were imported successfully
SELECT COUNT(*) FROM hourlyintensities;    -- All 22099 rows were imported successfully
SELECT COUNT(*) FROM hourlysteps;		        -- All 22099 rows were imported successfully
SELECT COUNT(*) FROM sleepday; 			         -- All 413 rows were imported successfully
SELECT COUNT(*) FROM weightloginfo;        -- All 67 rows were imported successfully
```
 
--2. Check to see how many unique participants there are per table 
There are limited numbers of participants in each table. 33 in dailyactivity, hourlyintensities, hourlysteps; 24 in sleepday and 8 in weightloginfo. This data isn’t sufficient to make confident decisions based on a whole population.
 
```
-- 2. Check how many unique participants (Id) per table
SELECT COUNT(distinct Id) AS totalparticipants
FROM dailyactivity; 						                            -- dailyactivity has 33 participants
SELECT COUNT(distinct Id) AS totalparticipants
FROM hourlyintensities;						                         -- hourlyintensities has 33 participants
SELECT COUNT(distinct Id) AS totalparticipants
FROM hourlysteps;							                              -- hourlysteps has 33 participants
SELECT COUNT(distinct Id) AS totalparticipants
FROM sleepday;								                                -- sleepday has 24 participants
SELECT COUNT(distinct Id) AS totalparticipants
FROM weightloginfo; 					                            	-- weightloginfo has 8 participants
```

-- 3. Check to see if data types for each column are appropriate and modifying where necessary
To stay consistent, I changed most data types for each column of each table, ensuring that any data which is present within two or more tables had the exact same data type. I could not change all datatypes at once so had to execute separate statements for each. I would otherwise have to create a new table as suggested by other users. I used %r to change the times from AM/PM to 24-hour format. I dropped columns with Date and Time after copying data into two separate columns within the tables. I also ensured that TotalTimeBed values made sense to be greater in number than TotalMinutesAsleep.
 
```
-- 3. Check datatypes for each column are appropriate and modifying where necessary
DESCRIBE dailyactivity;  
-- Default date format in MySQL is YYYY-MM-DD, I will change the format to conform to this.
-- This will change format of the date from mm/dd/yyyy to yyyy/mm/dd before I try and change datatype text to date.
UPDATE dailyactivity
SET ActivityDate=str_to_date(ActivityDate, '%m/%d/%Y');
-- Can now modify text to date and do a check to see if it has applied.
ALTER TABLE dailyactivity
MODIFY ActivityDate date;
DESCRIBE dailyactivity;
SELECT * FROM dailyactivity;
-- Change the remaining columns of dailyactivity to their appropriate datatypes. 
-- I changed the following from double to decimal(1.d.p)
ALTER TABLE dailyactivity MODIFY TotalDistance decimal(10,1);
ALTER TABLE dailyactivity MODIFY TrackerDistance decimal(10,1);
ALTER TABLE dailyactivity MODIFY LoggedActivitiesDistance decimal(10,1);
ALTER TABLE dailyactivity MODIFY VeryActiveDistance decimal(10,1);
ALTER TABLE dailyactivity MODIFY ModeratelyActiveDistance decimal(10,1);
ALTER TABLE dailyactivity MODIFY LightActiveDistance decimal(10,1);
ALTER TABLE dailyactivity MODIFY SedentaryActiveDistance decimal(10,1);
ALTER TABLE dailyactivity MODIFY VeryActiveDistance decimal(10,1);

-- Change datatypes for hourlyintensities
ALTER TABLE hourlyintensities MODIFY TotalIntensity decimal(10,1);
ALTER TABLE hourlyintensities MODIFY AverageIntensity decimal(10,1);
SELECT * FROM hourlyintensities;
-- Change ActivityHour format to conform to sql format and time to be in 24 format using %r(AM/PM) 
-- Convert Date datatype to datetime for ActivityHour 
UPDATE hourlyintensities
SET ActivityHour=str_to_date(ActivityHour, '%m/%d/%Y %r'); 
ALTER TABLE hourlyintensities
MODIFY ActivityHour datetime;

-- Create columns ActiveDate and ActiveHour in hourlyintensities table and what order
ALTER TABLE hourlyintensities
ADD COLUMN ActiveDate date AFTER Id;

ALTER TABLE hourlyintensities
ADD COLUMN ActiveHour time AFTER ActiveDate;

 -- Split date and time from ActivityHour column into ActiveDate and ActiveHour.
UPDATE hourlyintensities 
SET ActiveDate=SUBSTRING_INDEX(ActivityHour, ' ', 1), ActiveHour=SUBSTRING_INDEX(ActivityHour, ' ', -1);

-- DROP COLUMN ActivityHour as we have new columns with this information
ALTER TABLE hourlyintensities
DROP COLUMN ActivityHour;

-- Change datatypes for hourlysteps by same process as hourlyintensities to split up ActivityHour column into ActiveDate and ActiveHour
ALTER TABLE hourlysteps MODIFY Id bigint;
UPDATE hourlysteps
SET ActivityHour=str_to_date(ActivityHour, '%m/%d/%Y %r'); 
ALTER TABLE hourlysteps
MODIFY ActivityHour datetime;

ALTER TABLE hourlysteps
ADD COLUMN ActiveDate date AFTER Id;

ALTER TABLE hourlysteps
ADD COLUMN ActiveHour time AFTER ActiveDate;

UPDATE hourlysteps
SET ActiveDate=SUBSTRING_INDEX(ActivityHour, ' ', 1), ActiveHour=SUBSTRING_INDEX(ActivityHour, ' ', -1);

ALTER TABLE hourlysteps
DROP COLUMN ActivityHour;

-- Change datatypes for sleepday by same process as hourlyintensities/hourlysteps to split SleepDay into SleepDate and SleepHour
UPDATE sleepday
SET SleepDay=str_to_date(SleepDay, '%m/%d/%Y %r'); 
ALTER TABLE sleepday
MODIFY SleepDay datetime;

ALTER TABLE sleepday
ADD COLUMN SleepDate date AFTER Id;

ALTER TABLE sleepday
ADD COLUMN SleepHour time AFTER SleepDate;

UPDATE sleepday
SET SleepDate=SUBSTRING_INDEX(SleepDay, ' ', 1), SleepHour=SUBSTRING_INDEX(SleepDay, ' ', -1);

ALTER TABLE sleepday
DROP COLUMN SleepDay;

-- Change datatypes for weightloginfo by same process as hourlyintensities/hourlysteps and sleepday to split Date into WLIDate and WLITime
ALTER TABLE weightloginfo MODIFY WeightKg decimal(20,1);
ALTER TABLE weightloginfo MODIFY WeightPounds decimal(20,1);
ALTER TABLE weightloginfo MODIFY BMI decimal(20,1);

UPDATE weightloginfo
SET Date=str_to_date(Date, '%m/%d/%Y %r'); 
ALTER TABLE weightloginfo
MODIFY Date datetime;

ALTER TABLE weightloginfo
ADD COLUMN WLIDate date AFTER Id;

ALTER TABLE weightloginfo
ADD COLUMN WLITime time AFTER WLIDate;

UPDATE weightloginfo
SET WLIDate=SUBSTRING_INDEX(Date, ' ', 1), WLITime=SUBSTRING_INDEX(Date, ' ', -1);

ALTER TABLE weightloginfo
DROP COLUMN Date;

-- Check that TotalTimeInBed values are bigger >= TotalMinutesAsleep
-- I will add another column when it comes to analysis 
SELECT COUNT(*) FROM sleepday
WHERE TotalTimeInBed >= TotalMinutesAsleep; 		                    	-- All records agree with this statement
```
 
-- 4. Check duration of data for all tables
Ensured that data spanned across 30 days from '2016-04-12' and '2016-05-12'
 
```
-- 4. Check duration of data for all tables
-- Data recorded is across 30 days (2016-05-12 and 2016-04-12) within all tables 
SELECT min(ActivityDate), max(ActivityDate) FROM dailyactivity;                      -- Shows min date is 2016-04-12 and max date 2016-05-12
SELECT datediff('2016-05-12', '2016-04-12');					                                    -- Shows there is 30 days of data between those two dates
```

-- 5. Check Id characters are appropriate character lengths
I ensured all character lengths were consistent for each table (10 characters for Id) and 13 characters for LogId.

```
-- 5. Check Id characters are appropriate character lengths
SELECT 
Length(Id) AS length_of_id
FROM dailyactivity;  				               -- This shows that Id character length should be 10 for all tables

SELECT Id 
FROM dailyactivity
WHERE LENGTH(Id) <>10;                  -- All Id characters are of 10 characters

SELECT Id 
FROM hourlyintensities
WHERE LENGTH(Id) <>10;                  -- All Id characters are of 10 characters

SELECT Id 
FROM hourlysteps
WHERE LENGTH(Id) <>10;                  -- All Id characters are of 10 characters

SELECT Id 
FROM sleepday
WHERE LENGTH(Id) <>10;                  -- All Id characters are of 10 characters

SELECT Id 
FROM weightloginfo
WHERE LENGTH(Id) <>10;                  -- All Id characters are of 10 characters

-- For weightloginfo, there is a column with LogId which I will check for consistent character length
SELECT 
Length(LogId) AS lengthoflogid
FROM weightloginfo;  		                 -- This shows that there should be 13 characters per LogId

SELECT LogId
FROM weightloginfo
WHERE LENGTH(LogId) <>13;  			          -- All Id characters are of 13 characters
```

-- 6. Check for duplicate rows
I created a primary key which automatically incremented from 1 for all rows of sleepday. This allowed for a unique identifier as there are many duplicate fields (as one Id would have multiple observations) to easily identify rows of duplicates to delete them from the table. 3 row duplicates were found. After removing duplicates, the PID column was dropped.

```
-- 6. Check for duplicate rows 
-- in dailyactivity
SELECT 
Id, 
ActivityDate, 
TotalSteps, 
TotalDistance, 
TrackerDistance, 
LoggedActivitiesDistance, 
VeryActiveDistance,
SedentaryMinutes, 
ModeratelyActiveDistance, 
LightActiveDistance, 
SedentaryActiveDistance, 
VeryActiveMinutes, 
FairlyActiveMinutes, 
LightlyActiveMinutes, 
SedentaryMinutes, 
Calories, 
COUNT(*)
FROM dailyactivity
GROUP BY 
Id, 
ActivityDate, 
TotalSteps, 
TotalDistance, 
TrackerDistance, 
LoggedActivitiesDistance, 
VeryActiveDistance,
SedentaryMinutes, 
ModeratelyActiveDistance, 
LightActiveDistance, 
SedentaryActiveDistance, 
VeryActiveMinutes, 
FairlyActiveMinutes, 
LightlyActiveMinutes, 
SedentaryMinutes, 
Calories
HAVING COUNT(*) >1;    					        	-- there are no duplicate rows within dailyactivity

-- Check for duplicate rows in hourlyintensities
SELECT Id, ActiveDate, ActiveHour, TotalIntensity, AverageIntensity, COUNT(*)
FROM hourlyintensities
GROUP BY Id, ActiveDate, ActiveHour, TotalIntensity, AverageIntensity
HAVING COUNT(*) >1;							          	-- there are no duplicate rows within hourlyintensities

-- Check for duplicate rows in hourlysteps
SELECT Id, ActiveDate, ActiveHour, StepTotal, COUNT(*)
FROM hourlysteps
GROUP BY Id, ActiveDate, ActiveHour, StepTotal
HAVING COUNT(*) >1;								         -- there are no duplicate rows within hourlysteps

-- Check for duplicate rows in sleepday
SELECT Id, SleepDate, SleepHour, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed, COUNT(*)
FROM sleepday
GROUP BY Id, SleepDate, SleepHour, TotalSleepRecords, TotalMinutesAsleep, TotalTimeInBed
HAVING COUNT(*) >1; 							         -- there are 3 rows with duplicates 

ALTER TABLE sleepday
ADD PID int AUTO_INCREMENT PRIMARY KEY;  		   -- Auto increment primary key gives each row a unique identifier

SELECT * FROM sleepday
WHERE Id = '4388161847' AND TotalTimeInBed = 495;  -- this confirms that the rows are duplicate

SELECT * FROM sleepday
WHERE Id = '4702921684' AND TotalTimeInBed = 543;  -- this confirms that the rows are duplicate

SELECT * FROM sleepday
WHERE Id = '8378563200' AND TotalTimeInBed = 402;  -- this confirms that the rows are duplicate

-- Using the unique identifier for each duplicate row, I removed the duplicate
DELETE FROM sleepday WHERE PID IN (19, 249, 380);  

-- Drop the column used to remove duplicates 
ALTER TABLE sleepday
DROP COLUMN PID;
SELECT COUNT(*) FROM sleepday; 					                                                        -- Now there are 410 rows in sleepday rather than 413

-- Check for duplicate rows in weightloginfo
SELECT Id, WLIDate, WLITime, WeightKg, WeightPounds, Fat, BMI, ISManualReport, LogId, COUNT(*)
FROM weightloginfo
GROUP BY Id, WLIDate, WLITime, WeightKg, WeightPounds, Fat, BMI, ISManualReport, LogId
HAVING COUNT(*) >1;								                                                                 -- there are no duplicate rows within weightloginfo	
```
-- 7. Check for NULL or missing values
weightloginfo table was the only table with missing values in 65/67 rows within the column ‘Fat’. I will consider this when carrying out analysis.

```
-- 7. Check for NULL or missing values 
-- weightloginfo was the only table that displayed missing values, there were no NULLS (65/67 records), when it comes to analysis, i will not being using the FAT column.
SELECT * FROM weightloginfo
WHERE Id IS NULL OR Id = ''
OR WLIDate IS NULL 
OR WLITime IS NULL OR WLITime = ''
OR WeightKg IS NULL OR WeightKg = ''
OR WeightPounds IS NULL OR WeightPounds = ''
OR Fat IS NULL OR Fat = ''
OR BMI IS NULL OR BMI = ''
OR IsManualReport IS NULL OR IsManualReport = ''
OR LogID IS NULL OR LogID = '';
```
 
## ANALYZE: finding trends and relationships, performing calculations and organising data
-- 1. Work out average, minimum and maximum daily steps from dailyactivity
These calculations were executed, and I discovered that the minimum total steps = 0. The only possible reasoning being that total steps were not tracked. I discovered that 77/940 observations had 0 total steps and 15/33 (almost half) of the participants did not track this information at least once during the period of tracking. The average steps equalled to 7638 which is well below the recommendation of 10,000 a day according to The American Heart Association.
 
```
-- 1. Work out average daily steps from dailyactivity
SELECT avg(TotalSteps) FROM dailyactivity;				-- the average steps being 7638 to 1.d.p.
SELECT max(TotalSteps) FROM dailyactivity;				-- the max daily steps is 36019
SELECT min(TotalSteps) FROM dailyactivity;				-- minimum shows as 0, so i will investigate this observation

-- There are 4 observations/days which were not tracked at all across 4 different individuals
-- There are also 77/940 records where 0 total steps were recorded.
SELECT * FROM dailyactivity								           -- I inserted count to determine how many observations did not record their total steps
WHERE TotalSteps = 0
ORDER BY Calories ASC;

-- Determine how many participants didn't record totalsteps 
SELECT count(DISTINCT(Id)) FROM dailyactivity	-- 15/33 participants did not track one or more days of their dailyactivity. 
WHERE TotalSteps = 0

SELECT count(DISTINCT(Id)) FROM dailyactivity -- 25/33 participants exceeded the recommended daily steps of 10,000 with 303 observations in total, cont.
WHERE TotalSteps > 10000;

SELECT count(*) FROM dailyactivity					     	 -- cont. with 303/940 observations in total
WHERE TotalSteps > 10000;
```
 
-- 2. What days are users the most active and what days are users the least active
I created a new table with a new column named ‘day name’. Here the day name for each date of the observation would be updated in the new column. From this, I could then calculate that Saturday is the day users are most active on averaging 8153 steps and Sunday is the day users were least active, averaging 6933 steps.

```
-- 2. What days are users the most active and what days are users the least active
-- Create a new table with relevant dailyactivity information and add a column called 'day' to describe what day each observation is.
CREATE TABLE dailyactivitywithdayname
SELECT d.Id, d.ActivityDate, d.TotalSteps, d.TotalDistance, d.SedentaryMinutes, d.VeryActiveMinutes
FROM dailyactivity d;

ALTER TABLE dailyactivitywithdayname
ADD COLUMN day text;

UPDATE dailyactivitywithdayname
SET day=dayname(ActivityDate);  							            -- column day has been updated with day name using Activity Date.

SELECT DAY, AVG(TotalSteps) FROM dailyactivitywithdayname 	-- On average Saturday is the most active day with users achieving 8153 steps
GROUP BY day												-- On average Sunday is least active day with users achieving 6933 steps
ORDER BY AVG(Totalsteps) DESC;
```

-- 3. How many calories do users burn on average
2304 calories are burned on average by users per day. According to performancelab, without exercise, people on average, burn 1800 calories. 2304 calories is a significant improvement by users. However, if users have a goal of losing weight, it is estimated that 3500 calories must be burned daily to burn a pound within a week (as suggested by menshealth.com).

```
-- 3. How many calories do users burn on average
SELECT avg(calories) FROM dailyactivity;						     -- 2304 calories are burned on average by users 
```
 
-- 4.  Determine if trackerdistance and totaldistance match and check the sum of varying distances to see if they match either trackerdistance/totaldistance
As there is not much context provided for these columns, I will not provide recommendations regarding distance as it shows that 14 records do not meet this criteria.

```
-- 4.  Determine if tracker distance and total distance match
-- As there is not much context provided for these columns, i will not provide recommendations regarding distance
SELECT * FROM dailyactivity
WHERE trackerdistance <> totaldistance;           -- this shows that are 14 records do not meet this criteria
```

-- 5. Validation check for Total distance SUM for dailyactivity
251/940 rows show that the SUM of column does not equal TotalDistance
256/940 rows show that the SUM of column does not equal TrackerDistance
As there are multiple observations which do not match the criteria, I decided not to use this information on distance to provide any insights as they may be inaccurate.
 
```
-- 5. Validation check for Total distance SUM for dailyactivity
-- 251/940 rows show that the SUM of column does not equal TotalDistance
-- 256/940 rows show that the SUM of column does not equal TrackerDistance
SELECT COUNT(*) FROM dailyactivity
WHERE (VeryActiveDistance + ModeratelyActiveDistance + LightActiveDistance) <> TotalDistance;

SELECT COUNT(*) FROM dailyactivity
WHERE (VeryActiveDistance + ModeratelyActiveDistance + LightActiveDistance) <> TrackerDistance;
```

-- 6. Check average VeryActiveMinutes 
21 minutes is the average VeryActiveMinutes of activity of users within this dataset per day. The CDC suggests a weekly 150 minutes of vigorous activity which equals on average 21 minutes a day. Users on average are meeting this requirement towards better physical health. 

```
-- 6. Check average VeryActiveMinutes
SELECT avg(VeryActiveMinutes) FROM dailyactivity;				-- 21 minutes is the average VeryActiveMinutes of activity
```
 
-- 7. Check average SedentaryMinutes 
-- 8. How many users work out for 60 minutes or more if they have SedentaryMinutes of more than 991 minutes
Users on average spend 991 minutes sedentary per day. Let’s say the recommended 8 hours of this time is dedicated to sleep, that leaves around another 8.5 hours of being sedentary. A new study reported by CBC states that those who sit for 8 hours, whether that be for work or just sitting can cause health risks and that 60 minutes of activity a day could offset this. To avoid assumptions, we have a table with information on users and their sleep, I created a new table (dailyactivitywithsleep) and used INNER JOIN to join relevant columns in dailyactivity with relevant columns from sleepday.

```
-- 7. Check average SedentaryMinutes
SELECT avg(SedentaryMinutes) FROM dailyactivity;  			-- 991 minutes is the average SedentaryMinutes of activity

-- 8. How many users work out for 60 minutes or more if they have SedentaryMinutes of more than 991 minutes
-- 12/33 users on average carry out more than 60 minutes of activity if they are sedentary for more than 991 minutes per day.
SELECT Count(*) FROM dailyactivity
WHERE SedentaryMinutes >991 AND VeryActiveMinutes >60; 		
```
 
-- 9. Create a new table detailing relevant columns from dailyactivity and sleepday
To avoid assumptions, we have a table with information on users and their sleep, I created a new table (dailyactivitywithsleep) and used INNER JOIN to join relevant columns in dailyactivity with relevant columns from sleepday resulting in 410 observations. Of these 410 observations, there are zero observations of users with >=991 SedentaryMinutes AND TotalMinutesAsleep >=480 AND VeryActiveMinutes >=60. This shows that users are not meeting the sleep and exercise recommendations as set by CBC for people who spend more than 8 hours sedentary per day. They are not sleeping enough and not carrying out enough exercise. 

```
-- 9. Create a new table dailyactivitywithsleep joining dailyactivity and sleepday together
CREATE TABLE dailyactivitywithsleep AS
SELECT da.Id,da.ActivityDate, da.TotalSteps,da.SedentaryMinutes,da.VeryActiveMinutes,da.Calories, 
sd.TotalMinutesAsleep,sd.TotalSleepRecords,sd.TotalTimeInBed 
FROM dailyactivity da
INNER JOIN sleepday sd
ON da.Id = sd.Id AND da.ActivityDate = sd.SleepDate;
```
 
-- 10. Create a new table hourlyintensities by joining hourlyintensities and hourlysteps tables together
A new table hourlyintensitiesandsteps was created to allow for easier and clearer analysis of both data. 

```
-- 10. Create a new table hourlyintensities by joining hourlyintensities and hourlysteps tables together 
CREATE TABLE hourlyintensitiesandsteps 
SELECT hi.Id, hi.ActiveDate, hi.ActiveHour, hi.TotalIntensity, hi.AverageIntensity, hs.StepTotal
FROM hourlyintensities hi
INNER JOIN hourlysteps hs
ON hi.Id = hs.Id AND hi.ActiveDate = hs.ActiveDate AND hi.ActiveHour = hs.ActiveHour;
```

-- 11. What hour is most popular for activity
The average totalsteps was calculated to be 320 steps. To figure out which hours of the day were popular for activity. I used the average of 320 steps to filter out information for any observations recording less than 320 steps. 18:00 was the hour of the day where on average, users carried out the most activity. I also noted that 03:00 was the hour of least activity.

```
-- 11. What hour is most popular for activity
SELECT avg(StepTotal) FROM hourlyintensitiesandsteps; 				-- average is 320 steps an hour for users
-- Calculate sum of step total for each hour to determine hour of most activity.
-- 18:00 is the hour of most activity by users with 03:00 being the hours of least activity 
SELECT ActiveHour, sum(StepTotal) 
FROM hourlyintensitiesandsteps
WHERE StepTotal >=320 
GROUP BY ActiveHour
ORDER BY sum(StepTotal) DESC;
```
 
-- 12. Calculate average BMI of participants in weightloginfo
There is only information for 8 participants in weightloginfo as compared to 33 in dailyactivity so not all users have made use of this function. Information such as gender, age and height may have aided in a deeper analysis of this dataset. The average BMI is 25.2 which is overweight. BMI is also not an accurate measure for diagnosing body fat content. There may be different ethnicities as part of the study which hasn’t been clarified. Body fat distribution has been shown to vary between different ethnic/race groups as according to health.clevelandclinic.org. Only two observations recorded fat. The units were not confirmed and as it is such a small sample of the population of users, it is unnecessary to perform analysis on as it could inaccurately represent the data.

```
-- 12. Calculate average BMI of participants in weightloginfo
SELECT avg(BMI) FROM weightloginfo;				                         	-- 25.2 to 1.d.p is the average BMI of the 8 participants in weightloginfo
```

I noticed within the dataset ‘hourlyintensitiesandsteps’ that as the Total Intensity increased, the Step Total also increased for most observations. To confirm this for the entirety of the data, I created a scatterplot as shown in Figure 1 in Tableau. The relationship confirmed a positive correlation between both variables (also confirmed by low P-value = <0.0001 and high R-Squared = 0.802786. This shows that the more steps users are taking per day, the higher the total intensity.  

![](All%20Images/Image1.jpg)

Figure 2 shows that generally as a user’s total steps increased, the greater the number of calories they burned. 

![](All%20Images/Image2.jpg)
 
## SHARE: Data visualisations and insights
Figure 3 shows that Saturday followed by Tuesday are the days of most activity. With Saturday, users are averaging 8153 steps and Sunday being the day of least activity with users averaging 6933 steps.

![](All%20Images/Image3.jpg)
 
In Figure 4, there is a positive correlation between the number of calories burned and very active minutes of activity. The greater the activity in minutes, the greater the calories burned. Whereas there is not a correlation between minutes of being Sedentary and calories burned, the calories burned are maintained around the 1.5-2.5K mark for those sedentary for more than 600 minutes a day.
 
![](All%20Images/Image4.jpg)

Figure 5 shows the trend of average total of steps taken over the 30 days at each hour. 6pm is the hour of greatest step total with 599 steps taken on average. Total steps fall from 8pm to 1am making this the period of least activity.
 
![](All%20Images/Image5.jpg)


## ACT: Answer initial questions and give recommendations 

### Recommendations:
-	As there are multiple instances of a lack of tracking, the Bellabeat app should alert users to actively use their devices whether that be every morning or if there has been a lack of activity for a consecutive number of hours/days, this will encourage users to increase their activity remain interactive with the device and app. 
- There should also be alerts when users hit a certain number of steps a day (e.g. alert when they hit every 2000 steps) so that they are actively aware of their activity, this will encourage users to meet or even exceed the recommended 10,000 steps (The American Heart Association).
-	When 10,000 steps have been reached, a motivating message for this accomplishment will encourage users to continue making this achievement every day – a streak count could also influence users to continue maintaining a streak daily.
-	Create a Total Steps of the day interactive board where users can collectively work towards a common goal. Users will feel much more motivated to exercise knowing other users are too. Use most popular days and least popular days as reminders to stay moving.
-	Users should input their preferred bedtime and duration of sleep (give a recommended duration along with an optional function) and when it reaches within 30 minutes of that time, an alert should be sent out. Regarding exercise, those who are sedentary for more than 8 hours a day should receive regular alerts to move their body for a total of 60 minutes a day and be rewarded with a congratulatory message when this is achieved.
-	Alert everyone at 18:00 to participate in activity as a community, this hour is usually after a typical day of working.
-	If users’ aim is to lose weight, encourage them to regularly update their information into weightloginfo so they can track weight loss over time when following healthy habits. Avoid recording BMI as this can be discouraging and is also inaccurate based on a variety of demographics.

### Points to note:
-	This data isn’t sufficient to make confident decisions based on a whole population.
-	Data needed a bit more context to understand what each column was showing. There were also some errors that needed explaining such as the calculations for trackerdistance and totaldistance, sleep records and loggedactivitiesdistance. 
-	weightloginfo table was the only table with missing values in 65/67 rows within the column ‘Fat’, this attribute was not recorded for most of the dataset and so it does not make sense to carry out any analysis on this section, data was very limited too.

### Additional steps:
-	Duration: Extended durations of data collection would give much more accurate findings and therefore recommendations. Collecting data for the whole year can provide some useful information on how users perform during different seasons. 
-	For weightloginfo, information such as gender, age and location could prove to be useful and will allow for comparisons between these attributes. 
-	A larger sample size will represent the population more accurately. 
-	Using a tracker and user’s permission via the app to collect information can be more accurate than relying on third party information and user’s manual input to understand how Bellabeat users perform. 


