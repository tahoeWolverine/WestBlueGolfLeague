using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AccessExport.Entities;
using MySql.Data.MySqlClient;
using System.IO;

namespace AccessExport
{
    class MySqlGenerator
    {
        public delegate void SqlListener(string generatedSql);

        public void DoPrereq(string connectionString)
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                conn.Open();

                // We need to set the packet size for mysql to accept our large inserts.
                using (var command = conn.CreateCommand())
                {
                    command.CommandText = "SET GLOBAL max_allowed_packet = " + Convert.ToString(24 * 1024 * 1024) + ";";
                    command.ExecuteNonQuery();
                }
            }
        }

        public void DoInsert(string connectionString, DataModel dataModel)
        {
            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                conn.Open();

                MySqlTransaction transaction = null;
                try
                {
                    transaction = conn.BeginTransaction();

                    var deletes = File.ReadAllText("scripts/deletes.txt");

                    using (var command = conn.CreateCommand())
                    {
                        command.CommandText = deletes;
                        command.CommandTimeout = 120;
                        command.Transaction = transaction;
                        command.ExecuteNonQuery();
                    }

                    this.Generate(dataModel, (sql) =>
                    {
                        using (var command = conn.CreateCommand())
                        {
                            command.Transaction = transaction;
                            command.CommandText = sql;
                            command.ExecuteNonQuery();
                        }
                    });

                    transaction.Commit();
                }
                catch (Exception ex)
                {
                    if (transaction != null)
                    {
                        transaction.Rollback();
                    }

                    throw;
                }
            }
        }

        public void Generate(DataModel dataModel, SqlListener sqlListener = null)
        {
            // begin our transaction
            // sb.AppendLine("SET autocommit=0;");

            // set to no-op if not set.
            if (sqlListener == null)
            {
                sqlListener = (sql) => { };
            }

            // Create teams first
            {
                var sb = new StringBuilder();
                sb.AppendLine().AppendLine("/* Teams */");
                var teamInserts = dataModel.Teams.Select(t => this.GetTeamInsert(t));
                sb.Append(string.Join("\n", teamInserts));
                sqlListener(sb.ToString());
            }

            // playerssss
            {
                var sb = new StringBuilder();
                sb.Append("\n\n\n/* Players */");
                var players = dataModel.Players.Select(p => this.GetPlayerInsert(p));
                sb.Append(string.Join("\n", players));
                sqlListener(sb.ToString());
            }

            // Years
            {
                var sb = new StringBuilder();
                sb.Append("\n\n\n/* years */");
                var years = dataModel.Years.Select(y => this.GetYearInsert(y));
                sb.Append(string.Join("\n", years));
                sqlListener(sb.ToString());
            }

            // Player data
            {
                var pyds = dataModel.YearDatas.Select(yd => this.GetYearDataInsert(yd));
                ChunkInsertsAndNotify("/* Player year data */", pyds, sqlListener);
            }

            // Courses
            {
                var sb = new StringBuilder();
                sb.AppendLine().AppendLine().AppendLine("/* Courses */");
                var courses = dataModel.Courses.Select(c => this.GetCoursesInsert(c));
                sb.Append(string.Join("\n", courses));
                sqlListener(sb.ToString());
            }

            // Weeks
            {
                var sb = new StringBuilder();
                sb.AppendLine().AppendLine().AppendLine("/* Weeks */");
                var weeks = dataModel.Weeks.Select(p => this.GetWeekInsert(p));
                sb.Append(string.Join("\n", weeks));
                sqlListener(sb.ToString());
            }

            // Team year datas
            {
                var sb = new StringBuilder();
                sb.AppendLine().AppendLine().AppendLine("/* Team year datas */");
                var teamYearData = dataModel.TeamYearData.Select(p => this.GetTeamYearDataInsert(p));
                sb.Append(string.Join("\n", teamYearData));
                sqlListener(sb.ToString());
            }

            // Team Matchup
            {
                var sb = new StringBuilder();
                sb.AppendLine().AppendLine().AppendLine("/* team matchups */");
                var teamMatchups = dataModel.TeamMatchup.Select(tm => this.GetTeamMatchupInsert(tm));
                sb.Append(string.Join("\n", teamMatchups));
                sqlListener(sb.ToString());
            }

            // Team Matchup to Team -- This is one is special cause we don't have an entity for it!
            {
                var sb = new StringBuilder();
                sb.AppendLine().AppendLine().AppendLine("/* team matchup to team */");
                var teamMatchupsToTeam = dataModel.TeamMatchup.Select(tm => this.GetTeamMatchupToTeamInsert(tm));
                sb.Append(string.Join("\n", teamMatchupsToTeam));
                sqlListener(sb.ToString());
            }

            // Matchup
            {
                var sb = new StringBuilder();
                sb.AppendLine().AppendLine().AppendLine("/* matchup */");
                var matchUps = dataModel.MatchUp.Select(m => this.GetMatchupInsert(m));
                sb.AppendLine(string.Join("\n", matchUps));
                sqlListener(sb.ToString());
            }

            // MatchupToPlayer
            {
                var matchUpToPlayers = dataModel.MatchUp.Select(m => this.GetMatchupToPlayerInsert(m));
                ChunkInsertsAndNotify("/* matchup to player */", matchUpToPlayers, sqlListener);
            }

            // results
            {
                var results = dataModel.Results.Select(m => this.GetResultsInsert(m));
                ChunkInsertsAndNotify("/* results! */", results, sqlListener);
            }

            // Leaderboard
            {
                var sb = new StringBuilder();
                sb.AppendLine().AppendLine().AppendLine("/* leaderboardddsss */");
                var lbs = dataModel.LeaderBoards.Select(l => this.GetLeaderBoardInsert(l));
                sb.AppendLine(string.Join("\n", lbs));
                sqlListener(sb.ToString());
            }

            // Leaderboard data
            {
                var lbData = dataModel.LeaderBoardDatas.Select(l => this.GetLeaderBoardDataInsert(l));
                ChunkInsertsAndNotify("/* lb data */", lbData, sqlListener);
            }

            // data migrations
            {
                var sb = new StringBuilder();
                sb.AppendLine().AppendLine().AppendLine("/* data migration data */");
                var dmData = dataModel.DataMigrations.Select(l => this.GetDataMigrationInsert(l));
                sb.AppendLine(string.Join("\n", dmData));
                sqlListener(sb.ToString());
            }

        }

        private string GetTeamYearDataInsert(TeamYearData p)
        {
            return new FluentMySqlInsert("teamyeardata")
                .WithColumns("id", "yearId", "teamId")
                .WithValues(p.Id, p.Year.Id, p.TeamId)
                .ToString();
        }

        private void ChunkInsertsAndNotify(string header, IEnumerable<string> inserts, SqlListener sqlListener)
        {
            var sb = new StringBuilder();
            sb.AppendLine("/* lb data */");

            int i = 0;
            var groupedInserts = inserts.GroupBy(x => i++ / 50).Select(x => x.AsEnumerable());

            foreach (var e in groupedInserts)
            {
                sb.AppendLine(string.Join("\n", e));
                sqlListener(sb.ToString());
                sb.Clear();
            }
        }

        private string GetDataMigrationInsert(DataMigration dm)
        {
            return new FluentMySqlInsert("dataMigration")
                .WithColumns("id", "yearId", "notes", "dataMigrationDate")
                .WithValues(dm.Id, dm.Year.Id, dm.Notes, dm.DataMigrationDate)
                .ToString();
        }

        private string GetLeaderBoardDataInsert(LeaderBoardData l)
        {
            NullableValue<int> playerId = l.IsPlayer ? new NullableValue<int>(l.Player.Id) : new NullableValue<int>();
            NullableValue<int> teamId = l.IsPlayer ? new NullableValue<int>() : new NullableValue<int>(l.Team.Id);

            return new FluentMySqlInsert("leaderBoardData")
               .WithColumns("id", "rank", "value", "leaderBoardId", "yearId", "isPlayer", "teamId", "playerId", "detail", "formattedValue")
               .WithValues(l.Id, l.Rank, l.Value, l.LeaderBoard.Id, l.Year.Id, l.IsPlayer, teamId, playerId, l.Detail ?? string.Empty, l.FormattedValue)
               .ToString();
        }

        private string GetLeaderBoardInsert(LeaderBoard l)
        {
            return new FluentMySqlInsert("leaderBoard")
               .WithColumns("id", "name", "priority", "isPlayerBoard", "key", "formatType")
               .WithValues(l.Id, l.Name, l.Priority, l.IsPlayerBoard, l.Key, l.FormatType)
               .ToString();
        }

        private string GetResultsInsert(Result m)
        {
            return new FluentMySqlInsert("result")
                .WithColumns("id", "priorHandicap", "score", "points", "teamId", "playerId", "matchId", "yearId")
                .WithValues(m.Id, m.PriorHandicap, m.Score, m.Points, m.Team.Id, m.Player.Id, m.Matchup.Id, m.Year.Id)
                .ToString();
        }

        private string GetMatchupInsert(MatchUp m)
        {
            return
                new FluentMySqlInsert("match")
                .WithColumns("id", "teamMatchupId")
                .WithValues(m.Id, m.TeamMatchup.Id)
                .ToString();
        }

        private string GetMatchupToPlayerInsert(MatchUp m)
        {
            var insert1 = new FluentMySqlInsert("matchToPlayer")
                .WithColumns("playerId", "matchId")
                .WithValues(m.Player1.Id, m.Id)
                .ToString();

            var insert2 = new FluentMySqlInsert("matchToPlayer")
                .WithColumns("playerId", "matchId")
                .WithValues(m.Player2.Id, m.Id)
                .ToString();

            // hackyyy
            return insert1 + "\n" + insert2;
        }

        private string GetTeamMatchupToTeamInsert(TeamMatchup tm)
        {
            var insert1 = new FluentMySqlInsert("teamMatchupToTeam")
                .WithColumns("teamMatchupId", "teamId")
                .WithValues(tm.Id, tm.Team1.Id)
                .ToString();

            var insert2 = new FluentMySqlInsert("teamMatchupToTeam")
                .WithColumns("teamMatchupId", "teamId")
                .WithValues(tm.Id, tm.Team2.Id)
                .ToString();

            // hackyyy
            return insert1 + "\n" + insert2;
        }

        private string GetTeamMatchupInsert(TeamMatchup tm)
        {
            return
                new FluentMySqlInsert("teamMatchup")
                .WithColumns("id", "playoffType", "weekId", "matchComplete", "matchId", "matchOrder")
                .WithValues(tm.Id, tm.PlayoffType, tm.Week.Id, tm.MatchComplete, tm.MatchId, tm.MatchOrderInWeek)
                .ToString();
        }

        private string GetYearDataInsert(YearData yd)
        {
            return
                new FluentMySqlInsert("playerYearData")
                .WithColumns("id", "isRookie", "startingHandicap", "finishingHandicap", "playerId", "yearId", "teamId", "week0Score")
                .WithValues(yd.Id, yd.Rookie, yd.StartingHandicap, yd.FinishingHandicap, yd.Player.Id, yd.Year.Id, yd.Team.Id, yd.Week0Score)
                .ToString();
        }

        private string GetCoursesInsert(Course c)
        {
            return
                new FluentMySqlInsert("course")
                .WithColumns("id", "name", "par", "street", "state", "zip")
                .WithValues(c.Id, c.Name, c.Par, c.Street, c.State, c.Zip)
                .ToString();
        }

        private string GetTeamInsert(Team team)
        {
            return
                new FluentMySqlInsert("team")
                .WithColumns("id", "teamName", "validTeam")
                .WithValues(team.Id, team.Name, team.ValidTeam)
                .ToString();
        }

        private string GetPlayerInsert(Player player)
        {
            return
                new FluentMySqlInsert("player")
                .WithColumns("id", "name", "currentHandicap", "favorite", "validPlayer")
                .WithValues(player.Id, player.Name.Trim(), player.CurrentHandicap, false, player.ValidPlayer)
                .ToString();
        }

        private string GetYearInsert(Year year)
        {
            return
                new FluentMySqlInsert("year")
                .WithColumns("id", "value", "isComplete")
                .WithValues(year.Id, year.Value, year.Complete)
                .ToString();
        }

        private string GetWeekInsert(Week week)
        {
            return
                new FluentMySqlInsert("week")
                .WithColumns("id", "date", "courseId", "yearId", "isBadData", "seasonIndex", "isPlayoff", "pairingId")
                .WithValues(week.Id, week.Date, week.Course.Id, week.Year.Id, week.IsBadData, week.SeasonIndex, week.IsPlayoff, week.PairingId)
                .ToString();
        }
    }
}
