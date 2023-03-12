use FWC_Qatar_2022
go

/* How many goals were scored in the tournament? */
select count(G.Goal_ID) as Total_Goals_Scored
from Goals G

/* How many of them were scored in the group and knockout stage? */
select G.Round, count(G.Goal_ID) as Goals_Per_Round
from Goals G
where G.Round in ('Group Stage', 'Round of 16', 'Quarter Final', 
					'Semi Final', '3rd Place Playoff', 'Final')
group by g.Round
order by Goals_Per_Round desc

/* What were the amount of games won by each group winner? */
select G.Team_Name, T.Wins, G.Position
from Groups G
JOIN Teams T on G.Team_ID = T.Team_ID
where G.Position = '1'
group by G.Team_Name, T.Wins, G.Position
order by T.Wins desc

/* Show the goals scored and conceded for the teams that 
were eliminated in the group stage.*/
select T.Team_Name, T.Goals_Scored, T.Goals_Conceded, T.Highest_Finish
from Teams T
where T.Highest_Finish = 'Group Stage'
group by T.Team_Name, T.Goals_Scored, T.Goals_Conceded, T.Highest_Finish
order by T.Team_Name

/* How many goals were scored in additional time? */
select G.Time_Format, count(G.Goal_ID) as Number_of_Goals
from Goals G
where G.Time_Format = 'Additional Time'
group by G.Time_Format

/* Which team had the highest amount of bookings (Red + Yellow Cards) */
select top 1 T.Team_Name, MAX(T.Yellow_Cards + T.Red_Cards) as Number_of_Bookings
from Teams T
group by T.Team_Name
order by Number_of_Bookings desc

/* Which team(s) collected no single point in the group stages? */
select T.Team_Name, G.Points_Gained	
from Groups G 
JOIN Teams T on G.Group_ID = T.Group_ID
where G.Points_Gained = '0'
group by T.Team_Name, G.Points_Gained

/* What teams participated in the game(s) that had the 
highest stadium attendances? */
select S.Stadium_Name, M.Home_Team, M.Away_Team, 
						MAX(S.Attendance) as Highest_Attendance
from Stadiums S
JOIN Matches M on S.Match_ID = M.Match_ID
group by M.Home_Team, M.Away_Team, S.Stadium_Name
order by Highest_Attendance desc

/* Which player scored the highest number of goals? */
select top 1 G.Goal_Scorer, count(G.Goal_ID) as Number_of_Goals
from Goals G
group by G.Goal_Scorer
order by Number_of_Goals desc

/* What was the latest minute in which the top scorer scored a goal? */
select top 1 G.Goal_Scorer, G.Goal_Minute 
from Goals G
where G.Goal_Scorer = 'Kylian Mbappe'
group by G.Goal_Scorer, G.Goal_Minute
order by Goal_Minute 

/* On which date was the last game at Al Janoub Stadium played? */
select top 1 M.Date, M.Stadium_Name
from Matches M
where M.Stadium_Name = 'Al Janoub Stadium'
group by M.Stadium_Name, M.Date
order by M.Date desc

/* What was the highest possible round that all 8 group winners could reach? */
select G.Team_Name, G.Position, T.Highest_Finish
from Groups G
JOIN Teams T on G.Group_ID = T.Group_ID
where G.Position = '1'
group by G.Team_Name, T.Highest_Finish, G.Position
order by G.Team_Name

/* What were the teams that Lionel Messi and Cristiano Ronaldo scored against. */
select G.Goal_Scorer, G.Scored_Against
from Goals G
where G.Goal_Scorer = 'Lionel Messi' OR G.Goal_Scorer = 'Cristiano Ronaldo'
group by G.Goal_Scorer, G.Scored_Against

/* How many goals were scored in Extra time (additional 30 mins in knockout)? */
select G.Time_Format, count(G.Goal_ID) as Number_of_Goals
from Goals G
where G.Time_Format LIKE '%Extra Time%'
group by G.Time_Format

/* Which teams had a negative goal difference? */
select T.Team_Name, (T.Goals_Scored - T.Goals_Conceded) as Goal_Difference
from Teams T
group by Team_Name, T.Goals_Scored, T.Goals_Conceded
having T.Goals_Scored - T.Goals_Conceded < 0
order by Goal_Difference

/* Which player scored the opening goal of the tournament and in which minute? */

select G.Goal_Scorer, G.Goal_Minute
from Goals G
where G.Goal_ID = 1
group by G.Goal_Scorer,G.Goal_Minute

/* Which teams participated in Stadium 974? */

select S.Stadium_Name, M.Home_Team, M.Away_Team
from Stadiums S
JOIN Matches M on S.Stadium_ID = M.Stadium_ID
where S.Stadium_Name LIKE '%974%'

/* Remove the locations column from the stadiums table. */

alter table Stadiums
drop column location

/* How long did the tournament last? */

select M.Date
from Matches M

select DATEDIFF(Day, '2022-11-20','2022-12-18') as Total_Days

/* Assume that there was a 175th goal scored in the Final for Argentina
by Lionel Messi in the 119th minute. Add the values to the goals table. */

Insert into Goals (Goal_ID, Goal_Scorer, Scored_Against, Round, 
					Goal_Minute, Time_Format, Team_ID, Match_ID)

Values ('175', 'Lionel Messi', 'France', 'FINAL', '119', 'Extra Time',
		'9', '64')


