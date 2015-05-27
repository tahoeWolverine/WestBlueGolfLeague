using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Data.Entity;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Extensions;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    /// <summary>
    /// Crunches and computes leaderboards
    /// </summary>
    public class LeaderBoardCalculator
    {
        /// <summary>
        /// Global lock used to computer leaderboards until we know what we're doing.
        /// </summary>
        private static readonly object LockObject = new object();

        private WestBlue database;
        private int teamMatchupId;

        public LeaderBoardCalculator(WestBlue db, int tmId)
        {
            this.database = db;
            this.teamMatchupId = tmId;
        }

        //public async Task<leaderboarddata> GetTeamRankingBoardData()

        public async Task ComputeAndSaveLeaderBoardsAsync()
        {
            // TODO: only calculate handicaps and leaderboards if needed.


            // Eagerly fetch everything we're going to need.
            var teamMatchup = (await this.database.teammatchups
                            .Include(x => x.matches)
                            .Include(x => x.week)
                            .Include(x => x.teams)
                            .Where(x => x.id == this.teamMatchupId).ToListAsync()).First();

            // get all the leaderboard datas and leaderboards we could possibly need
            var teamBoardsToCompute = new List<string> { "team_ranking" };
            var playerBoardsToCompute = new List<string> { "player_handicap" };
            var teamIds = teamMatchup.teams.Select(x => x.id);

            var teamBoardDataLookup = (await this.database.leaderboarddatas.Include(x => x.leaderboard)
                .Where(x => x.year.value == teamMatchup.week.year.value && teamBoardsToCompute.Contains(x.leaderboard.key) && teamIds.Contains(x.teamId.Value)).ToListAsync()).ToLookup(x => x.teamId.Value);

            var boardLookup = (await this.database.leaderboards.Where(x => teamBoardsToCompute.Contains(x.key) || playerBoardsToCompute.Contains(x.key)).ToListAsync()).ToDictionary(x => x.key, x => x);

            var resultsForYear = await this.database.results.Where(x => teamIds.Contains(x.teamId) && x.year.value == teamMatchup.week.year.value).ToListAsync();

            var resultsForPlayer = resultsForYear.ToLookup(x => x.playerId);

            var resultsForYearLookupByTeam = resultsForYear.ToLookup(x => x.teamId);

            // TODO: this board lookup stuff needs to be more generic. For now just do the team ranking board.
            //this.UpdateTeamRanking(teamBoardDataLookup, boardLookup, resultsForYearLookupByTeam, teamMatchup);

            var lbe = new LeaderBoardExecutor(teamMatchup.week.year);

            await lbe.ExecuteLeaderBoards();

            this.UpdatePlayerHandicaps(teamMatchup, resultsForPlayer);

            await this.database.SaveChangesAsync();
        }

        /// <summary>
        /// 
        /// </summary>
        private void UpdatePlayerHandicaps(teammatchup tm, ILookup<int, result> resultsLookup)
        {
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

                    // TODO: update handicap leaderboard :\
                }
            }
        }

        /// <summary>
        /// This needs to somehow be made generic maybe... this kind of thing has to happen for every leaderboard.
        /// </summary>
        private void UpdateTeamRanking(ILookup<int, leaderboarddata> lookup, IDictionary<string, leaderboard> leaderBoardLookup, ILookup<int, result> resultsForYear, teammatchup teamMatchup)
        {
            var teamIds = teamMatchup.teams.Select(x => x.id);

            // team ranking board data
            foreach (var team in teamMatchup.teams)
            {
                var lbd = lookup[team.id].FirstOrDefault(x => x.leaderboard.key == "team_ranking");

                double value = team.PointsForYear(resultsForYear[team.id]);
                string formattedValue = Convert.ToString(value);
                int ranking = 1;

                if (lbd == null) 
                {
                    lbd = new leaderboarddata { isPlayer = false, leaderBoardId = leaderBoardLookup["team_ranking"].id, value = value, rank = ranking, formattedValue = formattedValue, teamId = team.id, yearId = teamMatchup.week.year.id };
                    this.database.leaderboarddatas.Add(lbd);
                }
                else 
                {
                    lbd.value = value;
                    lbd.formattedValue = formattedValue;
                    lbd.rank = ranking;
                }
            }
        }
    }
}