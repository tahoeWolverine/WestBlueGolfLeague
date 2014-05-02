using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AccessExport.Entities;

namespace AccessExport
{
    class MySqlGenerator
    {
        public string Generate(DataModel dataModel)
        {
            StringBuilder sb = new StringBuilder();

            // begin our transaction
            sb.Append("SET autocommit=0;\n");
            sb.Append("START TRANSACTION;\n");


            // Create teams first
            sb.AppendLine().AppendLine("/* Teams */");
            var teamInserts = dataModel.Teams.Select(t => this.GetTeamInsert(t));
            sb.Append(string.Join("\n", teamInserts));

            // playerssss
            sb.Append("\n\n\n/* Players */");
            var players = dataModel.Players.Select(p => this.GetPlayerInsert(p));
            sb.Append(string.Join("\n", players));

            // Years
            sb.Append("\n\n\n/* years */");
            var years = dataModel.Years.Select(y => this.GetYearInsert(y));
            sb.Append(string.Join("\n", years));

            // Player data
            sb.AppendLine().AppendLine().AppendLine("/* Player year data */");
            var pyds = dataModel.YearDatas.Select(yd => this.GetYearDataInsert(yd));
            sb.Append(string.Join("\n", pyds));

            // Courses
            sb.AppendLine().AppendLine().AppendLine("/* Courses */");
            var courses = dataModel.Courses.Select(c => this.GetCoursesInsert(c));
            sb.Append(string.Join("\n", courses));

            // Weeks
            sb.AppendLine().AppendLine().AppendLine("/* Weeks */");
            var weeks = dataModel.Weeks.Select(p => this.GetWeekInsert(p));
            sb.Append(string.Join("\n", weeks));

            // Team Matchup
            sb.AppendLine().AppendLine().AppendLine("/* team matchups */");
            var teamMatchups = dataModel.TeamMatchup.Select(tm => this.GetTeamMatchupInsert(tm));
            sb.Append(string.Join("\n", teamMatchups));

            // Team Matchup to Team -- This is one is special cause we don't have an entity for it!
            sb.AppendLine().AppendLine().AppendLine("/* team matchup to team */");
            var teamMatchupsToTeam = dataModel.TeamMatchup.Select(tm => this.GetTeamMatchupToTeamInsert(tm));
            sb.Append(string.Join("\n", teamMatchupsToTeam));

            // Matchup
            sb.AppendLine().AppendLine().AppendLine("/* matchup */");
            var matchUps = dataModel.MatchUp.Select(m => this.GetMatchupInsert(m));
            sb.AppendLine(string.Join("\n", matchUps));

            // MatchupToPlayer
            sb.AppendLine().AppendLine().AppendLine("/* matchup to player*/");
            var matchUpToPlayers = dataModel.MatchUp.Select(m => this.GetMatchupToPlayerInsert(m));
            sb.AppendLine(string.Join("\n", matchUpToPlayers));

            // results
            sb.AppendLine().AppendLine().AppendLine("/* results! */");
            var results = dataModel.Results.Select(m => this.GetResultsInsert(m));
            sb.AppendLine(string.Join("\n", results));

            // Leaderboard
            //sb.AppendLine().AppendLine().AppendLine("/* leaderboardddsss */");
            //var lbs = dataModel.LeaderBoards.Select(l => this.GetLeaderBoardInsert(l));
            //sb.AppendLine(string.Join("\n", lbs));

            //// Leaderboard data
            //sb.AppendLine().AppendLine().AppendLine("/* lb data */");
            //var lbData = dataModel.LeaderBoardDatas.Select(l => this.GetLeaderBoardDataInsert(l));
            //sb.AppendLine(string.Join("\n", lbData));

            sb.Append("\n\n\n");
            sb.Append("COMMIT;\n");

            return sb.ToString();
        }

        private string GetLeaderBoardDataInsert(LeaderBoardData l)
        {
            NullableValue<int> playerId = l.IsPlayer ? new NullableValue<int>(l.Player.Id) : new NullableValue<int>();
            NullableValue<int> teamId = l.IsPlayer ? new NullableValue<int>() : new NullableValue<int>(l.Team.Id);

            return new FluentMySqlInsert("leaderBoardData")
               .WithColumns("id", "rank", "value", "leaderBoardId", "yearId", "isPlayer", "teamId", "playerId", "detail")
               .WithValues(l.Id, l.Rank, l.Value, l.LeaderBoard.Id, l.Year.Id, l.IsPlayer, teamId, playerId, l.Detail ?? string.Empty)
               .ToString();
        }

        private string GetLeaderBoardInsert(LeaderBoard l)
        {
            return new FluentMySqlInsert("leaderBoard")
               .WithColumns("id", "name", "priority", "isPlayerBoard", "key")
               .WithValues(l.Id, l.Name, l.Priority, l.IsPlayerBoard, l.Key)
               .ToString();
        }

        private string GetResultsInsert(Result m)
        {
            return new FluentMySqlInsert("result")
                .WithColumns("id", "priorHandicap", "score", "points", "teamId", "playerId", "matchupId", "yearId")
                .WithValues(m.Id, m.PriorHandicap, m.Score, m.Points, m.Team.Id, m.Player.Id, m.Matchup.Id, m.Year.Id)
                .ToString();
        }

        private string GetMatchupInsert(MatchUp m)
        {
            return 
                new FluentMySqlInsert("matchup")
                .WithColumns("id", "teamMatchupId")
                .WithValues(m.Id, m.TeamMatchup.Id)
                .ToString();
        }

        private string GetMatchupToPlayerInsert(MatchUp m)
        {
            //if (m.Id == 475)
            //{
            //    Debugger.Break();
            //}

            var insert1 = new FluentMySqlInsert("matchupToPlayer")
                .WithColumns("playerId", "matchupId")
                .WithValues(m.Player1.Id, m.Id)
                .ToString();

            var insert2 = new FluentMySqlInsert("matchupToPlayer")
                .WithColumns("playerId", "matchupId")
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
                .WithColumns("id", "status", "weekId", "matchComplete", "matchId")
                .WithValues(tm.Id, string.Empty, tm.Week.Id, tm.MatchComplete, tm.MatchId)
                .ToString();
        }

        private string GetYearDataInsert(YearData yd)
        {
            return
                new FluentMySqlInsert("playerYearData")
                .WithColumns("id", "isRookie", "startingHandicap", "finishingHandicap", "playerId", "yearId")
                .WithValues(yd.Id, yd.Rookie, yd.StartingHandicap, yd.FinishingHandicap, yd.Player.Id, yd.Year.Id)
                .ToString();
        }

        private string GetCoursesInsert(Course c)
        {
            return 
                new FluentMySqlInsert("course")
                .WithColumns("id", "name", "par", "address")
                .WithValues(c.Id, c.Name, c.Par, string.Empty)
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
                .WithColumns("id", "name", "currentHandicap", "favorite", "teamId", "validPlayer")
                .WithValues(player.Id, player.Name, player.CurrentHandicap, false, player.Team.Id, player.ValidPlayer)
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
                .WithColumns("id", "date", "courseId", "yearId", "isBadData", "seasonIndex")
                .WithValues(week.Id, week.Date, week.Course.Id, week.Year.Id, week.IsBadData, week.SeasonIndex)
                .ToString();
        }
    }
}
