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
        private LeaderBoardStore lbc;

        public LeaderBoardExecutor(year year)
        {
            this.year = year;
        }

        public async Task ExecuteLeaderBoards()
        {
            // for each board, get board from prefetched map
            // if board doesn't already exist, create it!
            // for each player/team, get leaderboard data for board
            // create it if it doesn't exist
            // do calculation, set value, save
            this.year = await this.WestBlue.years.FirstAsync(x => x.id == this.year.id);
            
            await this.LeaderBoardStore.Initialize();

            var allPlayersForYear = await this.db.AllPlayersForYear(this.year, includeResults: true);

            foreach (var lb in LeaderBoards.PlayerBoards)
            {
                foreach (player p in allPlayersForYear)
                {
                    var results = p.AllResultsForYear(year);

                    this.CalculateAndSetValue(p.id, lb, results, p);
                }

                var leaderBoardDatas = this.LeaderBoardStore.GetBoardData(lb.LeaderBoardKey);

                this.SortAndRankLeaderBoardData(leaderBoardDatas, lb.Ascending);
            }

            foreach (var lb in LeaderBoards.TeamBoards)
            {
                foreach (team t in this.db.TeamsForYear(this.year.value))
                {
                    var results = t.AllResultsForYear(year);

                    this.CalculateAndSetValue(t.id, lb, results, t);
                }

                var leaderBoardDatas = this.LeaderBoardStore.GetBoardData(lb.LeaderBoardKey);

                this.SortAndRankLeaderBoardData(leaderBoardDatas, lb.Ascending);
            }

            // For each multi value board, create it if it doesn't exist
            // get leaderboard datas
            // execute query/code
            
            // save changessss
            await this.db.SaveChangesAsync();
        }

        private void CalculateAndSetValue<T>(int id, ILeaderBoard<T> lb, IEnumerable<result> results, T t)
        {
            var lbd = this.LeaderBoardStore.GetLeaderBoardData<T>(id, lb);

            var value = lb.DoCalculation(t, this.year, results);

            if (value.HasValue)
            {
                lbd.value = value.Value;
            }
            else
            {
                this.LeaderBoardStore.DeleteLeaderBoardData(id, lb.LeaderBoardKey);
            }

            lbd.formattedValue = lb.Format.FormatValue(lbd.value);
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