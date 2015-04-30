using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class MatchWebResponse
    {
        public MatchWebResponse(match m, int team1Id, int team2Id)
        {
            this.Id = m.id;

            var result1 = m.results.FirstOrDefault(x => x.teamId == team1Id);
            var result2 = m.results.FirstOrDefault(x => x.teamId == team2Id);

            this.Result1 = result1 == null ? null : new ResultWebResponse(result1);
            this.Result2 = result2 == null ? null : new ResultWebResponse(result2);
        }

        public ResultWebResponse Result2 { get; set; }

        public ResultWebResponse Result1 { get; set; }

        public int Id { get; set; }
    }
}