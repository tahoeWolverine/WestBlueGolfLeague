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
    public class LeaderBoardExecutor
    {
        private WestBlue db;
        private year year;

        public class PlayerBoards
        {
            public static readonly List<PlayerLeaderBoard> Boards = new
                List<PlayerLeaderBoard>
                {
                    new PlayerLeaderBoard( "Best Score", "player_best_score", 1, (p, year, r) => p.LowRoundForYear(year)),

                    new PlayerLeaderBoard( "Best Net Score", "player_net_best_score",  1, (p, year, r) => p.LowNetForYear(year)),

                    new PlayerLeaderBoard( "Handicap", "player_handicap",  1, (p, year, r) => p.FinishingHandicapInYear(year)),

                    new PlayerLeaderBoard( "Average Points", "player_avg_points",  1, (p, year, r) => p.AveragePointsInYear(year)),

                    new PlayerLeaderBoard( "Win/Loss Ratio", "player_win_loss_ratio",  1, (p, year, r) => p.RecordRatioForYear(year)),

                    new PlayerLeaderBoard( "Season Improvement", "player_season_improvement",  1, (p, year, r) => p.ImprovedInYear(year)),

                    new PlayerLeaderBoard( "Avg. Opp. Score", "player_avg_opp_score",  1, (p, year, r) => p.AverageOpponentScoreForYear(year)),

                    new PlayerLeaderBoard( "Avg. Opp. Net Score", "player_avg_opp_net_score",  1, (p, year, r) => p.AverageOpponentNetScoreForYear(year)),

                    new PlayerLeaderBoard( "Average Score", "player_avg_score",  1, (p, year, r) => p.AverageScoreForYear(year)),

                    new PlayerLeaderBoard( "Average Net Score", "player_avg_net_score",  1, (p, year, r) => p.AverageNetScoreForYear(year)),

                    new PlayerLeaderBoard( "Points in a Match", "player_points_in_match",  1, (p, year, r) => p.MostPointsInMatchForYear(year)),

                    new PlayerLeaderBoard( "Total Points", "player_total_points",  1, (p, year, r) => p.TotalPointsForYear(year)),

                    new PlayerLeaderBoard( "Total Wins", "player_total_wins",  1, (p, year, r) => p.RecordForYear(year)[0]),

                    new PlayerLeaderBoard( "Avg. Margin of Victory", "player_avg_margin_victory",  1, (p, year, r) => p.AverageMarginOfVictoryForYear(year)),

                    new PlayerLeaderBoard( "Avg. Margin of Net Victory", "player_avg_margin_net_victory",  1, (p, year, r) => p.AverageMarginOfNetVictoryForYear(year)),

                    new PlayerLeaderBoard( "Total Rounds", "player_total_rounds_for_year",  1, (p, year, r) => p.TotalRoundsForYear(year)),
                };
        }


        public LeaderBoardExecutor(WestBlue westBlue, year year)
        {
            this.db = westBlue;
            this.year = year;
        }

        public async Task ExecuteLeaderBoards()
        {
            // for each board, get board from prefetched map
            // if board doesn't already exist, create it!
            // for each player/team, get leaderboard data for board
            // create it if it doesn't exist
            // do calculation, set value, save

            LeaderBoardContainer lbc = new LeaderBoardContainer(this.db, this.year);
            await lbc.Initialize();

            var allLeaderBoards = await this.db.leaderboards.ToListAsync();
            var allPlayersForYear = await this.db.AllPlayersForYear(this.year, includeResults: true);

            foreach (var lb in PlayerBoards.Boards)
            {
                foreach (player p in allPlayersForYear)
                {
                    var lbd = lbc.GetLeaderBoardData<player>(p.id, lb);

                    var results = p.AllResultsForYear(year);

                    var value = lb.DoCalculation(p, this.year, results);

                    if (value.HasValue) 
                    {
                        lbd.value = value.Value;
                    }
                    {
                        lbc.DeleteLeaderBoardData(p.id, lb.LeaderBoardKey);
                    }

                    lbd.formattedValue = Convert.ToString(lbd.value);
                }
            }

            // TODO: ranks

            // For each multi value board, create it if it doesn't exist
            // get leaderboard datas
            // execute query/code
            
            // save changessss
            await this.db.SaveChangesAsync();
        }
    }

    public class LeaderBoardContainer
    {
        private IDictionary<string, leaderboard> keyToLeaderBoard = new Dictionary<string, leaderboard>();
        private IDictionary<string, leaderboarddata> idToLeaderBoardData = new Dictionary<string, leaderboarddata>();
        private ILookup<string, leaderboarddata> boardToData;

        private WestBlue db;
        private year year;

        public LeaderBoardContainer(WestBlue westBlue, year year)
        {
            this.db = westBlue;
            this.year = year;
        }

        public async Task Initialize()
        {
            var leaderBoards = await this.db.leaderboards.ToListAsync();
            var leaderBoardData = await this.db.leaderboarddatas.Where(x => x.year.id == this.year.id).ToListAsync();

            var leaderBoardIdToLeaderBoard = leaderBoards.ToDictionary(x => x.id, x => x);

            this.keyToLeaderBoard = leaderBoards.ToDictionary(x => x.key, x => x);
            this.idToLeaderBoardData = leaderBoardData.ToDictionary(x => this.GetLookupKey(x.playerId.HasValue ? x.playerId.Value : x.teamId.Value, leaderBoardIdToLeaderBoard[x.leaderBoardId].key), x => x);
            this.boardToData = leaderBoardData.ToLookup(x => leaderBoardIdToLeaderBoard[x.leaderBoardId].key);
        }

        public leaderboard GetLeaderBoard<T>(ILeaderBoard<T> lb)
        {
            leaderboard dbLb = null;

            // TODO: reset priority, format, and name here. This would allow changing those leaderboard values via code.
            if (!keyToLeaderBoard.TryGetValue(lb.LeaderBoardKey, out dbLb))
            {
                dbLb = new leaderboard 
                            { 
                                key = lb.LeaderBoardKey, 
                                name = lb.LeaderBoardName, 
                                isPlayerBoard = lb.IsPlayerBoard, 
                                formatType = lb.Format, 
                                priority = keyToLeaderBoard.Values.Max(x => x.priority) + 1 
                            };

                dbLb = this.db.leaderboards.Add(dbLb);

                keyToLeaderBoard[lb.LeaderBoardKey] = dbLb;
            }

            return dbLb;
        }

        public leaderboarddata GetLeaderBoardData<T>(int id, ILeaderBoard<T> lb)
        {
            leaderboarddata lbd = null;

            leaderboard dbLb = this.GetLeaderBoard<T>(lb);

            if (!this.idToLeaderBoardData.TryGetValue(this.GetLookupKey(id, lb.LeaderBoardKey), out lbd))
            {
                lbd = new leaderboarddata { isPlayer = lb.IsPlayerBoard, leaderboard = dbLb, year = this.year };

                if (lb.IsPlayerBoard) { lbd.playerId = id; }
                else { lbd.teamId = id; }

                dbLb.leaderboarddatas.Add(lbd);
            }

            return lbd;
        }

        public void DeleteLeaderBoardData(int id, string leaderBoardKey)
        {
            leaderboarddata lbd = null;
            string key = this.GetLookupKey(id, leaderBoardKey);

            if (this.idToLeaderBoardData.TryGetValue(key, out lbd))
            {
                this.db.leaderboarddatas.Remove(lbd);
                this.idToLeaderBoardData.Remove(key);
            }
        }

        public IEnumerable<leaderboarddata> GetBoardData(string leaderBoardKey)
        {
            return this.boardToData[leaderBoardKey];
        }

        private string GetLookupKey(int id, string lbKey)
        {
            return id + "_" + lbKey;
        }
    }
}