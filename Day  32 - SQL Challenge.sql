create database game;
use game;

create table activity (

 player_id     int     ,
 device_id     int     ,
 event_date    date    ,
 games_played  int
 );

 insert into activity values (1,2,'2016-03-01',5 ),(1,2,'2016-03-02',6 ),(2,3,'2017-06-25',1 )
 ,(3,1,'2016-03-02',0 ),(3,4,'2018-07-03',5 );

/*
questions:
--Game Play Analysis 

--q1: Write an SQL query that reports the first login date for each player

--q2: Write a SQL query that reports the device that is first logged in for each player

--q3: Write an SQL query that reports for each player and date, how many games played so far by the player. 
--That is, the total number of games played by the player until that date.

--q4: Write an SQL query that reports the fraction of players that logged in again 
 on the day after the day they first logged in, rounded to 2 decimal places
*/

select * from activity;
 
 
 -- q1: Write an SQL query that reports the first login date for each player\
select player_id, min(event_date) as "first login date"
from activity
group by player_id;

-- OR 

select player_id, event_date as "first login date"
from
	(select *, row_number() over(partition by player_id order by event_date) rnk
	from activity) a
where rnk = 1;


-- q2: Write a SQL query that reports the device that is first logged in for each player
select player_id, event_date, device_id as "first login device_id"
from
	(select *, row_number() over(partition by player_id order by event_date) rnk
	from activity) a
where rnk = 1;


-- q3: Write an SQL query that reports for each player and date, how many games played so far by the player. 
-- That is, the total number of games played by the player until that date.
select player_id, 
	   event_date, 
       sum(games_played) over (partition by player_id order by event_date)
from activity;


-- q4: Write an SQL query that reports the fraction of players that logged in again 
 -- on the day after the day they first logged in, rounded to 2 decimal places
with cte as (
  select *,
  lag(event_date) over(partition by player_id order by event_date ) as next_date
  from activity
  )
  select * from cte 
  where DATEDIFF(event_date,next_date) = 1;

  

WITH cte AS (
    SELECT 
        *,
        LEAD(event_date) OVER (PARTITION BY player_id ORDER BY event_date) AS next_event_day,
        LEAD(event_date) OVER (partition by player_id order by event_date) - event_date as day_diff
        FROM Activity
)
SELECT 
    ROUND(COUNT(DISTINCT CASE
                    WHEN day_diff = 1 THEN player_id
                END) / COUNT(DISTINCT player_id), 2) AS fraction_players
FROM
    cte;
-- logic-- count of distinct player_id when date_diff is 1 / count of distinct player_id