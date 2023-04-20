USE FWC_Qatar_2022
GO

/* How many goals were scored in the tournament? */
SELECT COUNT(G.Goal_ID) AS Total_Goals_Scored
FROM Goals G

/* How many of them were scored in the group and knockout stage? */
SELECT G.Round, COUNT(G.Goal_ID) as Goals_Per_Round
FROM Goals G
WHERE G.Round IN (
'Group Stage', 'Round of 16', 'Quarter Final', 
'Semi Final', '3rd Place Playoff', 'Final'
)
GROUP BY G.Round
ORDER BY Goals_Per_Round DESC

/* What were the amount of games won by each group winner? */
SELECT G.Team_Name, T.Wins, G.Position
FROM Groups G
JOIN Teams T ON G.Team_ID = T.Team_ID
WHERE G.Position = '1'
GROUP BY G.Team_Name, T.Wins, G.Position
ORDER BY T.Wins desc

/* Show the goals scored and conceded for the teams that 
were eliminated in the group stage.*/
SELECT T.Team_Name, T.Goals_Scored, T.Goals_Conceded, T.Highest_Finish
FROM Teams T
WHERE T.Highest_Finish = 'Group Stage'
GROUP BY T.Team_Name, T.Goals_Scored, T.Goals_Conceded, T.Highest_Finish
ORDER BY T.Team_Name

/* How many goals were scored in additional time? */
SELECT G.Time_Format, COUNT(G.Goal_ID) AS Number_of_Goals
FROM Goals G
WHERE G.Time_Format = 'Additional Time'
GROUP BY G.Time_Format

/* Which team had the highest amount of bookings (Red + Yellow Cards) */
SELECT TOP 1 T.Team_Name, 
MAX(T.Yellow_Cards + T.Red_Cards) AS Number_of_Bookings
FROM Teams T
GROUP BY T.Team_Name
ORDER BY Number_of_Bookings DESC

/* Which team(s) collected no single point in the group stages? */
SELECT T.Team_Name, G.Points_Gained	
FROM Groups G 
JOIN Teams T ON G.Group_ID = T.Group_ID
WHERE G.Points_Gained = '0'
GROUP BY T.Team_Name, G.Points_Gained


/* Which player scored the highest number of goals? */
SELECT TOP 1 G.Goal_Scorer, COUNT(G.Goal_ID) AS Number_of_Goals
FROM Goals G
GROUP BY G.Goal_Scorer
ORDER BY Number_of_Goals DESC

/* What was the latest minute in which the top scorer scored a goal? */
SELECT TOP 1 G.Goal_Scorer, G.Goal_Minute 
FROM Goals G
WHERE G.Goal_Scorer = 'Kylian Mbappe'
GROUP BY G.Goal_Scorer, G.Goal_Minute
ORDER BY Goal_Minute 

/* On which date was the last game at Al Janoub Stadium played? */
SELECT TOP 1 M.Date, M.Stadium_Name
FROM Matches M
WHERE M.Stadium_Name = 'Al Janoub Stadium'
GROUP BY M.Stadium_Name, M.Date
ORDER BY M.Date desc

/* What was the highest possible round that all 8 group winners could reach? */
SELECT G.Team_Name, T.Highest_Finish
FROM Groups G
JOIN Teams T on G.Group_ID = T.Group_ID
WHERE G.Position = '1'
GROUP BY G.Team_Name, T.Highest_Finish, G.Position
ORDER BY G.Team_Name

/* What were the teams that Lionel Messi and Kylian Mbappe scored against. */
SELECT G.Goal_Scorer, G.Scored_Against
FROM Goals G
WHERE G.Goal_Scorer = 'Lionel Messi' OR G.Goal_Scorer = 'Kylian Mbappe'
GROUP BY G.Goal_Scorer, G.Scored_Against

/* How many goals were scored in Extra time (additional 30 mins in knockout)? */
SELECT G.Time_Format, COUNT(G.Goal_ID) AS Number_of_Goals
FROM Goals G
WHERE G.Time_Format LIKE '%Extra Time%'
GROUP BY G.Time_Format

/* Which teams had a negative goal difference? */
SELECT T.Team_Name, (T.Goals_Scored - T.Goals_Conceded) AS Goal_Difference
FROM Teams T
GROUP BY Team_Name, T.Goals_Scored, T.Goals_Conceded
HAVING T.Goals_Scored - T.Goals_Conceded < 0
ORDER BY Goal_Difference

/* Which player scored the opening goal of the tournament and in which minute? */

SELECT G.Goal_Scorer, G.Goal_Minute
FROM Goals G
WHERE G.Goal_ID = 1
GROUP BY G.Goal_Scorer,G.Goal_Minute

/* Which teams participated in Stadium 974? */

SELECT S.Stadium_Name, M.Home_Team, M.Away_Team
FROM Stadiums S
JOIN Matches M ON S.Stadium_ID = M.Stadium_ID
WHERE S.Stadium_Name LIKE '%974%'

/* Remove the locations column from the stadiums table. */

ALTER TABLE Stadiums
DROP COLUMN location

/* How long did the tournament last? */

SELECT M.Date
FROM Matches M
WHERE M.Match_ID IN (1, 64)

SELECT DATEDIFF(Day, '2022-11-20','2022-12-18') AS Total_Days

/* Assume that there was a 173rd goal scored in the Final for Argentina
by Lionel Messi in the 119th minute. Add the values to the goals table. */

INSERT INTO Goals (
Goal_ID, Goal_Scorer, Scored_Against, Round, 
     Goal_Minute, Time_Format, Team_ID, Match_ID
)

VALUES (173, 'Lionel Messi', 'France', 'FINAL', 119, 'Extra Time',
  9, 64)


