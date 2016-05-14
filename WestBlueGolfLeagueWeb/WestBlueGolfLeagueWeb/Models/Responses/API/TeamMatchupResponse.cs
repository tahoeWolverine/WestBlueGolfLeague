using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Responses.Schedule;

namespace WestBlueGolfLeagueWeb.Models.Responses.API
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
            tmr.Matches = tm.matches.Select(x => MatchResponse.From(x)).ToList();
            tmr.PlayoffType = tm.playoffType;
            tmr.MatchOrder = tm.matchOrder;
            return tmr;
        }

        public int Id { get; set; }

        public bool Mc { get; set; }

        public IList<int> TeamIds { get; set; }

        public int WId { get; set; }

        public IList<MatchResponse> Matches { get; set; }

        public int? MatchOrder { get; set; }

        public string PlayoffType { get; set; }
    }
}