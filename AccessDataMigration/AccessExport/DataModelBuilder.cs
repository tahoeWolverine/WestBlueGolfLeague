using AccessExport.Entities;
using System;
using System.Collections.Generic;
using System.Data.Odbc;
using System.Diagnostics;
using System.Linq;

namespace AccessExport
{
    public class DataModelBuilder
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

        public DataModel CreateDataModel(string databaseDirectory, string fileDsnLocation)
        {
            // 99 - 08
            // 09 - 11 - added week 0 score to players, added course name to week
            // 12 - 13 - added status to player

            const int lastYear = 2015;

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
                resultIndex = 1,
                dataMigrationIndex = 1;

            Dictionary<string, Team> teamNameToTeam = new Dictionary<string, Team>();
            Dictionary<string, Course> courseNameToCourse = new Dictionary<string, Course>();
            Dictionary<int, Year> yearIdToYear = new Dictionary<int, Year>();
            Dictionary<int, Year> yearValueToYear = new Dictionary<int, Year>();
            Dictionary<int, TeamMatchup> teamMatchupIdMatchup = new Dictionary<int, TeamMatchup>();
            ICollection<MatchUp> allMatchUps = new List<MatchUp>();
            ICollection<Result> allResults = new List<Result>();
            ICollection<YearData> yearDatas = new List<YearData>();
            ICollection<Week> allWeeks = new List<Week>();
            ICollection<DataMigration> dataMigrationDatas = new List<DataMigration>();

            // Add fake team and fake players (these will be used later)
            var teamOfLostPlayers = new Team { Id = teamIndex++, Name = "Dummy Team", ValidTeam = false };

            var noShowPlayer = new Player(playerIndex++) { Name = "No Show", CurrentHandicap = 0, ValidPlayer = false };
            namesToPlayers[noShowPlayer.Name] = noShowPlayer;

            var nonLeagueSub = new Player(playerIndex++) { Name = "Non-League Sub", CurrentHandicap = 0, ValidPlayer = false };
            namesToPlayers[nonLeagueSub.Name] = nonLeagueSub;

            for (int year = 1999; year < lastYear; year++)
            {
                OdbcCommand cmd;
                OdbcConnection connection;

                string yearStr = Convert.ToString(year);

                string connectionString = @"filedsn=" + fileDsnLocation + "; Uid=Admin; Pwd=bigmatt; DBQ=" + databaseDirectory + @"\golf" + yearStr.Substring(2) + ".mdb";

                using (connection = new OdbcConnection(connectionString))
                {
                    connection.Open();
                    cmd = new OdbcCommand();
                    cmd.Connection = connection;

                    // Year
                    var newYear = new Year { Id = yearIndex++, Value = year, Complete = year == DateTime.Now.Year ? false : true };
                    yearIdToYear[newYear.Id] = newYear;
                    yearValueToYear[year] = newYear;

                    // add year data for both no show and non-league sub
                    {
                        var noShowPlayerYd = new YearData { FinishingHandicap = 20, Id = yearDataIndex++, Player = noShowPlayer, StartingHandicap = 20, Rookie = false, Team = teamOfLostPlayers, Week0Score = 99, Year = newYear };
                        yearDatas.Add(noShowPlayerYd);
                        noShowPlayer.AddYearData(noShowPlayerYd);
                    }

                    {
                        var nonLeagueSubYd = new YearData { FinishingHandicap = 20, Id = yearDataIndex++, Player = nonLeagueSub, StartingHandicap = 20, Rookie = false, Team = teamOfLostPlayers, Week0Score = 99, Year = newYear };
                        yearDatas.Add(nonLeagueSubYd);
                        nonLeagueSub.AddYearData(nonLeagueSubYd);
                    }

                    // Data migration
                    DateTime migrationDate = DateTime.UtcNow;

                    if (year != DateTime.Now.Year)
                    {
                        migrationDate.AddDays(20);
                    }

                    var dataMigration = new DataMigration { Id = dataMigrationIndex++, Year = newYear, Notes = yearStr, DataMigrationDate = migrationDate };

                    dataMigrationDatas.Add(dataMigration);

                    // Weeks
                    cmd.CommandText = "SELECT * FROM WeekTable";
                    Dictionary<int, Week> weekTempIdToWeek = new Dictionary<int, Week>();

                    using (var weekReader = cmd.ExecuteReader())
                    {
                        while (weekReader.Read())
                        {
                            string courseName = string.Empty;
                            int coursePar = Convert.ToInt32(weekReader.GetString(1));

                            Course course = null;

                            if (year < 2009)
                            {
                                courseName = Convert.ToString(year) + " Course " + Convert.ToString(coursePar);
                            }
                            else
                            {
                                courseName = weekReader.GetString(3);
                                //coursePar = Convert.ToInt32(weekReader.GetString(1));
                            }

                            if (!courseNameToCourse.TryGetValue(courseName, out course))
                            {

                                course = new Course { Name = courseName, Id = courseIndex++, Par = coursePar };
                                courseNameToCourse.Add(courseName, course);
                            }

                            var weekDate = weekReader.GetString(2).Replace("Sept.", "September");

                            Week week = new Week { SeasonIndex = weekReader.GetInt32(0), Course = course, Date = DateTime.Parse(weekDate), Id = weekIndex++, Year = newYear };

                            if (week.SeasonIndex != 0)
                            {
                                allWeeks.Add(week);
                            }

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
                                bool validTeam = true;

                                // Garbage team from 2005. Throw it awayyy
                                if (string.Equals(teamName, "Handicap", StringComparison.OrdinalIgnoreCase))
                                {
                                    validTeam = false;
                                }

                                team = new Team() { Name = teamName, Id = teamIndex++, ValidTeam = validTeam };
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
                            int week0Score = -1;

                            // If the year is before 2009, we'll update the handicaps later
                            if (year >= 2009)
                            {
                                week0Score = reader.GetInt32(2);
                                startingHandicap = week0Score - 36;
                            }

                            // If we have player status, then set the rookie value based on status.  
                            // Otherwise, everyone is assumed a veteran.
                            if (year >= 2011)
                            {
                                var status = reader.GetString(3);
                                isRookie = string.Equals(status, "new", StringComparison.OrdinalIgnoreCase) ? true : false;
                            }

                            Player player = null;
                            if (!namesToPlayers.TryGetValue(playerName, out player))
                            {
                                player = new Player(playerIndex++) { Name = playerName, CurrentHandicap = startingHandicap, ValidPlayer = true };
                                namesToPlayers[playerName] = player;
                                setOfPlayers.Add(playerName);
                            }

                           
                            // TODO: Needs to be something else
                            //player.Team = teamIdToTeam[playersTeam];

                            // Current handicap will be updated by handicap code later
                            player.CurrentHandicap = startingHandicap;

                            // finishing handicap will be updated later.
                            YearData yearData = new YearData 
                                                    { 
                                                        Player = player, 
                                                        Rookie = isRookie, 
                                                        StartingHandicap = startingHandicap, 
                                                        FinishingHandicap = startingHandicap, 
                                                        Year = yearValueToYear[year], Id = yearDataIndex++, 
                                                        Team = teamIdToTeam[playersTeam],
                                                        Week0Score = week0Score == -1 ? 0 : week0Score // only years > 2009 will have a valid value here.
                                                    };

                            yearDatas.Add(yearData);
                            player.AddYearData(yearData);
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
                                                        
                            if (!matchComplete && team1Id == 0 && team2Id == 0)
                            {
                                continue;
                            }

                            var teamMatchup = new TeamMatchup { Week = weekTempIdToWeek[weekId], Id = teamMatchupIndex++, MatchComplete = matchComplete, Team1 = teamIdToTeam[team1Id], Team2 = teamIdToTeam[team2Id], MatchId = matchId };
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
                            //if (team1Id == team2Id && weekId != 0)
                            //{
                            //    throw new ArgumentException("team1: " + team1Id + ", team2: " + team2Id + ", week: " + weekId);
                            //}

                            Player player1 = null;
                            Player player2 = null;

                            if (!setOfPlayers.Contains(player1Name))
                            {
                                //Console.WriteLine("player missing: " + player1Name);
                            }

                            if (!setOfPlayers.Contains(player2Name))
                            {
                                //Console.WriteLine("player missing: " + player2Name);
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

                                    invalidPlayer = new Player(playerIndex++) { Name = player1Name, ValidPlayer = false, CurrentHandicap = 0 };
                                    var invalidPlayerYd = new YearData { Year = newYear, Week0Score = 99, StartingHandicap = 20, FinishingHandicap = 20, Id = yearDataIndex++, Team = teamOfLostPlayers, Rookie = false, Player = invalidPlayer };
                                    invalidPlayer.AddYearData(invalidPlayerYd);
                                    yearDatas.Add(invalidPlayerYd);
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

                                    invalidPlayer = new Player(playerIndex++) { Name = player2Name, ValidPlayer = false, CurrentHandicap = 0 };
                                    var invalidPlayerYd = new YearData { Year = newYear, Week0Score = 99, StartingHandicap = 20, FinishingHandicap = 20, Id = yearDataIndex++, Team = teamOfLostPlayers, Rookie = false, Player = invalidPlayer };
                                    invalidPlayer.AddYearData(invalidPlayerYd);
                                    yearDatas.Add(invalidPlayerYd);
                                    extraInvalidPlayers.Add(invalidPlayer);
                                }

                                player2 = invalidPlayer;
                            }

                            // okay, now that we have valid players, continue on.
                            Team team1 = teamIdToTeam[team1Id];

                            if (!teamIdToTeam.ContainsKey(team2Id))
                            {
                                //Console.WriteLine("Where is dis team: " + team2Id);
                            }

                            Team team2 = teamIdToTeam[team2Id];
                            Week week = weekTempIdToWeek[weekId];

                            // Week 0's are a really special case... we allow team IDs to match here.
                            if (weekId == 0)
                            {
                                // Take player1 and player2 and set their current handicaps

                                // Set the week0 score in to the year data's starting handicap.
                                int player1Handicap = score1 - 36;
                                int player2Handicap = score2 - 36;

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
                                    player1YearDataForThisYear.Week0Score = score1;
                                    // finishing handicap will be fixed later when we process handicaps.
                                    player1YearDataForThisYear.StartingHandicap = player1YearDataForThisYear.FinishingHandicap = player1Handicap;
                                }

                                if (player2.ValidPlayer && team2Id != 99)
                                {
                                    player2.CurrentHandicap = player2Handicap;
                                    var player2YearDataForThisYear = player2YearDatas.First();
                                    player2YearDataForThisYear.Week0Score = score2;
                                    // finishing handicap will be fixed later when we process handicaps.
                                    player2YearDataForThisYear.StartingHandicap = player2YearDataForThisYear.FinishingHandicap = player2Handicap;
                                }

                                // Console.WriteLine("could not find matchup.");
                                continue;
                            }

                            // Team matchups should be unique based on team ID and week ID for a year.
                            var teamMatchups = teamMatchupIdMatchup.Values.Where(t => ((t.Team1.Id == teamIdToTeam[team1Id].Id || t.Team2.Id == teamIdToTeam[team2Id].Id) || (t.Team1.Id == teamIdToTeam[team2Id].Id || t.Team2.Id == teamIdToTeam[team1Id].Id)) && t.Week.SeasonIndex == weekId && t.Week.Year.Value == year);

                            if (teamMatchups.Count() == 0)
                            {
                                throw new InvalidOperationException("Should've found a team matchup... " + Convert.ToString(team1Id) + " " + Convert.ToString(weekId));
                            }

                            if (team1Id == team2Id && year != 2011)
                            {
                                throw new ArgumentException("Teams can only play eachother in week 0 and 2011.");
                            }

                            // AGerber - 7/3/2014 allow no show/no show matches to show up in data.
                            // Don't do anything with invalid players that play themselves!
                            //if (player1.Id == 1 && player2.Id == 1)
                            //{
                            //    continue;
                            //}

                            var teamMatchup = teamMatchups.First();

                            MatchUp matchup = new MatchUp { Id = matchupIndex++, TeamMatchup = teamMatchup, Player1 = player1, Player2 = player2 };
                            allMatchUps.Add(matchup);

                            Result player1Result = new Result { Year = newYear, Player = player1, Matchup = matchup, Points = points1, Score = score1, Id = resultIndex++, Team = team1 };
                            allResults.Add(player1Result);
                            team1.AddResult(player1Result);
                            player1.AddResult(player1Result);

                            Result player2Result = new Result { Year = newYear, Player = player2, Matchup = matchup, Points = points2, Score = score2, Id = resultIndex++, Team = team2 };
                            allResults.Add(player2Result);
                            team2.AddResult(player2Result);
                            player2.AddResult(player2Result);

                            matchup.Result1 = player1Result;
                            matchup.Result2 = player2Result;
                        }
                    }

                    connection.Close();
                }
            }

            DataModel dm = new DataModel
            {
                Teams = new List<Team>(teamNameToTeam.Values) { teamOfLostPlayers },
                Years = yearValueToYear.Values,
                Players = namesToPlayers.Values.Concat(extraInvalidPlayers).ToList(),
                MatchUp = allMatchUps,
                TeamMatchup = teamMatchupIdMatchup.Values,
                Weeks = allWeeks,
                YearDatas = yearDatas,
                Results = allResults,
                Courses = courseNameToCourse.Values,
                LeaderBoardDatas = new List<LeaderBoardData>(),
                LeaderBoards = new List<LeaderBoard>(),
                DataMigrations = dataMigrationDatas
            };

            ProcessHandicaps(dm);

            BuildLeaderboards(dm);

            return dm;
        }

        private static void ProcessHandicaps(DataModel dataModel)
        {
            var lastYear = dataModel.Years.Select(y => y.Value).Max();

            foreach (var p in dataModel.Players)
            {
                if (!p.ValidPlayer) continue;

                var yearDataForPlayer = dataModel.YearDatas.Where(y => y.Player.Id == p.Id).OrderBy(y => y.Year.Value).ToList();

                for (int i = 0; i < yearDataForPlayer.Count; i++)
                {
                    var yd = yearDataForPlayer[i];
                    bool isNewestYear = i == yearDataForPlayer.Count - 1;

                    if (yd.Year.Value >= 2011)
                    {
                        //CalculateIncorrectHandicaps(dataModel, p, yd, isNewestYear);
                        CalculateHandicaps(dataModel, p, yd, isNewestYear);
                    }
                    else if (yd.Year.Value >= 2009)
                    {
                        //CalculateIncorrectHandicaps(dataModel, p, yd, isNewestYear);
                        CalculateHandicaps(dataModel, p, yd, isNewestYear);
                    }
                    else
                    {
                        CalculateHandicapsUnder2009(dataModel, p, yd, isNewestYear);
                    }
                }
            }
        }

        private static void CalculateHandicaps20092010(DataModel dataModel, Player player, YearData yearData, bool isNewestYear)
        {

        }

        private static void CalculateHandicapsUnder2009(DataModel dataModel, Player player, YearData yearData, bool isNewestYear)
        {

        }

        private static void CalculateIncorrectHandicaps(DataModel dataModel, Player player, YearData yearData, bool isNewestYear)
        {
            var week0Score = yearData.Week0Score;
            var isRookie = yearData.Rookie;

            // Get all results for a player for the year.
            var resultsForPlayerForYear = dataModel.Results.Where(x => x.Player.Id == player.Id && x.Matchup.TeamMatchup.Week.Year.Value == yearData.Year.Value).OrderBy(x => x.Matchup.TeamMatchup.Week.SeasonIndex).ToList();


            int scoreIndex = 4;

            List<int> scores = new List<int>(4);

            for (var i = 0; i < 5; i++)
            {
                scores.Add(week0Score);
            }


            foreach (var result in resultsForPlayerForYear)
            {
                result.PriorHandicap = priorHandicapWithScores(scores, scoreIndex);
                int handicapForWeek = result.Score - result.Matchup.TeamMatchup.Week.Course.Par;

                // Can't be larger than 20
                if (handicapForWeek > 20)
                {
                    handicapForWeek = 20;
                }

                scores.Add(handicapForWeek);

                scoreIndex++;
            }

            if (isNewestYear)
            {
                player.CurrentHandicap = priorHandicapWithScores(scores, scoreIndex);
            }

            yearData.FinishingHandicap = priorHandicapWithScores(scores, scoreIndex);
        }

        private static void CalculateHandicaps(DataModel dataModel, Player player, YearData yearData, bool isNewestYear)
        {
            var week0Score = yearData.Week0Score;
            var isRookie = yearData.Rookie;

            // Get all results for a player for the year.
            var resultsForPlayerForYear = dataModel.Results.Where(x => x.Player.Id == player.Id && x.Matchup.TeamMatchup.Week.Year.Value == yearData.Year.Value).OrderBy(x => x.Matchup.TeamMatchup.Week.SeasonIndex).ToList();

            HandicapResult handicapResult = null, firstHandicapResult = null;

            for (int i = resultsForPlayerForYear.Count - 1; i >= 0; i--)
            {
                var subResults = resultsForPlayerForYear.Take(i + 1);

                handicapResult = HandicapsForResults(subResults, week0Score, isRookie);

                // bleh this could be cleaned up.
                if (i == 0) 
                {
                    resultsForPlayerForYear[i].PriorHandicap = week0Score - 36;
                }

                if (i == resultsForPlayerForYear.Count - 1)
                {
                    firstHandicapResult = handicapResult;
                }
                else 
                {
                    resultsForPlayerForYear[i + 1].PriorHandicap = handicapResult.Handicap;
                }
            }

            // handicap result will be null if no results for the year yet.
            if (firstHandicapResult != null)
            {
                if (isNewestYear)
                {
                    player.CurrentHandicap = firstHandicapResult.Handicap;
                }

                yearData.FinishingHandicap = firstHandicapResult.Handicap;
            }
        }

        private static HandicapResult HandicapsForResults(IEnumerable<Result> results, int week0Score, bool isRookie)
        {
            LinkedList<ScoreResult> copiedScores = new LinkedList<ScoreResult>(results.Select(x => new ScoreResult(x)));

            int numberOfWeekZeroesToAdd = 0;

            // nasty... look at maybe cleaning up
            if (copiedScores.Count == 4)
            {
                numberOfWeekZeroesToAdd = 1;
            }
            else if (copiedScores.Count < 4)
            {
                if (!isRookie)
                {
                    numberOfWeekZeroesToAdd = copiedScores.Count == 4 ? 1 : 4 - copiedScores.Count;
                }
                else
                {
                    numberOfWeekZeroesToAdd = 1;
                }
            }

            for (int i = 0; i < numberOfWeekZeroesToAdd; i++)
            {
                copiedScores.AddLast(ScoreResult.CreateWeek0Score(week0Score));
            }

            if (copiedScores.Count >= 5)
            {
                var lastFiveScores = copiedScores.Skip(copiedScores.Count - 5);

                int max = 0,
                    handicapSum = 0,
                    weekWithMax = 0;

                LinkedList<int> weeksUsed = new LinkedList<int>();

                foreach (var score in lastFiveScores)
                {
                    var handicapSplit = score.ScoreOverPar;

                    if (handicapSplit > max)
                    {
                        max = handicapSplit;
                        weekWithMax = score.Week;
                    }

                    weeksUsed.AddLast(score.Week);
                    handicapSum += handicapSplit;
                }

                weeksUsed.Remove(weekWithMax);

                return new HandicapResult { Handicap = CalcHandicapFromScores(handicapSum - max, 4), WeeksUsed = weeksUsed };
            }
            else
            {
                LinkedList<int> weeksUsed = new LinkedList<int>();

                int sum = 0;

                foreach (var score in copiedScores)
                {
                    weeksUsed.AddLast(score.Week);
                    sum += score.ScoreOverPar;
                }

                return new HandicapResult { Handicap = CalcHandicapFromScores(sum, copiedScores.Count), WeeksUsed = weeksUsed };
            }
        }

        private static int CalcHandicapFromScores(int scoreTotal, int scoreCount)
        {
            double averageScoreAbovePar = ((double)scoreTotal / (double)scoreCount);
            double remainder = averageScoreAbovePar - (scoreTotal / scoreCount);

            return Math.Min((int)(averageScoreAbovePar + (remainder >= .5 ? 1 : 0)), 20);
        }


        // TODO: Update this method with correct handicap calculation (needs to factor in previous years (< 2011) and new/old player distinction)
        private static int priorHandicapWithScores(List<int> scores, int index)
        {
            List<int> usedScores = new List<int> { scores[index], scores[index - 1], scores[index - 2], scores[index - 3], scores[index - 4] };
            int max = -39339;
            int handicapTotal = 0;

            foreach (var score in usedScores)
            {
                if (score > max)
                {
                    max = score;
                }
                handicapTotal += score;
            }

            handicapTotal -= max;
            double handicapAsDouble = ((double)handicapTotal / 4.0f) + .5;

            int finalHandicap = (int)handicapAsDouble;

            return finalHandicap;
        }

        private void BuildLeaderboards(DataModel dataModel)
        {
            const int Ratio = 1;
            const int NetDifference = 2;

            foreach (Year year in dataModel.Years)
            {
                ISet<int> setOfTeamsForYear = new HashSet<int>();
                var matchUpsForYear = dataModel.TeamMatchup.Where(x => x.Week.Year.Value == year.Value);

                foreach (TeamMatchup tm in matchUpsForYear)
                {
                    setOfTeamsForYear.Add(tm.Team1.Id);
                    setOfTeamsForYear.Add(tm.Team2.Id);
                }

                var teamsForYear = dataModel.Teams.Where(x => setOfTeamsForYear.Contains(x.Id) && x.ValidTeam).ToList();

                TeamBoard(dataModel, "Team Ranking", "team_ranking", teamsForYear, year, false, (team, dm) => team.TotalPointsForYear(year));

                TeamBoard(dataModel, "Average Handicap", "team_avg_handicap", teamsForYear, year, true, (team, dm) => team.AverageHandicapForYear(year));

                TeamBoard(dataModel, "Win/Loss Ratio", "team_win_loss_ratio", teamsForYear, year, false, (team, dm) => team.RecordRatioForYear(year), Ratio);

                // TODO: This board is currently broken b/c handicaps for years < 2011 are broken.
                TeamBoard(dataModel, "Season Improvement", "team_season_improvement", teamsForYear, year, true, (team, dm) => team.ImprovedInYear(year), NetDifference);

                TeamBoard(dataModel, "Avg. Opp. Score", "team_avg_opp_score", teamsForYear, year, true, (team, dm) => team.AverageOpponentScoreForYear(year));

                TeamBoard(dataModel, "Avg. Opp. Net Score", "team_avg_opp_net_score", teamsForYear, year, true, (team, dm) => team.AverageOpponentNetScoreForYear(year), NetDifference);

                TeamBoard(dataModel, "Average Score", "team_avg_score", teamsForYear, year, true, (team, dm) => team.AverageScoreForYear(year));

                TeamBoard(dataModel, "Average Net Score", "team_avg_net_score", teamsForYear, year, true, (team, dm) => team.AverageNetScoreForYear(year), NetDifference);

                TeamBoard(dataModel, "Ind. W/L Ratio", "team_ind_win_loss_record", teamsForYear, year, false, (team, dm) => team.IndividualRecordRatioForYear(year), Ratio);

                TeamBoard(dataModel, "Total Match Wins", "team_total_match_wins", teamsForYear, year, false, (team, dm) => team.IndividualRecordForYear(year)[0]);

                TeamBoard(dataModel, "Points in a Week", "team_most_points_in_week", teamsForYear, year, false, (team, dm) => team.MostPointsInWeekForYear(year));

                TeamBoard(dataModel, "Avg. Margin of Victory", "team_avg_margin_victory", teamsForYear, year, false, (team, dm) => team.AverageMarginOfVictoryForYear(year));

                TeamBoard(dataModel, "Avg. Margin of Net Victory", "team_avg_margin_net_victory", teamsForYear, year, false, (team, dm) => team.AverageMarginOfNetVictoryForYear(year), NetDifference);


                var allPlayersForYear = dataModel.Players.Where(p => p.YearDatas.Any(yd => yd.Year.Value == year.Value) && p.ValidPlayer).ToList();

                PlayerBoard(dataModel, "Best Score", "player_best_score", allPlayersForYear, year, true, (p, dm) => p.LowRoundForYear(year));

                PlayerBoard(dataModel, "Best Net Score", "player_net_best_score", allPlayersForYear, year, true, (p, dm) => p.LowNetForYear(year), NetDifference);

                PlayerBoard(dataModel, "Handicap", "player_handicap", allPlayersForYear, year, true, (p, dm) => p.FinishingHandicapInYear(year));

                PlayerBoard(dataModel, "Average Points", "player_avg_points", allPlayersForYear, year, false, (p, dm) => p.AveragePointsInYear(year));

                PlayerBoard(dataModel, "Win/Loss Ratio", "player_win_loss_ratio", allPlayersForYear, year, false, (p, dm) => p.RecordRatioForYear(year), Ratio);

                PlayerBoard(dataModel, "Season Improvement", "player_season_improvement", allPlayersForYear, year, true, (p, dm) => p.ImprovedInYear(year), NetDifference);

                PlayerBoard(dataModel, "Avg. Opp. Score", "player_avg_opp_score", allPlayersForYear, year, true, (p, dm) => p.AverageOpponentScoreForYear(year));

                PlayerBoard(dataModel, "Avg. Opp. Net Score", "player_avg_opp_net_score", allPlayersForYear, year, true, (p, dm) => p.AverageOpponentNetScoreForYear(year), NetDifference);

                PlayerBoard(dataModel, "Average Score", "player_avg_score", allPlayersForYear, year, true, (p, dm) => p.AverageScoreForYear(year));

                PlayerBoard(dataModel, "Average Net Score", "player_avg_net_score", allPlayersForYear, year, true, (p, dm) => p.AverageNetScoreForYear(year), NetDifference);

                PlayerBoard(dataModel, "Points in a Match", "player_points_in_match", allPlayersForYear, year, false, (p, dm) => p.MostPointsInMatchForYear(year));

                PlayerBoard(dataModel, "Total Points", "player_total_points", allPlayersForYear, year, false, (p, dm) => p.TotalPointsForYear(year));

                PlayerBoard(dataModel, "Total Wins", "player_total_wins", allPlayersForYear, year, false, (p, dm) => p.RecordForYear(year)[0]);

                PlayerBoard(dataModel, "Avg. Margin of Victory", "player_avg_margin_victory", allPlayersForYear, year, false, (p, dm) => p.AverageMarginOfVictoryForYear(year));

                PlayerBoard(dataModel, "Avg. Margin of Net Victory", "player_avg_margin_net_victory", allPlayersForYear, year, false, (p, dm) => p.AverageMarginOfNetVictoryForYear(year), NetDifference);

                PlayerBoard(dataModel, "Total Rounds", "player_total_rounds_for_year", allPlayersForYear, year, false, (p, dm) => p.TotalRoundsForYear(year));
            }

        }

        private int LeaderBoardIdIndex = 1;
        private int LeaderBoardDataIdIndex = 1;
        private int Priority = 1;

        private LeaderBoard LeaderBoardByKey(DataModel dataModel, string key, bool isPlayerBoard, string name, int formatType)
        {
            var lb = dataModel.LeaderBoards.FirstOrDefault(x => string.Equals(key, x.Key));

            if (lb == null)
            {
                lb = new LeaderBoard { Key = key, Name = name, IsPlayerBoard = isPlayerBoard, Id = this.LeaderBoardIdIndex++, Priority = this.Priority++, FormatType = formatType };
                dataModel.LeaderBoards.Add(lb);
            }

            return lb;
        }

        // TODO: implement this method.
        private string FormatLeaderBoardValue(double value, int format)
        {
            switch (format)
            {
                case 1:
                    return string.Format("{0:0.000}", value);
                    break;
                case 2:
                    return string.Format("{0:+0.##;-0.##}", value);
                case 0:
                default:
                    return string.Format("{0:0.##}", value);
            }
        }

        private void TeamBoard(DataModel dataModel, string name, string key, ICollection<Team> teams, Year year, bool isAsc, Func<Team, DataModel, double> valueFunc, int formatType = 0)
        {
            LeaderBoard lb = this.LeaderBoardByKey(dataModel, key, false, name, formatType);

            List<LeaderBoardData> datasWhichNeedRanks = new List<LeaderBoardData>();

            foreach (var team in teams)
            {
                var results = dataModel.Results.Where(x => (x.Matchup.TeamMatchup.Team1.Id == team.Id || x.Matchup.TeamMatchup.Team2.Id == team.Id) && x.Year.Value == year.Value);

                if (results.Count() == 0) continue;

                double value = valueFunc(team, dataModel);
                LeaderBoardData lbd = new LeaderBoardData { Id = LeaderBoardDataIdIndex++, IsPlayer = false, Team = team, Value = value, FormattedValue = FormatLeaderBoardValue(value, formatType), LeaderBoard = lb, Year = year };
                datasWhichNeedRanks.Add(lbd);

                dataModel.LeaderBoardDatas.Add(lbd);
            }

            this.SortAndRankLeaderBoardData(datasWhichNeedRanks, isAsc);
        }

        private void PlayerBoard(DataModel dataModel, string name, string key, ICollection<Player> players, Year year, bool isAsc, Func<Player, DataModel, double> valueFunc, int formatType = 0)
        {
            LeaderBoard lb = this.LeaderBoardByKey(dataModel, key, true, name, formatType);

            List<LeaderBoardData> datasToSort = new List<LeaderBoardData>();

            int noResForYear = 0;
            foreach (var player in players)
            {
                var results = player.AllResultsForYear(year);

                if (results.Count() == 0)
                {
                    noResForYear++;
                    continue;
                }

                double value = valueFunc(player, dataModel);
                LeaderBoardData lbd = new LeaderBoardData { Id = LeaderBoardDataIdIndex++, IsPlayer = true, Player = player, Value = value, FormattedValue = FormatLeaderBoardValue(value, formatType), LeaderBoard = lb, Year = year };

                datasToSort.Add(lbd);
                dataModel.LeaderBoardDatas.Add(lbd);
            }

            this.SortAndRankLeaderBoardData(datasToSort, isAsc);
        }

        private void SortAndRankLeaderBoardData(IEnumerable<LeaderBoardData> datas, bool isAsc)
        {
            if (isAsc)
            {
                datas = datas.OrderBy(x => x.Value).ToList();
            }
            else
            {
                datas = datas.OrderByDescending(x => x.Value).ToList();
            }

            int rank = 0, count = 0;
            double previousValue = double.MaxValue;

            foreach (var lbd in datas)
            {
                count++;

                if (lbd.Value != previousValue)
                {
                    rank = count;
                }

                lbd.Rank = rank;
                previousValue = lbd.Value;
            }
        }
    }
}
