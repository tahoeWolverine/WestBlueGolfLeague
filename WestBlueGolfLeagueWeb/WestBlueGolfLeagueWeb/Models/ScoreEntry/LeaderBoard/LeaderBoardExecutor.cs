using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Data.Entity;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Extensions;
using log4net;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry.LeaderBoard
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

        public void CalculateAndSaveLeaderBoards()
        {
            this.year = this.WestBlue.years.First(x => x.id == this.year.id);

            this.LeaderBoardStore.Initialize();

            var allPlayersForYear = this.db.AllPlayersForYear(this.year, includeResults: true);
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
                var thrown = new Exception("Error calculating player leaderboard: " + playerLeaderBoard.LeaderBoardName + ", " + currPlayer.name, e);
                Logger.Error(thrown);
                throw thrown;
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
                var thrown = new Exception("Error calculating team board: " + teamLeaderBoard.LeaderBoardName + ", " + currTeam.teamName, e);
                Logger.Error(thrown);
                throw thrown;
            }

            // For each multi value board, create it if it doesn't exist
            // get leaderboard datas
            // execute query/code

            this.db.SaveChanges();
        }

        public double CalculateBoardValueForPlayer(PlayerLeaderBoard plb, player p, year y)
        {
            var value = plb.DoCalculation(p, y, p.AllResultsForYear(y));

            return value.HasValue ? value.Value : 0;
        }

        public double CalculateBoardValueForTeam(TeamLeaderBoard tlb, team t, year y)
        {
            var value = tlb.DoCalculation(t, y, t.AllResultsForYear(y));

            return value.HasValue ? value.Value : 0.0;
        }

        public string FormattedBoardValueForPlayer(PlayerLeaderBoard plb, player p, year y)
        {
            var value = this.CalculateBoardValueForPlayer(plb, p, y);

            return plb.Format.FormatValue(value);
        }

        public string FormattedBoardValueForTeam(TeamLeaderBoard tlb, team t, year y)
        {
            var value = this.CalculateBoardValueForTeam(tlb, t, y);

            return tlb.Format.FormatValue(value);
        }

        /// <summary>
        /// Cleans up board datas
        /// </summary>
        private void CleanUpLeaderBoardDatas<T>(IEnumerable<int> ids, ILeaderBoard board)
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

        private void CalculateAndSetValue<T>(int id, SingleEntityLeaderBoard<T> lb, IEnumerable<result> results, T t)
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