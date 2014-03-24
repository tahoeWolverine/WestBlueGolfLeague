using System;
using System.Collections.Generic;
using System.Data.Odbc;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    class Program
    {
        static void Main(string[] args)
        {
            // 99 - 08
            // 09 - 11 - added week 0 score to players, added course name to week
            // 12 - 13 - added status to player

            const int lastYear = 2014;

            Dictionary<string, Player> namesToPlayers = new Dictionary<string, Player>();
            HashSet<string> setOfPlayers = new HashSet<string>();

            int teamIndex = 1,
                courseIndex = 1,
                weekIndex = 1,
                yearIndex = 1,
                yearDataIndex = 1,
                teamMatchupIndex = 1;

            Dictionary<string, Team> teamNameToTeam = new Dictionary<string, Team>();
            Dictionary<int, Week> weekNewIndexToWeek = new Dictionary<int, Week>();
            Dictionary<string, Course> courseNameToCourse = new Dictionary<string,Course>();
            Dictionary<int, Year> yearIdToYear = new Dictionary<int, Year>();
            Dictionary<int, Year> yearValueToYear = new Dictionary<int, Year>();
            Dictionary<int, TeamMatchup> teamMatchupIdMatchup = new Dictionary<int, TeamMatchup>();

            for (int year = 1999; year < lastYear; year++)
            {
                OdbcCommand cmd;
                OdbcConnection connection;

                string yearStr = Convert.ToString(year);
                
                Console.WriteLine("***** starting year " + yearStr + " *****");

                string connectionString = @"filedsn=..\..\file.dsn; Uid=Admin; Pwd=bigmatt; DBQ=..\..\..\..\Actual Data\access_db\golf" + yearStr.Substring(2) + ".mdb";

                try
                {
                    using (connection = new OdbcConnection(connectionString))
                    {
                        connection.Open();
                        cmd = new OdbcCommand();
                        cmd.Connection = connection;
                        
                        // Year
                        var newYear = new Year { Id = yearIndex++, Value = year, Complete = true };
                        yearIdToYear[newYear.Id] = newYear;
                        yearValueToYear[year] = newYear;

                        // Weeks
                        cmd.CommandText = "SELECT * FROM WeekTable";
                        Dictionary<int, Week> weekTempIdToWeek = new Dictionary<int, Week>();

                        using (var weekReader = cmd.ExecuteReader())
                        {
                            while (weekReader.Read())
                            {
                                string courseName = string.Empty;
                                int coursePar = 36;

                                Course course = null;

                                if (year < 2009)
                                {
                                    courseName = "UNKNOWN";
                                }
                                else
                                {
                                    courseName = weekReader.GetString(3);
                                    coursePar = Convert.ToInt32(weekReader.GetString(1));
                                }

                                if (!courseNameToCourse.TryGetValue(courseName, out course))
                                {

                                    course = new Course { Name = courseName, Id = courseIndex++, Par = coursePar };
                                    courseNameToCourse.Add(courseName, course);
                                }

                                var weekDate = weekReader.GetString(2).Replace("Sept.", "September");

                                Week week = new Week { TempId = weekReader.GetInt32(0), Course = course, Date = DateTime.Parse(weekDate), Id = weekIndex++ };
                                weekTempIdToWeek[week.TempId] = week;
                            }
                        }

                        // Teams
                        cmd.CommandText = "SELECT * FROM TeamTable";
                        Dictionary<int, Team> teamIdToTeam = new Dictionary<int, Team>();

                        using (var teamReader = cmd.ExecuteReader())
                        {
                            while (teamReader.Read())
                            {
                                var teamId = teamReader.GetInt32(0);
                                var teamName = teamReader.GetString(1);

                                Team team = null;

                                if (!teamNameToTeam.TryGetValue(teamName, out team))
                                {
                                    team = new Team() { Name = teamName, Id = teamIndex++ };
                                    teamNameToTeam.Add(teamName, team);
                                }

                                teamIdToTeam.Add(teamId, team);
                            }
                        }
                        
                        // Players
                        cmd.CommandText = "SELECT * FROM PlayerTable";
                        using (var reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string playerName = reader.GetString(0);
                                int playersTeam = reader.GetInt32(1);

                                Player player = null;
                                if (!namesToPlayers.TryGetValue(playerName, out player))
                                {
                                    player = new Player { Name = playerName, CurrentHandicap = 0 };
                                    namesToPlayers[playerName] = player;
                                    setOfPlayers.Add(playerName);
                                }

                                // Note that because we iterate over the years in chronological order,
                                // the last team associated with the player will be their current team.
                                player.Team = teamIdToTeam[playersTeam];

                                YearData yearData = new YearData { Player = player, Rookie = false, StartingHandicap = 0, FinishingHandicap = 0, Year = yearValueToYear[year], Id = yearDataIndex++ };
                            }
                        }

                        // Results
                        cmd.CommandText = "SELECT * FROM ResultsTable";
                        using (var resultsTableReader = cmd.ExecuteReader())
                        {
                            while (resultsTableReader.Read())
                            {
                                var player1 = resultsTableReader.GetString(2);
                                var player2 = resultsTableReader.GetString(6);

                                if (!setOfPlayers.Contains(player1))
                                {
                                    Console.WriteLine("player missing: " + player1);
                                }

                                if (!setOfPlayers.Contains(player2))
                                {
                                    Console.WriteLine("player missing: " + player2);
                                }
                            }
                        }

                        cmd.CommandText = "SELECT * FROM MatchTable";
                        using (var matchReader = cmd.ExecuteReader())
                        {
                            while (matchReader.Read())
                            {
                                int weekId = matchReader[2] == System.DBNull.Value ? -1 : (matchReader.GetInt32(2));
                                int matchId = matchReader[1] == System.DBNull.Value ? -1 : Convert.ToInt32(matchReader.GetString(1));

                                if (matchId == -1 || weekId == -1)
                                {
                                    continue;
                                }

                                var team1IdType = matchReader[3].GetType();
                                var team2IdType = matchReader[4].GetType();

                                if (team1IdType == System.DBNull.Value.GetType() || team2IdType == System.DBNull.Value.GetType()) 
                                {
                                    continue;
                                }

                                int team1Id = typeof(string) == team1IdType ? Convert.ToInt32(matchReader.GetString(3)) : matchReader.GetInt32(3);
                                int team2Id = typeof(string) == team2IdType ? Convert.ToInt32(matchReader.GetString(4)) : matchReader.GetInt32(4);

                                // TODO: What to do with this? Some values are DBNull in the database
                                // Are null entries equalivalent of "false"?
                                // string matchComplete = matchReader.GetString(0); 

                                var teamMatchup = new TeamMatchup { Week = weekTempIdToWeek[weekId], Id = teamMatchupIndex++, MatchComplete = true, Team1 = teamIdToTeam[team1Id], Team2 = teamIdToTeam[team2Id] };
                                teamMatchupIdMatchup[teamMatchup.Id] = teamMatchup;
                            }
                        }

                        cmd.CommandText = "SELECT * FROM ResultsTable";
                        //
                        //  TODO: Results table
                        //

                        connection.Close();
                    }
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message + "\r\n" + e.StackTrace);
                }
            }
        }
    }
}
