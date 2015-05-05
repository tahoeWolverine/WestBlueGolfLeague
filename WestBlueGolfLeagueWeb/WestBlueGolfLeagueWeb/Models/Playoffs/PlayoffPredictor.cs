using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Playoffs
{
    public class PlayoffPredictor
    {
        private IEnumerable<leaderboarddata> rankings;
        private IEnumerable<week> allWeeks;

        public PlayoffPredictor(IEnumerable<leaderboarddata> rankingLeaderboard, IEnumerable<week> allWeeks)
        {
            this.rankings = rankingLeaderboard;
            this.allWeeks = allWeeks;
        }

        public List<GroupedPlayoffMatchup> PredictPlayoffMatchups()
        {
            // only grab playoff weeks.
            var playoffWeeksInOrder = this.allWeeks.Where(x => x.isPlayoff).OrderBy(x => x.seasonIndex);

            if (this.rankings.Count() != 10)
            {
                throw new Exception("Right now playoff rankings are only implemented for a 10 team league.");
            }

            var sortedRanks = this.rankings.OrderBy(x => x.rank).ToList();

            // TODO: what about ties??  Need to implement tie breaking rules.

            // If week1 is complete, pull the matchup and return that.  How to match back to seed?

            // Week 1
            var week1PlayoffMatchup = new GroupedPlayoffMatchup { Week = playoffWeeksInOrder.First() };

            List<PlayoffMatchup> playoffMatchupsWeek1 = new List<PlayoffMatchup>(5);
            playoffMatchupsWeek1.Add(new PlayoffMatchup { PlayoffType = PlayoffTypes.Championship, Team1 = sortedRanks[0].id, Team2 = sortedRanks[3].id, Team1Seed = 1, Team2Seed = 4 });
            playoffMatchupsWeek1.Add(new PlayoffMatchup { PlayoffType = PlayoffTypes.Championship, Team1 = sortedRanks[1].id, Team2 = sortedRanks[2].id, Team1Seed = 2, Team2Seed = 3 });
            playoffMatchupsWeek1.Add(new PlayoffMatchup { PlayoffType = PlayoffTypes.Consolation, Team1 = sortedRanks[4].id, Team2 = sortedRanks[7].id, Team1Seed = 5, Team2Seed = 8 });
            playoffMatchupsWeek1.Add(new PlayoffMatchup { PlayoffType = PlayoffTypes.Consolation, Team1 = sortedRanks[5].id, Team2 = sortedRanks[6].id, Team1Seed = 6, Team2Seed = 7 });
            playoffMatchupsWeek1.Add(new PlayoffMatchup { PlayoffType = PlayoffTypes.LastPlace, Team1 = sortedRanks[8].id, Team2 = sortedRanks[9].id, Team1Seed = 9, Team2Seed = 10 });

            // Week 2
            // need to look at all matchups... if they are all completed we'll not predict the matches

            if (playoffWeeksInOrder.First().teammatchups.All(x => x.matchComplete))
            {

            }
            else
            {

            }

            return null;
        }
    }
}