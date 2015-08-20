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

            if (this.rankings.Count() != 8)
            {
                return new List<GroupedPlayoffMatchup>();
            }

            var sortedRanks = this.rankings.OrderBy(x => x.rank).ToList();

            // TODO: what about ties??  Need to implement tie breaking rules.

            // If week1 is complete, pull the matchup and return that.  How to match back to seed?

            var predictionResults = new List<GroupedPlayoffMatchup>(2);

            // Week 1
            var week1 = playoffWeeksInOrder.First();
            var week1NotSet = week1.teammatchups.Count == 0 && week1.teammatchups.All(x => x.matchComplete);

            if (week1NotSet)
            {
                var week1PlayoffMatchup = new GroupedPlayoffMatchup { Week = playoffWeeksInOrder.First() };

                List<PlayoffMatchup> playoffMatchupsWeek1 = new List<PlayoffMatchup>(4);
                playoffMatchupsWeek1.Add(new PlayoffMatchup { PlayoffType = PlayoffTypes.Championship, Team1 = sortedRanks[0].team, Team2 = sortedRanks[3].team, Team1Seed = 1, Team2Seed = 4 });
                playoffMatchupsWeek1.Add(new PlayoffMatchup { PlayoffType = PlayoffTypes.Championship, Team1 = sortedRanks[1].team, Team2 = sortedRanks[2].team, Team1Seed = 2, Team2Seed = 3 });
                playoffMatchupsWeek1.Add(new PlayoffMatchup { PlayoffType = PlayoffTypes.Consolation, Team1 = sortedRanks[4].team, Team2 = sortedRanks[7].team, Team1Seed = 5, Team2Seed = 8 });
                playoffMatchupsWeek1.Add(new PlayoffMatchup { PlayoffType = PlayoffTypes.Consolation, Team1 = sortedRanks[5].team, Team2 = sortedRanks[6].team, Team1Seed = 6, Team2Seed = 7 });

                week1PlayoffMatchup.PlayoffMatchups = playoffMatchupsWeek1;

                predictionResults.Add(week1PlayoffMatchup);
            }

            // Week 2
            // need to look at all matchups... if they are all completed we'll not predict the matches.  Need to look at what teams won/lost in the first week somehow.

            var week1Complete = week1.teammatchups.Count != 0 && week1.teammatchups.All(x => x.matchComplete);

            if (week1Complete)
            {

            }
            else
            {

            }

            return predictionResults;
        }
    }
}