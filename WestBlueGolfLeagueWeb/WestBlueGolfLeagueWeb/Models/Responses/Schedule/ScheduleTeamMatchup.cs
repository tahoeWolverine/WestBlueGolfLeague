using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Extensions;
using WestBlueGolfLeagueWeb.Models.Responses.Team;

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
            }

            if (team2 != null) {
                this.Team2 = TeamResponse.From(team2);
                this.Team2Points = tm.PointsFor(team2);
            }

            this.IsComplete = tm.IsComplete();
            this.TeeTimeText = tm.TeeTimeText();
            this.Id = tm.id;

            // TODO: going to need to add all the results here I think :\
        }

        public int? MatchOrder { get; set; }
        public TeamResponse Team1 { get; set; }
        public TeamResponse Team2 { get; set; }
        public int? Team1Points { get; set; }
        public int? Team2Points { get; set; }
        public bool IsComplete { get; set; }
		public string TeeTimeText { get; set; }
        public int Id { get; set; }
    }
}