show databases; -- this shows all of our databases
use `walmart-sales`; -- we are using the schema called "walmart-sales"
SELECT * FROM `sales of walmart data`; -- opens the specific table we want to do data analysis on

-- Q1. Which holidays affect weekly sales the most?
select
case -- this is for multiple conditions, which are the holdiday dates of each year labelled 
when Date in ('02/12/2010', '02/11/2011', '02/10/2012') then 'Super Bowl'
when Date in ('10/09/2010', '09/09/2011', '07/09/2012') then 'Labor Day'
when Date in ('26/11/2010', '25/11/2011', '23/11/2012') then 'Thanksgiving'
when Date in ('31/12/2010', '30/12/2011', '28/12/2012') then 'Christmas'
else 'Non-Holiday'
end as Holiday_Name,
ROUND(avg(Weekly_Sales), 2) as Avg_Weekly_Sales -- rounds the avg of weekly sales in 2 d.p.
from `sales of walmart data`
where Holiday_Flag = 1
GROUP BY Holiday_Name
ORDER BY Avg_Weekly_Sales DESC;
/* by the code, we find that thanksgiving has the most weekly sales averagely (127123.43) 
         which is followed by superbowl (1079127.99) and labour day (1039182.83) *?
         
/* Q2. (a) Which stores in the dataset have the lowest and highest unemployment rate? */
(SELECT 'Lowest' AS Category,
Store,
ROUND(AVG(Unemployment), 3) AS Avg_Unemployment
FROM `sales of walmart data`
GROUP BY Store
ORDER BY Avg_Unemployment ASC)
UNION ALL
(SELECT 'Highest' AS Category,
Store,
ROUND(AVG(Unemployment), 3) AS Avg_Unemployment
FROM `sales of walmart data`
GROUP BY Store
ORDER BY Avg_Unemployment DESC);
/* averagely, stores 23 and 40 have the lowest unemployment (4.796) and stores 12, 28 and 38 have the highest
unemployment (13.116) */

/* (b) What factors do you think are impacting the unemployment rate? */
the factors that are affecting unemployment are: CPI, inflation because when prices rise, consumer spending and 
business profitability fall. */

/* Q3. (a) Is there any correlation between CPI and Weekly Sales? 

correlation = cov/[sd(A)*sd(B)]. */

SELECT
    (COUNT(*) * SUM(CPI * Weekly_Sales) - SUM(CPI) * SUM(Weekly_Sales)) /
    (SQRT(COUNT(*) * SUM(POWER(CPI, 2)) - POWER(SUM(CPI), 2)) *
     SQRT(COUNT(*) * SUM(POWER(Weekly_Sales, 2)) - POWER(SUM(Weekly_Sales), 2)))
    AS correlation_coefficient
FROM `sales of walmart data`;
/* we find that the correlation coefficient is -0.07 which indicates that there is a poor/ no significant
correlation between CPI and weekly sales. */

/* (b) How does the correlation differ when the Holiday Flag is 0 versus when the Holiday Flag is 1? */
SELECT
    (COUNT(*) * SUM(CPI * Weekly_Sales) - SUM(CPI) * SUM(Weekly_Sales)) /
    (SQRT(COUNT(*) * SUM(POWER(CPI, 2)) - POWER(SUM(CPI), 2)) *
     SQRT(COUNT(*) * SUM(POWER(Weekly_Sales, 2)) - POWER(SUM(Weekly_Sales), 2)))
    AS correlation_coefficient
FROM `sales of walmart data`
WHERE Holiday_Flag = 1;
/* with a holiday present, there is a correlation coefficient of -0.08 so still not significant*/

SELECT
    (COUNT(*) * SUM(CPI * Weekly_Sales) - SUM(CPI) * SUM(Weekly_Sales)) /
    (SQRT(COUNT(*) * SUM(POWER(CPI, 2)) - POWER(SUM(CPI), 2)) *
     SQRT(COUNT(*) * SUM(POWER(Weekly_Sales, 2)) - POWER(SUM(Weekly_Sales), 2)))
    AS correlation_coefficient
FROM `sales of walmart data`
WHERE Holiday_Flag = 0;
/* with no holiday prescence, there is a correlation coefficient of -0.07 so still not significant*/

/* Q4. (a) Why do you think Fuel Price is included in this dataset? 

fuel price probably was included in this dataset as it is a factor that impacts the supply chain cost. if there
were to be high fuel prices then that makes it expensive for walmart to deliver goods from the warehouse to 
individual stores. overall, it is a factor that impacts weekly sales of walmart through supply chain costs.
hence, analysts can see whether higher fuel prices lead to lower sales for individual stores.

(b) What conclusions can be made about Fuel Price compared to any of the other fields? */
SELECT Store,
    (COUNT(*) * SUM(Fuel_Price * Weekly_Sales) - SUM(Fuel_Price) * SUM(Weekly_Sales)) /
    (SQRT(COUNT(*) * SUM(POWER(Fuel_Price, 2)) - POWER(SUM(Fuel_Price), 2)) *
     SQRT(COUNT(*) * SUM(POWER(Weekly_Sales, 2)) - POWER(SUM(Weekly_Sales), 2)))
    AS correlation_coefficient
FROM `sales of walmart data`
GROUP BY Store
ORDER BY correlation_coefficient;

/* we find that the strength and direction of the corellation between fuel price and weekly sales vary by 
location. for example, store 38 shows the strongest positive correlation (r = 0.698), suggesting that higher 
fuel prices are associated with higher weekly sales for this store. alternatively, Store 36 exhibits the 
strongest negative correlation (r = −0.727), indicating that higher fuel prices may reduce customer spending 
or visits at that store, hence lower weekly sales for that store. overall, including Fuel Price in the dataset 
helps capture how external economic conditions can impact store performance across regions for walmart. */


