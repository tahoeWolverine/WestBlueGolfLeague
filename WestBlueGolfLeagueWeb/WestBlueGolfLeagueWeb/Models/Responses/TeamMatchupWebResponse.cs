using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class ScheduleTeamMatchup
    {
		private static readonly string[] TeeTimes = new string[] { "3:44 (3:52)", "4:00 (4:08)", "4:16 (4:24)", "4:32 (4:40)", "4:48 (4:56)", "n/a" };

        public ScheduleTeamMatchup()
        {

        }

        public ScheduleTeamMatchup(teammatchup tm)
        {
            int numOfTeams = tm.teams.Count;

            this.MatchOrder = tm.matchOrder;
            this.Team1 = numOfTeams > 0 ? TeamResponse.From(tm.teams.First()) : null;
            this.Team2 = numOfTeams > 1 ? TeamResponse.From(tm.teams.Skip(1).First()) : null;
	        this.TeeTimeText = tm.matchOrder == null ? "n/a" : TeeTimes[tm.matchOrder.Value];
            this.Id = tm.id;
        }

        public int? MatchOrder { get; set; }
        public TeamResponse Team1 { get; set; }
        public TeamResponse Team2 { get; set; }
		public string TeeTimeText { get; set; }
        public int Id { get; set; }
    }
}