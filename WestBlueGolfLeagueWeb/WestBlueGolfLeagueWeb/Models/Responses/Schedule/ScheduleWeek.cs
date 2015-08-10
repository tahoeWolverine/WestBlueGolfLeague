using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Playoffs;
using WestBlueGolfLeagueWeb.Models.Responses.Team;

namespace WestBlueGolfLeagueWeb.Models.Responses.Schedule
{
    public class ScheduleWeek : WeekResponse
    {
        public ScheduleWeek(week w) : this(w, null)
        {
            
        }

        public ScheduleWeek(week w, GroupedPlayoffMatchup playoffMatchup)
            : base(w)
        {
            this.TeamMatchups = w.teammatchups
                .Select(x => new ScheduleTeamMatchup(x)).OrderBy(x => x.MatchOrder).ToList();
            this.Course = CourseResponse.From(w.course);
            this.Pairing = w.pairing.pairingText;

            if (playoffMatchup != null)
            {
                this.PlayoffMatchups = playoffMatchup.PlayoffMatchups.Select(y =>
                    new
                    {
                        team1 = TeamResponse.From(y.Team1),
                        team2 = TeamResponse.From(y.Team2),
                        team1Seed = y.Team1Seed,
                        team2Seed = y.Team2Seed,
                        playoffType = y.PlayoffType
                    });
            }
        }

        public List<ScheduleTeamMatchup> TeamMatchups { get; set; }
        public CourseResponse Course { get; set; }
        public string Pairing { get; set; }
        public IEnumerable<object> PlayoffMatchups { get; set; }
    }
}