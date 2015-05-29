using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Data.Entity;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Extensions;
using log4net;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    public class LeaderBoardExecutor
    {
        private WestBlue db;
        private year year;
        private LeaderBoardStore lbc;

        private static readonly ILog Logger = LogManager.GetLogger(typeof(LeaderBoardExecutor));

        public LeaderBoardExecutor(year year)
        {
            this.year = year;
        }

        public async Task ExecuteLeaderBoards()
        {
            this.year = await this.WestBlue.years.FirstAsync(x => x.id == this.year.id);
            
            await this.LeaderBoardStore.Initialize();

            var allPlayersForYear = await this.db.AllPlayersForYear(this.year, includeResults: true);
            var playerIds = allPlayersForYear.Select(x => x.id);

            PlayerLeaderBoard playerLeaderBoard = null;
            player currPlayer = null;

            try
            {
                foreach (var lb in LeaderBoards.PlayerBoards)
                {
                    playerLeaderBoard = lb;

                    this.CleanUpLeaderBoardDatas<player>(playerIds, lb);

                    foreach (player p in allPlayersForYear)
                    {
                        currPlayer = p;

                        var results = p.AllResultsForYear(year);

                        this.CalculateAndSetValue(p.id, lb, results, p);
                    }

                    var leaderBoardDatas = this.LeaderBoardStore.GetBoardData(lb.LeaderBoardKey);

                    this.SortAndRankLeaderBoardData(leaderBoardDatas, lb.Ascending);
                }
            }
            catch (Exception e)
            {
                Logger.Error("Error executing player leaderboard: " + playerLeaderBoard.LeaderBoardKey + ", " + currPlayer.name, e);
            }

            TeamLeaderBoard teamLeaderBoard = null;
            team currTeam = null;

            try
            {
                var teams = this.db.TeamsForYear(this.year.value).Where(x => !string.Equals("league subs", x.teamName, StringComparison.OrdinalIgnoreCase));
                var teamIds = teams.Select(x => x.id);

                foreach (var lb in LeaderBoards.TeamBoards)
                {
                    teamLeaderBoard = lb;

                    this.CleanUpLeaderBoardDatas<team>(teamIds, lb);

                    foreach (var t in teams)
                    {
                        currTeam = t;

                        var results = t.AllResultsForYear(year);

                        this.CalculateAndSetValue(t.id, lb, results, t);
                    }

                    var leaderBoardDatas = this.LeaderBoardStore.GetBoardData(lb.LeaderBoardKey);

                    this.SortAndRankLeaderBoardData(leaderBoardDatas, lb.Ascending);
                }
            }
            catch (Exception e)
            {
                Logger.Error("Error executing team board: " + teamLeaderBoard.LeaderBoardKey + ", " + currTeam.teamName, e);
            }

            // For each multi value board, create it if it doesn't exist
            // get leaderboard datas
            // execute query/code
            
            await this.db.SaveChangesAsync();
        }

        public double? CalculateBoardValueForPlayer(PlayerLeaderBoard plb, player p, year y)
        {
            return plb.DoCalculation(p, y, p.AllResultsForYear(y));
        }

        public double? CalculateBoardValueForTeam(TeamLeaderBoard tlb, team t, year y)
        {
            return tlb.DoCalculation(t, y, t.AllResultsForYear(y));
        }

        /// <summary>
        /// Cleans up board datas
        /// </summary>
        private void CleanUpLeaderBoardDatas<T>(IEnumerable<int> ids, ILeaderBoard<T> board)
        {
            var lookup = new HashSet<int>(ids);

            var datas = new List<leaderboarddata>(this.LeaderBoardStore.GetBoardData(board.LeaderBoardKey));

            foreach (var d in datas)
            {
                int id = board.IsPlayerBoard ? d.playerId.Value : d.teamId.Value;

                if (!lookup.Contains(id))
                {
                    this.LeaderBoardStore.DeleteLeaderBoardData(id, board.LeaderBoardKey);
                }
            }
        }

        private void CalculateAndSetValue<T>(int id, ILeaderBoard<T> lb, IEnumerable<result> results, T t)
        {
            var value = lb.DoCalculation(t, this.year, results);

            if (value.HasValue)
            {
				var lbd = this.LeaderBoardStore.GetLeaderBoardData(id, lb);
                lbd.value = value.Value;
				lbd.formattedValue = lb.Format.FormatValue(lbd.value);
            }
            else
            {
	            this.LeaderBoardStore.DeleteLeaderBoardData(id, lb.LeaderBoardKey);
            }
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

        public LeaderBoardStore LeaderBoardStore
        {
            get
            {
                if (this.lbc == null)
                {
                    this.lbc = new LeaderBoardStore(this.WestBlue, this.year);
                }

                return this.lbc;
            }
            set
            {
                this.lbc = value;
            }
        }

        public WestBlue WestBlue
        {
            get
            {
                if (this.db == null)
                {
                    this.db = new WestBlue();
                }

                return this.db;
            }
            set
            {
                this.db = value;
            }
        }
    }
}