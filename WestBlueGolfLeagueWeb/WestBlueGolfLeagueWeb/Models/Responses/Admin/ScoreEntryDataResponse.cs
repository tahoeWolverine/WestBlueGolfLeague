using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses.Admin
{
	public class ScoreEntryDataResponse
	{
		public ScoreEntryDataResponse()
		{
			
		}

		public ScoreEntryDataResponse(
			week currentWeek, 
			IEnumerable<week> allWeeks, 
			IDictionary<int, IEnumerable<player>> allPlayersForYear,
			IEnumerable<team> allTeamsForYear)
		{
			this.CurrentWeek = currentWeek == null ? null : new ScheduleWeek(currentWeek);
			this.Schedule = new ScheduleResponse
			{
				Weeks = allWeeks.Where(x => x.teammatchups.Count > 0).Select(x => new ScheduleWeek(x))
			};

			this.Teams = allTeamsForYear.Select(TeamResponse.From);
			this.TeamIdToPlayer = allPlayersForYear.ToDictionary(x => x.Key, x => x.Value.Select(y => new PlayerWebResponse(y)));
		}

		public ScheduleWeek CurrentWeek { get; set; }
		public ScheduleResponse Schedule { get; set; }
		public IEnumerable<TeamResponse> Teams { get; set; }
		public IDictionary<int, IEnumerable<PlayerWebResponse>> TeamIdToPlayer { get; set; }
	}
}