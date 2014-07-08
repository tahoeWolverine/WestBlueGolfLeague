using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class TeamMatchupResponse
    {
        public static TeamMatchupResponse From(teammatchup tm)
        {
            var tmr = new TeamMatchupResponse();

            tmr.Id = tm.id;
            tmr.Mc = tm.matchComplete;
            tmr.TeamIds = tm.teams.Select(x => x.id).ToList();
            tmr.WId = tm.weekId;
            tmr.Matches = tm.matchups.Select(x => MatchResponse.From(x)).ToList();

            return tmr;
        }

        public int Id { get; set; }

        public bool Mc { get; set; }

        public IList<int> TeamIds { get; set; }

        public int WId { get; set; }

        public IList<MatchResponse> Matches { get; set; }
    }
}