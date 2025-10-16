create database emailproject;
show databases;
use emailproject;

show tables;

select * from Unsubscribes
select * from Campaign_Performance
select * from Campaigns
select * from Email_Engagement
select * from Users

/* 1. What is the overall unsubscribe rate?
			-> total unsubscribe rate = (total unsubscribed users/total users) * 100     */
select 
    (COUNT(distinct unsubscribes.user_id) * 100.0/(select COUNT(distinct user_id) from Users)) as unsubscribe_rate
from Unsubscribes; -- this line is written without aliases

select 
    (COUNT(distinct u.user_id) * 100.0/(select COUNT(distinct user_id) from Users)) as unsubscribe_rate
from Unsubscribes u; -- this line includes alias 'u' which is a shortform for table name "Users"
-- answer = 25.92

-- 2. Which campaigns had the highest and lowest unsubscribe rates?
(select 'highest' as type, -- creates column called highest to look at highest unsubscribed rate
c.campaign_name,
(cp.total_unsubscribes * 100.0/cp.total_sent) AS unsubscribe_rate -- the formula
from Campaign_Performance cp
join campaigns c on c.campaign_id = cp.campaign_id -- what column is joined [i.e. which one is same for both tables
order by unsubscribe_rate DESC -- from highest to lowest
limit 1
)
union all
(select 'lowest' as type,
c.campaign_name,
(cp.total_unsubscribes * 100.0/cp.total_sent) AS unsubscribe_rate
from Campaign_Performance cp
join campaigns c on c.campaign_id = cp.campaign_id
order by unsubscribe_rate ASC
limit 1
);

/* 3. Do certain campaign categories (promotion, newsletter, re-engagement, announcement) have higher 
unsubscribe rates? */
select c.category,
(sum(cp.total_unsubscribes) * 100.0/sum(cp.total_sent)) AS unsubscribe_rate
from Campaign_Performance cp
join campaigns c on c.campaign_id = cp.campaign_id
group by c.category
order by unsubscribe_rate DESC; /* yes, promotion has goth the highest unsubscribe rate of 5.36. announcement is similar to promotion. 
re-engagement and newsletter have got a lower unsubscribe rate compared to the first two */

-- 4. What is the relationship between open rate and unsubscribe rate?
SELECT
    (COUNT(*) * SUM(total_opens * total_unsubscribes) - SUM(total_opens) * SUM(total_unsubscribes)) /
    (SQRT(COUNT(*) * SUM(POWER(total_opens, 2)) - POWER(SUM(total_opens), 2)) *
     SQRT(COUNT(*) * SUM(POWER(total_unsubscribes, 2)) - POWER(SUM(total_unsubscribes), 2)))
    AS correlation_coefficient
FROM Campaign_Performance; -- negative relationship with correlation coefficient of -0.4

-- 5. Which region(s) or device type(s) have the highest unsubscribe rate?
select users.region,
count(users.user_id) as total_unsubscribes
from users
group by users.region
order by total_unsubscribes desc; -- asia has highest [1305] followed by north america [1246], europe [1245] and lastly south america [1204]

-- 6. How long after signup do users typically unsubscribe?
-- signup date = from users, unsubscribe date = from unsubscribes. formula = unsubscribe - signup dat
select un.user_id, u.signup_date, un.unsubscribe_date, 
datediff(un.unsubscribe_date, u.signup_date) as q6
from unsubscribes un 
join users u on un.user_id = u.user_id
order by q6 desc; -- this shows how many days each user stayed subscribed before unsubscribing 

select
round(avg(datediff(un.unsubscribe_date, u.signup_date)),1) as q6
from unsubscribes un 
join users u on un.user_id = u.user_id -- in general and averagely, 148.1 days after signing up, users unsubscribe

-- 7. Does send time (hour of day) impact engagement or unsubscribe rates?
select c.send_hour,
round(sum(cp.total_clicks) * 100/sum(cp.total_sent),2) as click_rate,
round(sum(cp.total_opens) * 100/sum(cp.total_sent),2) as open_rate,
round(sum(cp.total_unsubscribes) * 100.0 / sum(cp.total_sent), 2) as unsubscribe_rate
from campaigns c
join campaign_performance cp on c.campaign_id = cp.campaign_id
group by c.send_hour
order by c.send_hour; /* no because even if emails are sent in any hour between 7am to 8pm, the click rates, open rates and unsubscribe rates are 
very familiar */

-- 8. What are the most common unsubscribe reasons, and do they vary by campaign category?
select u.reason,
COUNT(u.user_id) as total_unsubscribes
from unsubscribes u
group by u.reason
order by total_unsubscribes desc; /* most common reason to unsubscribe is because of privacy concerns which led to a total rate of 334 
unsubscriptions, followed by the reason of "not relevancy". */

select c.category, u.reason,
COUNT(u.user_id) as total_unsubscribes
from unsubscribes u
join campaigns c on c.campaign_id = u.campaign_id
group by c.category, u.reason
order by total_unsubscribes desc; -- reasons do vary by category.

-- 9. Who are the “at-risk” users?

-- 10. What’s your final story?

