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
            tmr.MId = tm.matchId;
            tmr.Status = tm.status;
            tmr.Teams = tm.teams.Select(x => TeamResponse.From(x)).ToList();
            tmr.WId = tm.weekId;
            tmr.Matchups = tm.matchups.Select(x => MatchupResponse.From(x)).ToList();

            return tmr;
        }

        public int Id { get; set; }

        public bool Mc { get; set; }

        public int? MId { get; set; }

        public string Status { get; set; }

        public IList<TeamResponse> Teams { get; set; }

        public int WId { get; set; }

        public IList<MatchupResponse> Matchups { get; set; }
    }
}