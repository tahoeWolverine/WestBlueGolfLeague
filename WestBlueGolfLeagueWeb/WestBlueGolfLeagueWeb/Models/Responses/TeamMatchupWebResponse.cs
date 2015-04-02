using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class TeamMatchupWebResponse
    {
        public TeamMatchupWebResponse(teammatchup tm)
        {
            int numOfTeams = tm.teams.Count;

            this.MatchOrder = tm.matchOrder;
            this.Team1 = numOfTeams > 0 ? TeamResponse.From(tm.teams.First()) : null;
            this.Team2 = numOfTeams > 1 ? TeamResponse.From(tm.teams.Skip(1).First()) : null;
        }

        public int? MatchOrder { get; set; }
        public TeamResponse Team1 { get; set; }
        public TeamResponse Team2 { get; set; }
    }
}