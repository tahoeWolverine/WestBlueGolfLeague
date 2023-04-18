using System.Collections.Generic;
using System.Linq;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Schedule
{
	public class RosterInitializer
	{
		private Dictionary<string, player> playersLookup;
		private IEnumerable<TeamRoster> rosters;
        private LinkedList<playeryeardata> playeryeardatasToCreate = new LinkedList<playeryeardata>();
        private year yearToInitialize; 

		public RosterInitializer(IEnumerable<TeamRoster> rostersToInitialize, IEnumerable<player> allLeaguePlayers, year yearToInitialize)
		{
			this.playersLookup = allLeaguePlayers.GroupBy(x => x.name).Select(g => g.First()).ToDictionary(x => x.name.ToLowerInvariant());
			this.rosters = rostersToInitialize;
            this.yearToInitialize = yearToInitialize;

            this.NewPlayers = this.IntializeRosters();
		}

		private IEnumerable<string> IntializeRosters()
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
                        continue;
					}

					// find the latest year data, this will be the one we copy from.  If they don't have one, then 
					// push on to list of not founds.
					var recentPyd = currentPlayer.playeryeardatas.OrderByDescending(x => x.year.value).FirstOrDefault();

					if (recentPyd == null)
					{
						playersNotFoundInDb.AddLast(playerName);
                        continue;
					}

					var newPlayerYearData =
						new playeryeardata
						{
							isRookie = false,
							year = this.yearToInitialize,
							startingHandicap = recentPyd.finishingHandicap,
                            finishingHandicap = recentPyd.finishingHandicap, // we may use finishing handicap during leaderboard calcs.
							week0Score = recentPyd.finishingHandicap + 36,
							team = roster.Team,
							player = currentPlayer
						};

                    currentPlayer.currentHandicap = recentPyd.finishingHandicap; // just to make sure these values are consistent.

					//roster.Team.playeryeardatas.Add(newPlayerYearData);
                    //currentPlayer.playeryeardatas.Add(newPlayerYearData);
					this.playeryeardatasToCreate.AddLast(newPlayerYearData);
				}
			}

			return playersNotFoundInDb;
		}

        /// <summary>
        /// Does not have save to the database.
        /// </summary>
        /// <param name="db"></param>
		public void PersistRosters(WestBlue db)
		{
			db.playeryeardatas.AddRange(this.playeryeardatasToCreate);
		}

        public IEnumerable<string> NewPlayers { get; private set; }
        public IEnumerable<playeryeardata> NewPlayerYearDatas { get { return this.playeryeardatasToCreate; } }
    }
}