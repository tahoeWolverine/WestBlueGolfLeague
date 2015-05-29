using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;
using System.Data.Entity;
using System.Threading.Tasks;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    public class LeaderBoardStore
    {
        private IDictionary<string, leaderboard> keyToLeaderBoard = new Dictionary<string, leaderboard>();
        private IDictionary<string, leaderboarddata> idToLeaderBoardData = new Dictionary<string, leaderboarddata>();
        private IDictionary<string, ISet<leaderboarddata>> boardToData;

        private WestBlue db;
        private year year;

        public LeaderBoardStore(WestBlue westBlue, year year)
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

            this.boardToData = leaderBoards.ToDictionary(x => x.key, x => (ISet<leaderboarddata>)new HashSet<leaderboarddata>());

            foreach (leaderboarddata data in leaderBoardData)
            {
                boardToData[leaderBoardIdToLeaderBoard[data.leaderBoardId].key].Add(data);
            }
        }

        public leaderboard GetLeaderBoard<T>(ILeaderBoard<T> lb)
        {
            leaderboard dbLb = null;

            if (!keyToLeaderBoard.TryGetValue(lb.LeaderBoardKey, out dbLb))
            {
                dbLb = new leaderboard
                {
                    key = lb.LeaderBoardKey,
                    isPlayerBoard = lb.IsPlayerBoard,
                };

                dbLb = this.db.leaderboards.Add(dbLb);
                this.boardToData[dbLb.key] = new HashSet<leaderboarddata>();

                keyToLeaderBoard[lb.LeaderBoardKey] = dbLb;
            }

            dbLb.name = lb.LeaderBoardName;
            dbLb.formatType = lb.Format.PersistedKey;
            dbLb.priority = lb.Priority;

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
                this.boardToData[dbLb.key].Add(lbd);
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
	            //lbd.leaderboard.leaderboarddatas.Remove(lbd);

                ISet<leaderboarddata> lbdSet = null;

                if (this.boardToData.TryGetValue(leaderBoardKey, out lbdSet))
                {
                    lbdSet.Remove(lbd);
                }
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