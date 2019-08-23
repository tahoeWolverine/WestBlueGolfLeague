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
        private IEnumerable<leaderboarddata> firstHalfRankings;
        private IEnumerable<leaderboarddata> secondHalfRankings;
        private IEnumerable<week> allWeeks;

        public PlayoffPredictor(IEnumerable<leaderboarddata> rankingLeaderboard, IEnumerable<leaderboarddata> firstHalfLeaderboard, IEnumerable<leaderboarddata> secondHalfLeaderboard, IEnumerable<week> allWeeks)
        {
            this.rankings = rankingLeaderboard;
            this.firstHalfRankings = firstHalfLeaderboard;
            this.secondHalfRankings = secondHalfLeaderboard;
            this.allWeeks = allWeeks;
        }

        public List<GroupedPlayoffMatchup> PredictPlayoffMatchups()
        {
            // only grab playoff weeks.
            var playoffWeeksInOrder = this.allWeeks.Where(x => x.isPlayoff).OrderBy(x => x.seasonIndex);

            if (this.rankings.Count() != 6 || playoffWeeksInOrder.Count() == 0)
            {
                return new List<GroupedPlayoffMatchup>();
            }

            var sortedRanks = this.rankings.OrderBy(x => x.rank).ToList();
            var sortedFirstHalfRanks = this.firstHalfRankings.OrderBy(x => x.rank).ToList();
            var sortedSecondHalfRanks = this.secondHalfRankings.OrderBy(x => x.rank).ToList();

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
                PlayoffMatchup championship;

                bool uniqueFirstHalfWinner = sortedFirstHalfRanks[0].value != sortedFirstHalfRanks[1].value;
                bool uniqueSecondHalfWinner = sortedSecondHalfRanks[0].value != sortedSecondHalfRanks[1].value;
                leaderboarddata bestOverall = sortedRanks[0];
                leaderboarddata secondOverall = sortedRanks[1];

                if (uniqueFirstHalfWinner && uniqueSecondHalfWinner && sortedSecondHalfRanks[0].teamId != sortedFirstHalfRanks[0].teamId)
                {
                    championship = new PlayoffMatchup { PlayoffType = PlayoffTypes.Championship, Team1 = sortedFirstHalfRanks[0].team, Team2 = sortedSecondHalfRanks[0].team, Team1Seed = 1, Team2Seed = 2 };
                    // Remove champ teams from sorted ranks to make it easier to fill out other matches
                    sortedRanks.RemoveAll(x => x.teamId == sortedFirstHalfRanks[0].teamId);
                    sortedRanks.RemoveAll(x => x.teamId == sortedSecondHalfRanks[0].teamId);
                }
                else if (uniqueFirstHalfWinner)
                {
                    // If 2nd spot playoff spot is occupied by same team as first spot, drop to 2nd overall
                    if (sortedFirstHalfRanks[0].teamId == bestOverall.teamId)
                    {
                        championship = new PlayoffMatchup { PlayoffType = PlayoffTypes.Championship, Team1 = sortedFirstHalfRanks[0].team, Team2 = secondOverall.team, Team1Seed = 1, Team2Seed = 2 };
                        sortedRanks.RemoveAll(x => x.teamId == sortedFirstHalfRanks[0].teamId);
                        sortedRanks.Remove(secondOverall);
                    } else
                    {
                        championship = new PlayoffMatchup { PlayoffType = PlayoffTypes.Championship, Team1 = sortedFirstHalfRanks[0].team, Team2 = bestOverall.team, Team1Seed = 1, Team2Seed = 2 };
                        sortedRanks.RemoveAll(x => x.teamId == sortedFirstHalfRanks[0].teamId);
                        sortedRanks.Remove(bestOverall);
                    }
                }
                else
                {
                    // If 2nd spot playoff spot is occupied by same team as first spot, drop to 2nd overall
                    if (sortedSecondHalfRanks[0].teamId == bestOverall.teamId)
                    {
                        championship = new PlayoffMatchup { PlayoffType = PlayoffTypes.Championship, Team1 = sortedSecondHalfRanks[0].team, Team2 = secondOverall.team, Team1Seed = 1, Team2Seed = 2 };
                        sortedRanks.Remove(secondOverall);
                        sortedRanks.RemoveAll(x => x.teamId == sortedSecondHalfRanks[0].teamId);
                    }
                    else
                    {
                        championship = new PlayoffMatchup { PlayoffType = PlayoffTypes.Championship, Team1 = sortedSecondHalfRanks[0].team, Team2 = bestOverall.team, Team1Seed = 1, Team2Seed = 2 };
                        sortedRanks.Remove(bestOverall);
                        sortedRanks.RemoveAll(x => x.teamId == sortedSecondHalfRanks[0].teamId);
                    }
                }

                playoffMatchupsWeek1.Add(new PlayoffMatchup { PlayoffType = PlayoffTypes.Consolation, Team1 = sortedRanks[2].team, Team2 = sortedRanks[3].team, Team1Seed = 5, Team2Seed = 6 });
                playoffMatchupsWeek1.Add(new PlayoffMatchup { PlayoffType = PlayoffTypes.ThirdPlace, Team1 = sortedRanks[0].team, Team2 = sortedRanks[1].team, Team1Seed = 3, Team2Seed = 4 });
                playoffMatchupsWeek1.Add(championship);

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