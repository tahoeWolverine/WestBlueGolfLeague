using AccessExport.Entities;
using System;
using System.Collections.Generic;
using System.Data.Odbc;
using System.Linq;

namespace AccessExport
{
    class DataModelBuilder
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

        public DataModel CreateDataModel()
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
            Dictionary<string, Course> courseNameToCourse = new Dictionary<string, Course>();
            Dictionary<int, Year> yearIdToYear = new Dictionary<int, Year>();
            Dictionary<int, Year> yearValueToYear = new Dictionary<int, Year>();
            Dictionary<int, TeamMatchup> teamMatchupIdMatchup = new Dictionary<int, TeamMatchup>();
            ICollection<MatchUp> allMatchUps = new List<MatchUp>();
            ICollection<Result> allResults = new List<Result>();
            ICollection<YearData> yearDatas = new List<YearData>();

            // Add fake team and fake players (these will be used later)
            var teamOfLostPlayers = new Team { Id = teamIndex++, Name = "Dummy Team", ValidTeam = false };

            var noShowPlayer = new Player(playerIndex++) { Name = "No Show", CurrentHandicap = 0, ValidPlayer = false, Team = teamOfLostPlayers };
            namesToPlayers[noShowPlayer.Name] = noShowPlayer;
            var nonLeagueSub = new Player(playerIndex++) { Name = "Non-League Sub", CurrentHandicap = 0, ValidPlayer = false, Team = teamOfLostPlayers };
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

                    //if (year == 2013)
                    //{
                    //    Debugger.Break();
                    //}


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

                            // Note that because we iterate over the years in chronological order,
                            // the last team associated with the player will be their current team.
                            player.Team = teamIdToTeam[playersTeam];

                            // For years after 2009, current handicap will be updated when processing results.
                            player.CurrentHandicap = startingHandicap;

                            YearData yearData = new YearData { Player = player, Rookie = isRookie, StartingHandicap = startingHandicap, FinishingHandicap = startingHandicap, Year = yearValueToYear[year], Id = yearDataIndex++ };
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

                                    invalidPlayer = new Player(playerIndex++) { Name = player1Name, Team = teamOfLostPlayers, ValidPlayer = false, CurrentHandicap = 0 };
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

                                    invalidPlayer = new Player(playerIndex++) { Name = player2Name, Team = teamOfLostPlayers, ValidPlayer = false, CurrentHandicap = 0 };
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
                            var teamMatchups = teamMatchupIdMatchup.Values.Where(t => ((t.Team1.Id == teamIdToTeam[team1Id].Id || t.Team2.Id == teamIdToTeam[team2Id].Id) || (t.Team1.Id == teamIdToTeam[team2Id].Id || t.Team2.Id == teamIdToTeam[team1Id].Id)) && t.Week.SeasonIndex == weekId && t.Week.Year.Value == year);

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

