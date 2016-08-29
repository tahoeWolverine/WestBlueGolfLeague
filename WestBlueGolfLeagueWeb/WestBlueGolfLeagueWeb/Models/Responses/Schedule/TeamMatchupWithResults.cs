using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Responses.Schedule;

namespace WestBlueGolfLeagueWeb.Models.Responses.Schedule
{
    public class TeamMatchupWithResults : ScheduleTeamMatchup
    {
        public TeamMatchupWithResults(teammatchup teamMatchup)
            : base(teamMatchup)
        {
            this.Team1Results = new List<ResultWithOutcome>(4);
            this.Team2Results = new List<ResultWithOutcome>(4);

            int team1Id = this.Team1 != null ? this.Team1.Id : -1;
            int team2Id = this.Team2 != null ? this.Team2.Id : -1;

            foreach (match m in teamMatchup.matches.OrderBy(x => x.matchOrder))
            {
                var result1 = m.results.FirstOrDefault(x => x.teamId == team1Id);
                var result2 = m.results.FirstOrDefault(x => x.teamId == team2Id);

                this.Team1Results.Add(result1 == null ? null : new ResultWithOutcome(result1));
                this.Team2Results.Add(result2 == null ? null : new ResultWithOutcome(result2));
            }
        }

        public TeamMatchupWithResults()
        {

        }

        public IList<ResultWithOutcome> Team1Results { get; set; }

        public IList<ResultWithOutcome> Team2Results { get; set; }
    }
}