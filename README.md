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

![](All%20Images/Code1.png)
 
--2. Check to see how many unique participants there are per table 
There are limited numbers of participants in each table. 33 in dailyactivity, hourlyintensities, hourlysteps; 24 in sleepday and 8 in weightloginfo. This data isn’t sufficient to make confident decisions based on a whole population.
 
![](All%20Images/Code2.png)

-- 3. Check to see if data types for each column are appropriate and modifying where necessary
To stay consistent, I changed most data types for each column of each table, ensuring that any data which is present within two or more tables had the exact same data type. I could not change all datatypes at once so had to execute separate statements for each. I would otherwise have to create a new table as suggested by other users. I used %r to change the times from AM/PM to 24-hour format. I dropped columns with Date and Time after copying data into two separate columns within the tables. I also ensured that TotalTimeBed values made sense to be greater in number than TotalMinutesAsleep.
 
![](All%20Images/Code3.png)
![](All%20Images/Code4.png)
![](All%20Images/Code5.png)
 
-- 4. Check duration of data for all tables
Ensured that data spanned across 30 days from '2016-04-12' and '2016-05-12'
 
![](All%20Images/Code6.png)

-- 5. Check Id characters are appropriate character lengths
I ensured all character lengths were consistent for each table (10 characters for Id) and 13 characters for LogId.

// line

![](All%20Images/Code7.png)

-- 6. Check for duplicate rows
I created a primary key which automatically incremented from 1 for all rows of sleepday. This allowed for a unique identifier as there are many duplicate fields (as one Id would have multiple observations) to easily identify rows of duplicates to delete them from the table. 3 row duplicates were found. After removing duplicates, the PID column was dropped.

![](All%20Images/Code8.png)
![](All%20Images/Code9.png)
 
-- 7. Check for NULL or missing values
weightloginfo table was the only table with missing values in 65/67 rows within the column ‘Fat’. I will consider this when carrying out analysis.

![](All%20Images/Code10.png)
 
## ANALYZE: finding trends and relationships, performing calculations and organising data
-- 1. Work out average, minimum and maximum daily steps from dailyactivity
These calculations were executed, and I discovered that the minimum total steps = 0. The only possible reasoning being that total steps were not tracked. I discovered that 77/940 observations had 0 total steps and 15/33 (almost half) of the participants did not track this information at least once during the period of tracking. The average steps equalled to 7638 which is well below the recommendation of 10,000 a day according to The American Heart Association.
 
![](All%20Images/Code11.png)
![](All%20Images/Code12.png)
 
-- 2. What days are users the most active and what days are users the least active
I created a new table with a new column named ‘day name’. Here the day name for each date of the observation would be updated in the new column. From this, I could then calculate that Saturday is the day users are most active on averaging 8153 steps and Sunday is the day users were least active, averaging 6933 steps.

![](All%20Images/Code13.png)

-- 3. How many calories do users burn on average
2304 calories are burned on average by users per day. According to performancelab, without exercise, people on average, burn 1800 calories. 2304 calories is a significant improvement by users. However, if users have a goal of losing weight, it is estimated that 3500 calories must be burned daily to burn a pound within a week (as suggested by menshealth.com).

![](All%20Images/Code14.png)
 
-- 4.  Determine if trackerdistance and totaldistance match and check the sum of varying distances to see if they match either trackerdistance/totaldistance
As there is not much context provided for these columns, I will not provide recommendations regarding distance as it shows that 14 records do not meet this criteria.
-- 5. Validation check for Total distance SUM for dailyactivity
251/940 rows show that the SUM of column does not equal TotalDistance
256/940 rows show that the SUM of column does not equal TrackerDistance
As there are multiple observations which do not match the criteria, I decided not to use this information on distance to provide any insights as they may be inaccurate.
 
![](All%20Images/Code15.png) 

-- 6. Check average VeryActiveMinutes 
21 minutes is the average VeryActiveMinutes of activity of users within this dataset per day. The CDC suggests a weekly 150 minutes of vigorous activity which equals on average 21 minutes a day. Users on average are meeting this requirement towards better physical health. 

![](All%20Images/Code16.png)
 
-- 7. Check average SedentaryMinutes 
-- 8. How many users work out for 60 minutes or more if they have SedentaryMinutes of more than 991 minutes
Users on average spend 991 minutes sedentary per day. Let’s say the recommended 8 hours of this time is dedicated to sleep, that leaves around another 8.5 hours of being sedentary. A new study reported by CBC states that those who sit for 8 hours, whether that be for work or just sitting can cause health risks and that 60 minutes of activity a day could offset this. To avoid assumptions, we have a table with information on users and their sleep, I created a new table (dailyactivitywithsleep) and used INNER JOIN to join relevant columns in dailyactivity with relevant columns from sleepday.

![](All%20Images/Code17.png)
 
-- 9. Create a new table detailing relevant columns from dailyactivity and sleepday
To avoid assumptions, we have a table with information on users and their sleep, I created a new table (dailyactivitywithsleep) and used INNER JOIN to join relevant columns in dailyactivity with relevant columns from sleepday resulting in 410 observations. Of these 410 observations, there are zero observations of users with >=991 SedentaryMinutes AND TotalMinutesAsleep >=480 AND VeryActiveMinutes >=60. This shows that users are not meeting the sleep and exercise recommendations as set by CBC for people who spend more than 8 hours sedentary per day. They are not sleeping enough and not carrying out enough exercise. 

![](All%20Images/Code18.png)
 
-- 10. Create a new table hourlyintensities by joining hourlyintensities and hourlysteps tables together
A new table hourlyintensitiesandsteps was created to allow for easier and clearer analysis of both data. 

![](All%20Images/Code19.png)
 
-- 11. What hour is most popular for activity
The average totalsteps was calculated to be 320 steps. To figure out which hours of the day were popular for activity. I used the average of 320 steps to filter out information for any observations recording less than 320 steps. 18:00 was the hour of the day where on average, users carried out the most activity. I also noted that 03:00 was the hour of least activity.

![](All%20Images/Code20.png)
 
-- 12. Calculate average BMI of participants in weightloginfo
There is only information for 8 participants in weightloginfo as compared to 33 in dailyactivity so not all users have made use of this function. Information such as gender, age and height may have aided in a deeper analysis of this dataset. The average BMI is 25.2 which is overweight. BMI is also not an accurate measure for diagnosing body fat content. There may be different ethnicities as part of the study which hasn’t been clarified. Body fat distribution has been shown to vary between different ethnic/race groups as according to health.clevelandclinic.org. Only two observations recorded fat. The units were not confirmed and as it is such a small sample of the population of users, it is unnecessary to perform analysis on as it could inaccurately represent the data.

![](All%20Images/Code21.png)

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


