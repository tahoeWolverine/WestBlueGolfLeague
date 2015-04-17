using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Schedule
{
	public class RosterInitializer
	{
		private Dictionary<string, player> playersLookup;
		private IEnumerable<TeamRoster> rosters;
		private LinkedList<playeryeardata> playeryeardatasToCreate = new LinkedList<playeryeardata>(); 

		public RosterInitializer(IEnumerable<TeamRoster> rostersToInitialize, IEnumerable<player> allLeaguePlayers)
		{
			this.playersLookup = allLeaguePlayers.ToDictionary(x => x.name.ToLowerInvariant());
			this.rosters = rostersToInitialize;
		}

		public void IntializeRosters(year yearToInitialize)
		{
			LinkedList<string> playersNotFoundInDb = new LinkedList<string>();

			foreach (var roster in rosters)
			{
				foreach (var playerName in roster.GetPlayers())
				{
					player currentPlayer = null;

					if (!this.playersLookup.TryGetValue(playerName.ToLowerInvariant(), out currentPlayer))
					{
						playersNotFoundInDb.AddLast(playerName);
					}

					// find the latest year data, this will be the one we copy from.  If they don't have one, then 
					// push on to list of not founds.
					var recentPyd = currentPlayer.playeryeardatas.OrderByDescending(x => x.year.value).FirstOrDefault();

					if (recentPyd == null)
					{
						playersNotFoundInDb.AddLast(playerName);
					}

					var newPlayerYearData =
						new playeryeardata
						{
							// TODO: double check week0score with Mike.
							isRookie = false,
							year = yearToInitialize,
							startingHandicap = recentPyd.finishingHandicap,
							week0Score = recentPyd.week0Score,
							team = roster.Team,
							player = currentPlayer
						};

					roster.Team.playeryeardatas.Add(newPlayerYearData);
					this.playeryeardatasToCreate.AddLast(newPlayerYearData);
				}
			}
		}

		public async void PersistRostersAsync(WestBlue db)
		{
			db.playeryeardatas.AddRange(this.playeryeardatasToCreate);

			await db.SaveChangesAsync();
		}
	}
}