using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses.Admin
{
    public class TeamMatchupWithMatches : TeamMatchupWebResponse
    {
        public TeamMatchupWithMatches(teammatchup teamMatchup)
            : base(teamMatchup)
        {
            this.Matches = 
                teamMatchup.matches == null ? 
                    null : 
                    teamMatchup.matches.Select(x => new MatchWebResponse(x, this.Team1.Id, this.Team2.Id));
        }

        public TeamMatchupWithMatches()
        {

        }

        public IEnumerable<MatchWebResponse> Matches { get; set; }
    }
}