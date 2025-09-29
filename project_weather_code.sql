create DATABASE weatherproject;
show databases;
use weatherproject; -- this means that we are using this database 

DROP TABLE IF EXISTS daily_weather;
DROP TABLE IF EXISTS thresholds;
DROP TABLE IF EXISTS stations;

SHOW TABLES;
SELECT * FROM daily_weather; -- selects all weather_id from table daily_weather

select count(date) from daily_weather; -- we find out the total days recorded

select * from daily_weather order by tmax_f DESC, date;
select * from daily_weather order by tmax_f ASC, date;

select * from thresholds; 

select date, tmax_f, tmin_f, 
case when tmax_f > tmin_f then tmax_f 
else tmin_f
end as maxtemp
from daily_weather
order by maxtemp DESC; -- lines 15-20 helps us find 1 max & min temp value with the date it occured using CASE for a loop

-- how many days had temp>90
select count(*) from daily_weather where tmax_f > 90 or tmin_f > 90 
select count(case when tmax_f > 90 or tmin_f > 90 then 1 end) as "extreme cold" from daily_weather -- another way to do line 27

-- how many days had temp<32
select count(*) from daily_weather where tmax_f < 32 or tmin_f < 32 
select count(case when tmax_f < 32 or tmin_f < 32 then 1 end) as "extreme cold" from daily_weather -- another way to do line 31

-- average windspeed for each year
select avg(wspd_mph) from daily_weather

-- on how many days did wspd_mph>20
select count(*) from daily_weather where wspd_mph > 20
select count(case when wspd_mph > 20 then 1 end) as "windspeed greater than 20" from daily_weather -- another way to do line 31


-- on how many days temp>90, temp<32 or wind>20 (extreme weather days)
select count(
case 
when(tmax_f > 90 or tmin_f > 90) 
OR (tmax_f < 32 or tmin_f < 32) 
OR wspd_mph > 20 then 1 end) as "extreme weather days" 
from daily_weather;

-- which month had highest no. of extreme weather days
select date_format(date,'%Y-%m') as month,
count(
case 
when (tmax_f > 90 or tmin_f > 90) 
OR (tmax_f < 32 or tmin_f < 32) 
OR wspd_mph > 20 then 1 end) as extreme_weather_days 
from daily_weather
group by month
order by month;

/* % of all recorded days which had extreme weather. 
          formula to use = 100 * (total extreme weather days/total days per year) 

			we use round(formula,2) where the ,2 means that % is rounded in 2 d.p.  */
select round(100 * count( 
case 
when (tmax_f > 90 or tmin_f > 90) 
OR (tmax_f < 32 or tmin_f < 32) 
OR wspd_mph > 20 then 1 end)/count(*),2) as extreme_weather_percentage
from daily_weather;