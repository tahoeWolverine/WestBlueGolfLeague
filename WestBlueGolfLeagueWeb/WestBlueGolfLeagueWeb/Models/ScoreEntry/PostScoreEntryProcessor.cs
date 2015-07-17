using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Data.Entity;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Extensions;
using WestBlueGolfLeagueWeb.Models.ScoreEntry.LeaderBoard;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    /// <summary>
    /// Crunches and computes leaderboards and handicaps
    /// </summary>
    public class PostScoreEntryProcessor
    {
        private WestBlue database;
        private int teamMatchupId;

        /// <summary>
        /// Global lock used to computer leaderboards until we know what we're doing.
        /// </summary>
        private static readonly object LockObject = new object();

        public PostScoreEntryProcessor(WestBlue db, int tmId)
        {
            this.database = db;
            this.teamMatchupId = tmId;
        }

        public void Execute()
        {
            lock (LockObject)
            {
                // Handicap updating.
                var teamMatchup = this.database.teammatchups
                                .Include(x => x.matches)
                                .Include(x => x.week)
                                .Where(x => x.id == this.teamMatchupId).First();

                this.UpdatePlayerHandicaps(teamMatchup);

                var lbe = new LeaderBoardExecutor(this.database, teamMatchup.week.year);
                lbe.CalculateAndSaveLeaderBoards();

                this.database.SaveChanges();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        private void UpdatePlayerHandicaps(teammatchup tm)
        {
            var teamIds = tm.teams.Select(x => x.id);
            var resultsForTeamMatchup = this.database.results.Where(x => teamIds.Contains(x.teamId) && x.year.value == tm.week.year.value).ToList();
            var resultsLookup = resultsForTeamMatchup.ToLookup(x => x.playerId);
            
            var scoreResultFactory = new ScoreResultFactory(tm.week.year.value);
            var hc = new HandicapCalculator(scoreResultFactory);

            foreach (var match in tm.matches)
            {
                // Only compute handicaps for valid matches.
                if (!match.IsComplete())
                {
                    continue;
                }

                foreach (var player in match.players)
                {
                    if (!player.validPlayer) { continue; }

                    var pyd = player.playeryeardatas.FirstOrDefault(x => x.year.value == tm.week.year.value);
                    var results = resultsLookup[player.id].Where(x => x.IsComplete()).OrderBy(x => x.match.teammatchup.week.date);

                    if (results.Count() == 0) { continue; }

                    // This is done to ensure that prior handicap is correct.
                    var mostRecentHandicap = hc.CalculateAndCascadeHandicaps(results, pyd.week0Score, pyd.isRookie);

                    player.currentHandicap = mostRecentHandicap.Handicap;
                    pyd.finishingHandicap = mostRecentHandicap.Handicap;
                }
            }
        }
    }
}