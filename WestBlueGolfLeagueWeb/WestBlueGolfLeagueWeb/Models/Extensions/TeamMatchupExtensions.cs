using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Extensions
{
	public static class TeamMatchupExtensions
	{
		private static readonly string[] TeeTimes = new string[] { "3:44 (3:52)", "4:00 (4:08)", "4:16 (4:24)", "4:32 (4:40)", "4:48 (4:56)", "n/a" };

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
			return teamMatchup.matchOrder == null ? "n/a" : TeeTimes[teamMatchup.matchOrder.Value];
		}

		public static bool Team1Won(this teammatchup teamMatchup)
		{
			return teamMatchup.PointsForTeam(0) > 48;
		}

		public static bool Team2Won(this teammatchup teamMatchup)
		{
			return teamMatchup.PointsForTeam(1) > 48;
		}

        public static int? PointsFor(this teammatchup tm, team team)
        {
            return tm.matches.Select(x => x.results.FirstOrDefault(r => r.teamId == team.id)).Sum(x => x == null ? 0 : x.points);
        }

        public static bool IsComplete(this teammatchup tm)
        {
            return tm.matches != null && tm.matches.Count > 0 && tm.matches.All(x => x.IsComplete());
        }
	}
}