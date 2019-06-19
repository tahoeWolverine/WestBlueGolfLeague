using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Extensions
{
	public static class TeamMatchupExtensions
	{
        private static readonly string[] TeeTimes2018 = new string[] { "3:44", "3:52", "4:00", "4:08", "4:16", "4:24", "4:32", "4:40", "4:48", "4:56", "n/a" };

        private static readonly string[] TeeTimes = new string[] { "4:00", "4:08", "4:16", "4:24", "4:32", "4:40", "4:48", "4:56", "n/a" };

		public static int? PointsForTeam(this teammatchup teamMatchup, int teamIndex)
		{
			if (teamMatchup.teams.Count < teamIndex + 1)
			{
				return 0;
			}

			int? points = 0;
			var t = teamMatchup.teams.ElementAt(teamIndex);
			foreach (match m in teamMatchup.matches)
			{
				foreach (result r in m.results)
				{
					if (r.team.id == t.id)
					{
						points += r.points;
					}
				}
			}
			return points;
		}

		public static string TeeTimeText(this teammatchup teamMatchup)
		{
            string[] times = TeeTimes;
            if (teamMatchup.week.year.value < 2019)
            {
                times = TeeTimes2018;
            }

            if (teamMatchup.matchOrder < 0)
            {
                return "n/a";
            }
            // Unfortunately, we need to fudge the tee times due to no-team matches only getting one time
            if (teamMatchup.HasNoTeam())
            {
                return teamMatchup.matchOrder == null ? "n/a" : times[teamMatchup.matchOrder.Value * 2];
            }
            else if (teamMatchup.matchOrder > 0 && teamMatchup.IsAfterNoTeam())
            {
                // Do a safety check on matchOrder to not bother checking if after no team if first matchup
                return teamMatchup.matchOrder == null ? "n/a" : times[teamMatchup.matchOrder.Value * 2 - 1] + " (" + times[teamMatchup.matchOrder.Value * 2] + ")";
            }
            else
            {
                return teamMatchup.matchOrder == null ? "n/a" : times[teamMatchup.matchOrder.Value * 2] + " (" + times[teamMatchup.matchOrder.Value * 2 + 1] + ")";
            }
			
		}

		public static bool Team1Won(this teammatchup teamMatchup)
		{
			return teamMatchup.PointsForTeam(0) > 48;
		}

		public static bool Team2Won(this teammatchup teamMatchup)
		{
			return teamMatchup.PointsForTeam(1) > 48;
		}

        public static bool HasNoTeam(this teammatchup teamMatchup)
        {
            foreach (team aTeam in teamMatchup.teams)
            {
                if (aTeam.teamName == "NO TEAM")
                {
                    return true;
                }
            }
            return false;
        }

        public static bool IsAfterNoTeam(this teammatchup teamMatchup)
        {
            // Unfortunately, the iteration order seems not by match order, so we can't break early
            foreach (teammatchup matchup in teamMatchup.week.teammatchups)
            {
                if (matchup.matchOrder < teamMatchup.matchOrder && matchup.HasNoTeam())
                {
                    return true;
                }
            }
            return false;
        }

        public static int? PointsFor(this teammatchup tm, team team)
        {
            return tm.matches.Select(x => x.results.FirstOrDefault(r => r.teamId == team.id)).Sum(x => x == null ? 0 : x.points);
        }

        // TODO: could probably use expression instead of function
        private static result TopX(teammatchup tm, team team, Func<result, result, result> func)
        {
            if (!tm.IsComplete())
            {
                return null;
            }

            List<result> allResults = tm.matches.SelectMany(x => x.results).ToList();//.Where(x => x.teamId == team.id).ToList();

            if (allResults.Count == 0)
            {
                return null;
            }

            result r = allResults.Aggregate(func);

            return r;
        }

        public static result TopPoints(this teammatchup tm, team team)
        {
            return TopX(tm, team, (agg, next) => agg.points > next.points ? agg : next);
        }

        public static result TopNetDifference(this teammatchup tm, team team)
        {
            return TopX(tm, team, (agg, next) => agg.NetScoreDifference() < next.NetScoreDifference() ? agg : next);
        }

        public static bool IsComplete(this teammatchup tm)
        {
            return tm.matches != null && tm.matches.Count > 0 && tm.matches.All(x => x.IsComplete());
        }
	}
}