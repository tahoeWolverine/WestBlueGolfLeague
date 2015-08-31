using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Extensions;
using WestBlueGolfLeagueWeb.Models.Responses.Player;
using WestBlueGolfLeagueWeb.Models.Responses.Team;
using WestBlueGolfLeagueWeb.Models.ScoreEntry.LeaderBoard;

namespace WestBlueGolfLeagueWeb.Models.Responses.Schedule
{
    public class ScheduleTeamMatchup
    {
        public ScheduleTeamMatchup()
        {

        }

        public ScheduleTeamMatchup(teammatchup tm)
        {
            int numOfTeams = tm.teams.Count;

            this.MatchOrder = tm.matchOrder;

            team team1 = numOfTeams > 0 ? tm.teams.First() : null;
            team team2 = numOfTeams > 1 ? tm.teams.Skip(1).First() : null;

            if (team1 != null) {
                this.Team1 =  TeamResponse.From(team1);
                this.Team1Points = tm.PointsFor(team1);
	            this.Team1Win = tm.Team1Won();
            }

            if (team2 != null) {
                this.Team2 = TeamResponse.From(team2);
                this.Team2Points = tm.PointsFor(team2);
	            this.Team2Win = tm.Team2Won();
            }

            this.IsComplete = tm.IsComplete();
            this.TeeTimeText = tm.TeeTimeText();
            this.Id = tm.id;
            this.PlayoffType = tm.playoffType;

            if (this.IsComplete && team1 != null && team2 != null) 
            {
                result team1PointsResult = tm.TopPoints(team1);
                //result team2PointsResult = tm.TopPoints(team2);

                this.TopPoints = team1PointsResult != null ?
                    new MatchSummaryValue
                    {
                        Player = new PlayerWebResponse(team1PointsResult.player),
                        FormattedValue = LeaderBoardFormat.Default.FormatValue(team1PointsResult.points),
                        Value = (double)team1PointsResult.points
                    } : null;


                result topNetScore = tm.TopNetDifference(team1);

                this.TopNetScore = topNetScore != null ?
                    new MatchSummaryValue
                    {
                        Player = new PlayerWebResponse(topNetScore.player),
                        FormattedValue = LeaderBoardFormat.Net.FormatValue(topNetScore.NetScoreDifference()),
                        Value = (double)topNetScore.NetScoreDifference()
                    } : null;

                //this.Team2TopPoints = team2PointsResult != null ?
                //    new MatchSummaryValue
                //    {
                //        Player = new PlayerWebResponse(team2PointsResult.player),
                //        FormattedValue = LeaderBoardFormat.Default.FormatValue(team2PointsResult.points),
                //        Value = (double)team2PointsResult.points
                //    } : null;
            }

            // TODO: going to need to add all the results here I think :\
        }

        public int? MatchOrder { get; set; }
        public TeamResponse Team1 { get; set; }
        public TeamResponse Team2 { get; set; }
        public int? Team1Points { get; set; }
        public int? Team2Points { get; set; }
		public bool? Team1Win { get; set; }
		public bool? Team2Win { get; set; }
        public bool IsComplete { get; set; }
		public string TeeTimeText { get; set; }
        public string PlayoffType { get; set; }
        public int Id { get; set; }
        public MatchSummaryValue TopPoints { get; set; }
        //public MatchSummaryValue Team2TopPoints { get; set; }

        public MatchSummaryValue TopNetScore { get; set; }
    }
}