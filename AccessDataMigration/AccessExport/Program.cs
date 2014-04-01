using System;
using System.Collections.Generic;
using System.Data.Odbc;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    class Program
    {
        private static Player GetProperInvalidPlayer(string playerName, Player noShow, Player nonLeague)
        {
            if (playerName.ToLowerInvariant().Contains("xx") || playerName.ToLowerInvariant().Contains("no show"))
            {
                return noShow;
            }

            if (playerName.ToLowerInvariant().Contains("non-league sub"))
            {
                return nonLeague;
            }

            return null;
        }

        private static DataModel CreateDataModel()
        {
            // 99 - 08
            // 09 - 11 - added week 0 score to players, added course name to week
            // 12 - 13 - added status to player

            const int lastYear = 2014;

            Dictionary<string, Player> namesToPlayers = new Dictionary<string, Player>();
            ICollection<Player> extraInvalidPlayers = new List<Player>();
            HashSet<string> setOfPlayers = new HashSet<string>();

            int teamIndex = 1,
                courseIndex = 1,
                weekIndex = 1,
                yearIndex = 1,
                yearDataIndex = 1,
                teamMatchupIndex = 1,
                playerIndex = 1,
                matchupIndex = 1,
                resultIndex = 1;

            Dictionary<string, Team> teamNameToTeam = new Dictionary<string, Team>();
            Dictionary<int, Week> weekNewIndexToWeek = new Dictionary<int, Week>();
            Dictionary<string, Course> courseNameToCourse = new Dictionary<string,Course>();
            Dictionary<int, Year> yearIdToYear = new Dictionary<int, Year>();
            Dictionary<int, Year> yearValueToYear = new Dictionary<int, Year>();
            Dictionary<int, TeamMatchup> teamMatchupIdMatchup = new Dictionary<int, TeamMatchup>();
            ICollection<MatchUp> allMatchUps = new List<MatchUp>();
            ICollection<Result> allResults = new List<Result>();
            ICollection<YearData> yearDatas = new List<YearData>();

            // Add fake team and fake players (these will be used later)
            var teamOfLostPlayers = new Team { Id = teamIndex++, Name = "Dummy Team", ValidTeam = false };

            var noShowPlayer = new Player { Name = "No Show", CurrentHandicap = 0, Id = playerIndex++, ValidPlayer = false, Team = teamOfLostPlayers };
            namesToPlayers[noShowPlayer.Name] = noShowPlayer;
            var nonLeagueSub = new Player { Name = "Non-League Sub", CurrentHandicap = 0, Id = playerIndex++, ValidPlayer = false, Team = teamOfLostPlayers };
            namesToPlayers[nonLeagueSub.Name] = nonLeagueSub;

            for (int year = 1999; year < lastYear; year++)
            {
                OdbcCommand cmd;
                OdbcConnection connection;

                string yearStr = Convert.ToString(year);
                
                Console.WriteLine("***** starting year " + yearStr + " *****");

                string connectionString = @"filedsn=..\..\file.dsn; Uid=Admin; Pwd=bigmatt; DBQ=..\..\..\..\Actual Data\access_db\golf" + yearStr.Substring(2) + ".mdb";

                /*try
                {*/
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
                                    courseName = Convert.ToString(year) + " Course";
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

                                Week week = new Week { SeasonIndex = weekReader.GetInt32(0), Course = course, Date = DateTime.Parse(weekDate), Id = weekIndex++ };
                                weekTempIdToWeek[week.SeasonIndex] = week;
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

                                if (string.Equals(teamName, "Mentally Handicapped", StringComparison.OrdinalIgnoreCase))
                                {
                                    teamName = "Golf Gods";
                                }

                                Team team = null;

                                if (!teamNameToTeam.TryGetValue(teamName, out team))
                                {
                                    team = new Team() { Name = teamName, Id = teamIndex++, ValidTeam = true };
                                    teamNameToTeam.Add(teamName, team);
                                }

                                teamIdToTeam.Add(teamId, team);
                            }
                        }
                        // Add our dummy team :\
                        if (!teamIdToTeam.ContainsKey(0) && !teamIdToTeam.ContainsKey(99))
                        {
                            teamIdToTeam[0] = teamIdToTeam[99] = teamOfLostPlayers;
                        }
                        
                        // Players
                        cmd.CommandText = "SELECT * FROM PlayerTable";
                        using (var reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                string playerName = reader.GetString(0);
                                int playersTeam = reader.GetInt32(1);
                                int startingHandicap = 0;
                                bool isRookie = false;

                                // If the year is before 2009, we'll update the handicaps later
                                if (year >= 2009)
                                {
                                    int week0Score = reader.GetInt32(2);
                                    startingHandicap = week0Score; // -36;
                                }

                                // If we have player status, then set the rookie value based on status.  
                                // Otherwise, everyone is assumed a veteran.
                                if (year >= 2011) {
                                    var status = reader.GetString(3);
                                    isRookie = string.Equals(status, "new", StringComparison.OrdinalIgnoreCase) ? true : false;
                                }

                                Player player = null;
                                if (!namesToPlayers.TryGetValue(playerName, out player))
                                {
                                    player = new Player { Name = playerName, CurrentHandicap = startingHandicap, Id = playerIndex++, ValidPlayer = true };
                                    namesToPlayers[playerName] = player;
                                    setOfPlayers.Add(playerName);
                                }

                                // Note that because we iterate over the years in chronological order,
                                // the last team associated with the player will be their current team.
                                player.Team = teamIdToTeam[playersTeam];

                                // For years after 2009, current handicap will be updated when processing results.
                                player.CurrentHandicap = startingHandicap;

                                YearData yearData = new YearData { Player = player, Rookie = isRookie, StartingHandicap = startingHandicap, FinishingHandicap = startingHandicap, Year = yearValueToYear[year], Id = yearDataIndex++ };
                                yearDatas.Add(yearData);
                            }
                        }

                        // Matches
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

                                // TODO/NOTE: Treating null as "false".  Change if it should be treated as true.
                                bool matchComplete = matchReader[0].GetType() == DBNull.Value.GetType() || string.Equals(matchReader.GetString(0), "N", StringComparison.OrdinalIgnoreCase) ? false : true; 

                                var teamMatchup = new TeamMatchup { Week = weekTempIdToWeek[weekId], Id = teamMatchupIndex++, MatchComplete = matchComplete, Team1 = teamIdToTeam[team1Id], Team2 = teamIdToTeam[team2Id] };
                                teamMatchupIdMatchup[teamMatchup.Id] = teamMatchup;
                            }
                        }

                        // Results
                        cmd.CommandText = "SELECT * FROM ResultsTable";
                        using (var resultsReader = cmd.ExecuteReader())
                        {
                            while (resultsReader.Read())
                            {
                                var weekId = resultsReader.GetInt32(0);
                                var team1Id = resultsReader.GetInt32(1);
                                var score1 = resultsReader.GetInt32(3);
                                var points1 = resultsReader.GetInt32(4);
                                var team2Id = resultsReader.GetInt32(5);
                                var score2 = resultsReader.GetInt32(7);
                                var points2 = resultsReader.GetInt32(8);
                                var player1Name = resultsReader.GetString(2);
                                var player2Name = resultsReader.GetString(6);

                                // TODO: Can we throw this out?  It doesn't seem to make sense
                                if (team1Id == team2Id)
                                {
                                    //Console.WriteLine("bad datas in results");
                                    continue;
                                }

                                Player player1 = null;
                                Player player2 = null;

                                if (!setOfPlayers.Contains(player1Name))
                                {
                                    Console.WriteLine("player missing: " + player1Name);
                                }

                                if (!setOfPlayers.Contains(player2Name))
                                {
                                    Console.WriteLine("player missing: " + player2Name);
                                }

                                if (!namesToPlayers.TryGetValue(player1Name, out player1)) 
                                {
                                    var invalidPlayer = GetProperInvalidPlayer(player1Name, noShowPlayer, nonLeagueSub);

                                    // this is a special 2011
                                    if (invalidPlayer == null)
                                    {
                                        if (year != 2011)
                                        {
                                            throw new InvalidOperationException("invalid player found in year not 2011: " + player1Name);
                                        }

                                        invalidPlayer = new Player { Name = player1Name, Team = teamOfLostPlayers, ValidPlayer = false, Id = playerIndex++, CurrentHandicap = 0 };
                                        extraInvalidPlayers.Add(invalidPlayer);
                                    }

                                    player1 = invalidPlayer;
                                }

                                if (!namesToPlayers.TryGetValue(player2Name, out player2))
                                {
                                    var invalidPlayer = GetProperInvalidPlayer(player2Name, noShowPlayer, nonLeagueSub);

                                    // this is a special 2011
                                    if (invalidPlayer == null)
                                    {
                                        if (year != 2011)
                                        {
                                            throw new InvalidOperationException("invalid player found in year not 2011: " + player2Name);
                                        }

                                        invalidPlayer = new Player { Name = player2Name, Team = teamOfLostPlayers, ValidPlayer = false, Id = playerIndex++, CurrentHandicap = 0 };
                                        extraInvalidPlayers.Add(invalidPlayer);
                                    }

                                    player2 = invalidPlayer;
                                }

                                // okay, now that we have valid players, continue on.
                                Team team1 = teamIdToTeam[team1Id];

                                if (!teamIdToTeam.ContainsKey(team2Id))
                                {
                                    Console.WriteLine("Where is dis team: " + team2Id);
                                }

                                Team team2 = teamIdToTeam[team2Id];
                                Week week = weekTempIdToWeek[weekId];

                                // Team matchups should be unique based on team ID and week ID for a year.
                                var teamMatchups = teamMatchupIdMatchup.Values.Where(t => (t.Team1.Id == teamIdToTeam[team1Id].Id || t.Team2.Id == teamIdToTeam[team2Id].Id) && t.Week.SeasonIndex == weekId);

                                if (weekId == 0)
                                {
                                    // Take player1 and player2 and set their current handicaps

                                    // Set the week0 score in to the year data's starting handicap.
                                    int player1Handicap = score1;// -36;
                                    int player2Handicap = score2;// -36;
                                    
                                    var player1YearDatas = yearDatas.Where(y => y.Player.Id == player1.Id && y.Year.Value == year);
                                    var player2YearDatas = yearDatas.Where(y => y.Player.Id == player2.Id && y.Year.Value == year);
                                   
                                    // Some folks show up in the results table for week 0 even though they aren't valid 
                                    // for the year... if that makes sense.  In this case, we'll just throw out the handicap value.
                                    if (player1.ValidPlayer && team1Id != 99) 
                                    {
                                        // current handicap for a player will be overwritten with each year we pass.
                                        // So, eventually the last year iteration that will be seen will replace the current handicap 
                                        // with the correct value.
                                        player1.CurrentHandicap = player1Handicap;
                                        var player1YearDataForThisYear = player1YearDatas.First();
                                        player1YearDataForThisYear.StartingHandicap = player1YearDataForThisYear.FinishingHandicap = player1Handicap;
                                    }

                                    if (player2.ValidPlayer && team2Id != 99) {
                                        player2.CurrentHandicap = player2Handicap;
                                        var player2YearDataForThisYear = player2YearDatas.First();
                                        player2YearDataForThisYear.StartingHandicap = player2YearDataForThisYear.FinishingHandicap = player2Handicap;
                                    }

                                    // Console.WriteLine("could not find matchup.");
                                    continue;
                                }
                                else if (teamMatchups.Count() == 0)
                                {
                                    throw new InvalidOperationException("Should've found a team matchup... " + Convert.ToString(team1Id) + " " + Convert.ToString(weekId));
                                }

                                var teamMatchup = teamMatchups.First();

                                MatchUp matchup = new MatchUp { Id = matchupIndex++, TeamMatchup = teamMatchup, Player1 = player1, Player2 = player2 };
                                allMatchUps.Add(matchup);

                                Result player1Result = new Result { Player = player1, Matchup = matchup, Points = points1, Score = score1, Id = resultIndex++ };
                                allResults.Add(player1Result);

                                Result player2Result = new Result { Player = player2, Matchup = matchup, Points = points2, Score = score2, Id = resultIndex++ };
                                allResults.Add(player2Result);
                            }
                        }

                        connection.Close();
                    }


                /*}
                catch (Exception e)
                {
                    Console.WriteLine(e.Message + "\r\n" + e.StackTrace);
                    throw new Exception("wat", e);
                }*/
            }

            return new DataModel
            {
                Teams = new List<Team>(teamNameToTeam.Values) { teamOfLostPlayers },
                Years = yearValueToYear.Values,
                Players = namesToPlayers.Values.Concat(extraInvalidPlayers).ToList(),
                MatchUp = allMatchUps,
                TeamMatchup = teamMatchupIdMatchup.Values,
                Weeks = weekNewIndexToWeek.Values,
                YearDatas = yearDatas,
                Results = allResults,
                Courses = courseNameToCourse.Values,
            };
        }

        private static void ProcessHandicaps(DataModel dataModel)
        {
            var lastYear = dataModel.Years.Select(y => y.Value).Max();

            foreach (var p in dataModel.Players)
            {
                if (!p.ValidPlayer) continue;

                var yearDataForPlayer = dataModel.YearDatas.Where(y => y.Player.Id == p.Id);

                foreach (var yd in yearDataForPlayer)
                {
                    CalculateHandicaps(dataModel, p, yd);
                }
            }
        }

        private static void CalculateHandicaps(DataModel dataModel, Player player, YearData yearData)
        {
            // hackyyyy
            var week0Score = yearData.StartingHandicap;
            // we are done with that value, set starting handicap to real value
            yearData.StartingHandicap = yearData.StartingHandicap - 36;

            List<int> scores = new List<int>(4);

            for (var i = 0; i < 4; i++)
            {
                scores.Add(week0Score);
            }

            // TODO: Get results for player, then process them and find the handicap value.

            // TODO: set ending handicap value on year data.
        }

        static void Main(string[] args)
        {
            var dataModel = CreateDataModel();

            var mysqlGenerator = new MySqlGenerator();

            ProcessHandicaps(dataModel);

            Console.WriteLine(mysqlGenerator.Generate(dataModel));
        }
    }
}
