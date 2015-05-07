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
            this.Team1 = numOfTeams > 0 ? TeamResponse.From(tm.teams.First()) : null;
            this.Team2 = numOfTeams > 1 ? TeamResponse.From(tm.teams.Skip(1).First()) : null;
            this.TeeTimeText = tm.TeeTimeText();
            this.Id = tm.id;
        }

        public int? MatchOrder { get; set; }
        public TeamResponse Team1 { get; set; }
        public TeamResponse Team2 { get; set; }
		public string TeeTimeText { get; set; }
        public int Id { get; set; }
    }
}