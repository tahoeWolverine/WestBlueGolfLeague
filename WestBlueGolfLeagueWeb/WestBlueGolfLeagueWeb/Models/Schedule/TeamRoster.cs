using System.Collections.Generic;
using System.Linq;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Schedule
{
	public class TeamRoster
	{
		private List<string> players;

		public TeamRoster(team team)
		{
			this.Team = team;
			this.players = new List<string>(10);
		}

		public TeamRoster(team team, IEnumerable<string> players)
		{
			this.Team = team;
			this.players = players.ToList();
		}

		public void AddPlayer(string player)
		{
			this.players.Add(player);
		}

		public team Team { get; private set; }

		public IEnumerable<string> GetPlayers()
		{
			return this.players;
		}
	}
}