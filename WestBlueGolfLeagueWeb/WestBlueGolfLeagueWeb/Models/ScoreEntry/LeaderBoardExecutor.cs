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
            private static int priorityCounter = 1;

            public static readonly List<PlayerLeaderBoard> Boards = new
                List<PlayerLeaderBoard>
                {
                    new PlayerLeaderBoard( "Best Score", "player_best_score", LeaderBoardFormat.Default, (p, year, r) => p.LowRoundForYear(year, r), priorityCounter++),

                    new PlayerLeaderBoard( "Best Net Score", "player_net_best_score", LeaderBoardFormat.Net, (p, year, r) => p.LowNetForYear(year, r), priorityCounter++),

                    new PlayerLeaderBoard( "Handicap", "player_handicap", LeaderBoardFormat.Net, (p, year, r) => p.FinishingHandicapInYear(year), priorityCounter++),

                    new PlayerLeaderBoard( "Average Points", "player_avg_points", LeaderBoardFormat.Default, (p, year, r) => p.AveragePointsInYear(year, r), priorityCounter++, false),

                    new PlayerLeaderBoard( "Win/Loss Ratio", "player_win_loss_ratio", LeaderBoardFormat.Ratio, (p, year, r) => p.RecordRatioForYear(year, r), priorityCounter++, false),

                    new PlayerLeaderBoard( "Season Improvement", "player_season_improvement", LeaderBoardFormat.Net, (p, year, r) => p.ImprovedInYear(year), priorityCounter++),

                    new PlayerLeaderBoard( "Avg. Opp. Score", "player_avg_opp_score", LeaderBoardFormat.Default, (p, year, r) => p.AverageOpponentScoreForYear(year, r), priorityCounter++),

                    new PlayerLeaderBoard( "Avg. Opp. Net Score", "player_avg_opp_net_score", LeaderBoardFormat.Net, (p, year, r) => p.AverageOpponentNetScoreForYear(year, r), priorityCounter++),

                    new PlayerLeaderBoard( "Average Score", "player_avg_score", LeaderBoardFormat.Default, (p, year, r) => p.AverageScoreForYear(year, r), priorityCounter++),

                    new PlayerLeaderBoard( "Average Net Score", "player_avg_net_score", LeaderBoardFormat.Net, (p, year, r) => p.AverageNetScoreForYear(year, r), priorityCounter++),

                    new PlayerLeaderBoard( "Points in a Match", "player_points_in_match", LeaderBoardFormat.Default, (p, year, r) => p.MostPointsInMatchForYear(year, r), priorityCounter++, false),

                    new PlayerLeaderBoard( "Total Points", "player_total_points", LeaderBoardFormat.Default, (p, year, r) => p.TotalPointsForYear(year), priorityCounter++, false),

                    new PlayerLeaderBoard( "Total Wins", "player_total_wins", LeaderBoardFormat.Default, (p, year, r) => p.RecordForYear(year, r)[0], priorityCounter++, false),

                    new PlayerLeaderBoard( "Avg. Margin of Victory", "player_avg_margin_victory", LeaderBoardFormat.Default, (p, year, r) => p.AverageMarginOfVictoryForYear(year, r), priorityCounter++, false),

                    new PlayerLeaderBoard( "Avg. Margin of Net Victory", "player_avg_margin_net_victory", LeaderBoardFormat.Net, (p, year, r) => p.AverageMarginOfNetVictoryForYear(year, r), priorityCounter++, false),

                    new PlayerLeaderBoard( "Total Rounds", "player_total_rounds_for_year", LeaderBoardFormat.Default, (p, year, r) => p.TotalRoundsForYear(year, r), priorityCounter++, false),
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

            LeaderBoardStore lbc = new LeaderBoardStore(this.db, this.year);
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
                    else 
                    {
                        lbc.DeleteLeaderBoardData(p.id, lb.LeaderBoardKey);
                    }

                    lbd.formattedValue = Convert.ToString(lbd.value);
                }

                var leaderBoardDatas = lbc.GetBoardData(lb.LeaderBoardKey);

                this.SortAndRankLeaderBoardData(leaderBoardDatas, lb.Ascending);
            }

            // For each multi value board, create it if it doesn't exist
            // get leaderboard datas
            // execute query/code
            
            // save changessss
            await this.db.SaveChangesAsync();
        }

        private void SortAndRankLeaderBoardData(IEnumerable<leaderboarddata> datas, bool isAsc)
        {
            if (isAsc)
            {
                datas = datas.OrderBy(x => x.value).ToList();
            }
            else
            {
                datas = datas.OrderByDescending(x => x.value).ToList();
            }

            int rank = 0, count = 0;
            double previousValue = double.MaxValue;

            foreach (var lbd in datas)
            {
                count++;

                if (lbd.value != previousValue)
                {
                    rank = count;
                }

                lbd.rank = rank;
                previousValue = lbd.value;
            }
        }
    }
}