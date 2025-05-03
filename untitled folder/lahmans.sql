-- ## Lahman Baseball Database Exercise
-- - this data has been made available [online](http://www.seanlahman.com/baseball-archive/statistics/) by Sean Lahman
-- - A data dictionary is included with the files for this project.


-- **Initial Questions**

-- 1. What range of years for baseball games played does the provided database cover? 
-- SELECT distinct yearid
-- 	from batting
-- 		order by yearid 
-- Answer: 146, 1871 - 2016

-- select min(yearid),max(yearid),count(distinct yearid)
-- from batting
-- Answer: 146, 1871 - 2016

-- 2. Find the name and height of the shortest player in the database. How many games did he play in? What is the name of the team for which he played?
   -- select height, namefirst, namelast,
   -- g_all,  teams.yearid,
   -- teams.name
   -- 	from people 
	  --  right join appearances
	  --  	using(playerid)
		 --   			  left join teams
			--    using(teamid, yearid)
	  --  	order by height, yearid

-- 	with short_guy as (
-- select 
-- 	namefirst, 
-- 	namelast,
-- 	playerid, 
-- 	height
-- 		from people 
-- 			group by 1,2,3
-- 			order by height
-- 				limit 1)
-- 			select 
-- 				s.namefirst, s.namelast, s.height,
-- 				a.g_all as games_played,
-- 				t.name, t.park
-- 					from short_guy s
-- 					left join appearances a 
-- 						using(playerid)
--  							left join teams t
-- 							 	using(teamid, yearid)

-- Answer: Eddie Gaedel, 43 inc-hes, 1 game, Saint Louis Browns

-- 3. Find all players in the database who played at Vanderbilt University. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. Sort this list in descending order by the total salary earned. Which Vanderbilt player earned the most money in the majors?

-- select namefirst, 
-- namelast, 
-- cp.*,
-- sum(salary) as totalsal
-- 	from people p 
-- 	inner join(
-- select distinct playerid 
-- from collegeplaying 
-- where schoolid = 'vandy') cp
-- 	using(playerid)
-- 		left join salaries s
-- 			using(playerid)
-- 				group by namefirst, namelast, 3
-- 					order by totalsal desc nulls last
				
							
	-- Answer: "David"	"Price"	"priceda01"	81851296

-- 4. Using the fielding table, group players into three groups based on their position: label players with position OF as "Outfield", those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". Determine the number of putouts made by each of these three groups in 2016.
   	--  	 Select sum(po),
			 -- (case when pos = 'OF' then 'Outfield'
			 -- when pos ='SS' or pos = '1B' or pos ='2B' or pos = '3B' then 'Infield' 
			 -- -- or when pos in ('SS','1B','2B','3B') then 'infield'
			 -- -- or else 'battery'
			 -- when pos = 'P' or pos = 'C' then 'battery'  
			 -- 	else null end) as dec
				--  	from fielding
				-- 	 	where yearid = '2016'
				-- 		 group by dec
						 	
-- 5. Find the average number of strikeouts per game by decade since 1920. Round the numbers you report to 2 decimal places. Do the same for home runs per game. Do you see any trends?

-- select distinct
-- 	yearid / 10 * 10 as dec,
-- 	round(sum(so::numeric)/(sum(g::numeric)/2),2) avg_so,
-- 	round(sum(hr::numeric)/(sum(g::numeric)/2),2) avg_hr
-- 	-- dividing by two because there are two teams in each game
-- from teams
-- where yearid >= 1920
-- group by 1
-- order by dec desc

-- 6. Find the player who had the most success stealing bases in 2016, where __success__ is measured as the percentage of stolen base attempts which are successful. (A stolen base attempt results either in a stolen base or being caught stealing.) Consider only players who attempted _at least_ 20 stolen bases.
	-- select namefirst, namelast, round((sb * 1.0/ (sb + cs))*100,2) sb_success
	-- 	from batting b
	-- 		 join people p
	-- 		 using(playerid)
	-- 		 where yearid = 2016
	-- 				and (sb + cs) >= 20
	-- 					order by sb_success desc
	-- 					limit 1

	-- with best_sb as(
	-- select playerid, 
	-- round(sum(sb::numeric) / (sum(sb::numeric)+sum(cs::numeric))*100,2) sb_success
	-- from batting 

	-- where yearid = 2016
	-- group by playerid
	-- having sum(sb+cs) >= 20
	-- order by sb_success desc
	-- limit 1)
	-- 	select concat(namefirst,' ', namelast) as full_name,b.sb_success
	-- 	from people p
	-- 	inner join best_sb b
	-- 	using(playerid)

-- 7.  From 1970 – 2016, what is the largest number of wins for a team that did not win the world series? What is the smallest number of wins for a team that did win the world series? Doing this will probably result in an unusually small number of wins for a world series champion – determine why this is the case. Then redo your query, excluding the problem year. How often from 1970 – 2016 was it the case that a team with the most wins also won the world series? What percentage of the time?
		-- select yearid, name, w, wswin
		-- 	from teams
		-- 		where yearid >= 1970
		-- 		and wswin = 'N'
		-- 			order by w desc
	-- Answer: 2001	"Seattle Mariners"	116	"N"

	-- Select yearid, name, w, wswin
	-- 	from teams 
	-- 		where yearid >= 1970 
	-- 		and wswin = 'Y'
	-- 			order by w
	-- 	Answer: 1981	"Los Angeles Dodgers"	63	"Y"


-- with most_wins as (select 
-- 	name, 
-- 	wswin,
-- 	w,
-- 	yearid,
-- 	rank() over(Partition by yearid order by w desc) rank_wins
-- 	from teams 
-- 		where yearid > 1969
		
-- 		and yearid not in (1981)
-- 		order by yearid),
-- 	wins_mostwins as (select 
-- 	sum(case when wswin = 'Y' and rank_wins = 1 then 1 
-- 	else 0 
-- 	end) as ws_and_mostwins, 
-- 	count(distinct yearid) as num_year
-- 	from most_wins)
-- select round((ws_and_mostwins::numeric / num_year::numeric)*100,2),ws_and_mostwins,num_year
-- from wins_mostwins
	
-- 8. Using the attendance figures from the homegames table, find the teams and parks which had the top 5 average attendance per game in 2016 (where average attendance is defined as total attendance divided by number of games). Only consider parks where there were at least 10 games played. Report the park name, team name, and average attendance. Repeat for the lowest 5 average attendance.
-- 	with highest as(select  t.name, park_name, (round(sum(h.attendance::numeric)/ (games::numeric),0)) avg_att,p.park, 'top 5'
-- 	from homegames h
-- 		inner join parks p
-- 		on h.park = p.park
-- 			inner join teams t
-- 				on h.team = t.teamid
-- 				and h.year = t.yearid
-- 					where year = 2016
-- 					group by  park_name, p.park, h.games, t.name
-- 					order by avg_att desc
-- 					limit 5)
-- union 
-- 	with lowest as (select  t.name, park_name, (round(sum(h.attendance::numeric)/ (games::numeric),0)) avg_att,p.park, 'bottom 5'
-- 	from homegames h
-- 		inner join parks p
-- 		on h.park = p.park
-- 			inner join teams t
-- 				on h.team = t.teamid
-- 				and h.year = t.yearid
-- 					where year = 2016
-- 					group by  park_name, p.park, h.games, t.name
-- 						order by avg_att 
-- 							limit 5)
-- 	select *
-- 	from highest 
-- 		union 
-- 		select *
-- 		from lowest 
-- 		order by avg_att desc

-- Needs fixing but close^^

	-- select team,t.name park_name, (round(sum(h.attendance::numeric)/ (games::numeric),0)) avg_att,p.park
	-- from parks p
	--  join homegames h
	-- 	on p.park = h.park
	-- 		join teams t
	-- 			on h.team = t.teamid and h.year = t.yearid 
	-- 				where year = 2016
	-- 				and games >=10
	-- 				group by team, park_name, p.park, games, t.name
	-- 					order by avg_att 
	-- 						limit 5

-- 9. Which managers have won the TSN Manager of the Year award in both the National League (NL) and the American League (AL)? Give their full name and the teams that they were managing when they won the award.

-- Select distinct
-- concat(namefirst,' ', namelast) as full_name, m.teamid,  a.lgid
-- 	from awardsmanagers a
-- 		inner join managers m
-- 			on a.playerid = m.playerid
-- 			and a.yearid = m.yearid
-- 			and a.lgid = m.lgid
-- 		inner join teams t 
-- 			on m.yearid = t.yearid
-- 			and m.teamid = t.teamid
-- 			and m.lgid = t.lgid
-- 							inner join people p
-- 							on a.playerid = p.playerid
-- 		where a.playerid in
-- (select playerid 
-- 	from awardsmanagers
-- 		where awardid = 'TSN Manager of the Year'
-- 			and lgid in ('NL','AL')
-- 				group by 1
-- 					having count(distinct lgid) >1)
					

-- 10. Find all players who hit their career highest number of home runs in 2016. Consider only players who have played in the league for at least 10 years, and who hit at least one home run in 2016. Report the players' first and last names and the number of home runs they hit in 2016.
-- with ten_years as (select playerid
-- 	from batting
-- 		group by playerid
-- 	having count(distinct yearid) > 9),
-- 	 player_hr as (select playerid
-- 	from batting
-- 		where hr > 0
-- 		and yearid = 2016),

-- 	setup as (select p.namefirst,
-- 	p.namelast,
-- 	yearid,
-- 	hr,
-- 	row_number() over(partition by b.playerid order by hr desc, yearid desc ) maxhr
-- 	from batting b
-- 	inner join people p 
-- 		on b.playerid = p.playerid
-- 			where b.playerid in (select * from player_hr)
-- 			and b.playerid in (select * from ten_years)
-- 			)
-- 			select *
-- 			from setup 
-- 			where maxhr = 1 and yearid =2016