                                if (player2.ValidPlayer && team2Id != 99)
                                {
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

                            //if (player1.Name == "Pete Mohs" && year == 2013)
                            //{
                            //    Debugger.Break();
                            //}

                            MatchUp matchup = new MatchUp { Id = matchupIndex++, TeamMatchup = teamMatchup, Player1 = player1, Player2 = player2 };
                            allMatchUps.Add(matchup);

                            Result player1Result = new Result { Year = newYear, Player = player1, Matchup = matchup, Points = points1, Score = score1, Id = resultIndex++ };
                            allResults.Add(player1Result);
                            team1.AddResult(player1Result);
                            player1.AddResult(player1Result);

                            Result player2Result = new Result { Year = newYear, Player = player2, Matchup = matchup, Points = points2, Score = score2, Id = resultIndex++ };
                            allResults.Add(player2Result);
                            team2.AddResult(player2Result);
                            player2.AddResult(player2Result);

                            matchup.Result1 = player1Result;
                            matchup.Result2 = player2Result;
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

            DataModel dm = new DataModel
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
                LeaderBoardDatas = new List<LeaderBoardData>(),
                LeaderBoards = new List<LeaderBoard>()
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
                        CalculateHandicaps(dataModel, p, yd, isNewestYear);
                    }
                    else if (yd.Year.Value >= 2009)
                    {
                        CalculateHandicaps20092010(dataModel, p, yd, isNewestYear);
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

        private static void CalculateHandicaps(DataModel dataModel, Player player, YearData yearData, bool isNewestYear)
        {
            var week0Score = yearData.StartingHandicap;

            int scoreIndex = 4;

            List<int> scores = new List<int>(4);

            for (var i = 0; i < 5; i++)
            {
                scores.Add(week0Score);
            }

            // Get all results for a player for the year.
            var allResultsForPlayer = dataModel.Results.Where(x => x.Player.Id == player.Id).ToList();

            var resultsForPlayerForYear = dataModel.Results.Where(x => x.Player.Id == player.Id && x.Matchup.TeamMatchup.Week.Year.Value == yearData.Year.Value).OrderBy(x => x.Matchup.TeamMatchup.Week.SeasonIndex);

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

        private static void BuildLeaderboards(DataModel dataModel)
        {
            foreach (Year year in dataModel.Years)
            {
                ISet<int> setOfTeamsForYear = new HashSet<int>();
                var matchUpsForYear = dataModel.TeamMatchup.Where(x => x.Week.Year.Value == year.Value);

                foreach (TeamMatchup tm in matchUpsForYear)
                {
                    setOfTeamsForYear.Add(tm.Team1.Id);
                    setOfTeamsForYear.Add(tm.Team2.Id);
                }

                var teamsForYear = dataModel.Teams.Where(x => setOfTeamsForYear.Contains(x.Id)).ToList();

                // TODO: replace with real predicates and leader boards.
                TeamBoard(dataModel, "Team Ranking", "team_ranking", teamsForYear, year, false, (team, dm) => team.TotalPointsForYear(year));

                TeamBoard(dataModel, "Average Handicap", "average_handicap", teamsForYear, year, true, (team, dm) => team.AverageHandicapForYear(year));

                TeamBoard(dataModel, "Win/Loss Ratio", "win_loss_ratio", teamsForYear, year, false, (team, dm) => team.RecordRatioForYear(year));

                TeamBoard(dataModel, "Season Improvement", "season_improvement", teamsForYear, year, true, (team, dm) => team.ImprovedInYear(year));

                TeamBoard(dataModel, "Avg. Opp. Score", "avg_opp_score", teamsForYear, year, true, (team, dm) => team.AverageOpponentScoreForYear(year));

                TeamBoard(dataModel, "Avg. Opp. Net Score", "avg_opp_net_score", teamsForYear, year, true, (team, dm) => team.AverageOpponentNetScoreForYear(year));

                TeamBoard(dataModel, "Average Score", "avg_score", teamsForYear, year, true, (team, dm) => team.AverageScoreForYear(year));

                TeamBoard(dataModel, "Average Net Score", "avg_net_score", teamsForYear, year, true, (team, dm) => team.AverageNetScoreForYear(year));

                TeamBoard(dataModel, "Ind. W/L Ratio", "ind_win_loss_record", teamsForYear, year, true, (team, dm) => team.IndividualRecordRatioForYear(year));

                TeamBoard(dataModel, "Total Match Wins", "total_match_wins", teamsForYear, year, false, (team, dm) => team.IndividualRecordForYear(year)[0]);

                TeamBoard(dataModel, "Total Match Wins", "total_match_wins", teamsForYear, year, false, (team, dm) => team.IndividualRecordForYear(year)[0]);

                TeamBoard(dataModel, "Points in a Week", "most_points_in_week", teamsForYear, year, false, (team, dm) => team.MostPointsInWeekForYear(year));

                TeamBoard(dataModel, "Avg Margin of Victory", "avg_margin_victory", teamsForYear, year, false, (team, dm) => team.AverageMarginOfVictoryForYear(year));

                TeamBoard(dataModel, "Avg Margin of Net Victory", "avg_margin_net_victory", teamsForYear, year, false, (team, dm) => team.AverageMarginOfNetVictoryForYear(year));


                var allPlayersForYear = dataModel.Players.Where(p => p.YearDatas.Any(yd => yd.Year.Value == year.Value)).ToList();

                PlayerBoard(dataModel, "Best Score", "player_best_score", allPlayersForYear, year, true, (p, dm) => p.LowRoundForYear(year));

                PlayerBoard(dataModel, "Best Net Score", "player_net_best_score", allPlayersForYear, year, true, (p, dm) => p.LowNetForYear(year));

                PlayerBoard(dataModel, "Handicap", "player_handicap", allPlayersForYear, year, true, (p, dm) => p.FinishingHandicapInYear(year));

                PlayerBoard(dataModel, "Average Points", "average_points", allPlayersForYear, year, true, (p, dm) => p.AveragePointsInYear(year));
            }

        }

        private static int LeaderBoardIdIndex = 1;
        private static int LeaderBoardDataIdIndex = 1;

        private static void TeamBoard(DataModel dataModel, string name, string key, ICollection<Team> teams, Year year, bool isAsc, Func<Team, DataModel, double> valueFunc)
        {
            LeaderBoard lb = new LeaderBoard { IsPlayerBoard = false, Id = LeaderBoardIdIndex++, Name = name, Key = key };

            List<LeaderBoardData> datasWhichNeedRanks = new List<LeaderBoardData>();

            foreach (var team in teams)
            {
                var results = dataModel.Results.Where(x => (x.Matchup.TeamMatchup.Team1.Id == team.Id || x.Matchup.TeamMatchup.Team2.Id == team.Id) && x.Year.Value == year.Value);

                if (results.Count() == 0) continue;

                double value = valueFunc(team, dataModel);
                LeaderBoardData lbd = new LeaderBoardData { Id = LeaderBoardDataIdIndex++, IsPlayer = false, Team = team, Value = value };
                datasWhichNeedRanks.Add(lbd);

                dataModel.LeaderBoardDatas.Add(lbd);
            }

            IEnumerable<LeaderBoardData> sortedLbds = null;

            if (isAsc)
            {
                sortedLbds = datasWhichNeedRanks.OrderBy(x => x.Value);
            }
            else
            {
                sortedLbds = datasWhichNeedRanks.OrderByDescending(x => x.Value);
            }

            int rank = 0;

            foreach (var lbd in sortedLbds)
            {
                lbd.Rank = rank;
            }

            dataModel.LeaderBoards.Add(lb);
        }

        private static void PlayerBoard(DataModel dataModel, string name, string key, ICollection<Player> players, Year year, bool isAsc, Func<Player, DataModel, double> valueFunc)
        {
            LeaderBoard lb = new LeaderBoard { IsPlayerBoard = false, Id = LeaderBoardIdIndex++, Name = name, Key = key };


            List<LeaderBoardData> datasToSort = new List<LeaderBoardData>();
            IEnumerable<LeaderBoardData> datasToSortAndRank = datasToSort;

            foreach (var player in players)
            {
                var results = player.AllResultsForYear(year);

                if (results.Count() == 0) continue;

                double value = valueFunc(player, dataModel);
                LeaderBoardData lbd = new LeaderBoardData { Id = LeaderBoardDataIdIndex++, IsPlayer = true, Player = player, Value = value };

                datasToSort.Add(lbd);
                dataModel.LeaderBoardDatas.Add(lbd);
            }

            if (isAsc)
            {
                datasToSortAndRank = datasToSortAndRank.OrderBy(x => x.Value);
            }
            else
            {
                datasToSortAndRank = datasToSortAndRank.OrderByDescending(x => x.Value);
            }

            int rank = 0;

            foreach (var lbd in datasToSortAndRank)
            {
                lbd.Rank = rank;
            }

            dataModel.LeaderBoards.Add(lb);
        }

    }
}
