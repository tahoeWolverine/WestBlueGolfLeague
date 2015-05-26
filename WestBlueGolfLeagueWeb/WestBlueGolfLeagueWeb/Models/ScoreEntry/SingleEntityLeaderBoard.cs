using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    public delegate double? LeaderBoardCalculation<T>(T entity, year year, IEnumerable<result> results);

    public class SingleEntityLeaderBoard<T> : ILeaderBoard<T>
    {
        private LeaderBoardCalculation<T> calc;

        public SingleEntityLeaderBoard(
            string leaderBoardName,
            string leaderBoardKey,
            LeaderBoardFormat format,
            LeaderBoardCalculation<T> calculation,
            int priority,
            bool isPlayerBoard = true,
            bool ascending = true)
        {
            this.LeaderBoardName = leaderBoardName;
            this.Format = format;
            this.IsPlayerBoard = isPlayerBoard;
            this.LeaderBoardKey = leaderBoardKey;
            this.Ascending = ascending;
            this.calc = calculation;
            this.Priority = priority;
        }

        public string LeaderBoardName { get; set; }

        public LeaderBoardFormat Format { get; set; }

        public string LeaderBoardKey
        {
            get;
            set;
        }

        public bool Ascending
        {
            get;
            set;
        }

        public bool IsPlayerBoard { get; private set; }

        public double? DoCalculation(T t, year year, IEnumerable<result> results)
        {
            return this.calc(t, year, results);
        }

        public int Priority { get; private set; }
    }

    public class TeamLeaderBoard : SingleEntityLeaderBoard<team>
    {
        public TeamLeaderBoard(
            string leaderBoardName, 
            string leaderBoardKey,
            LeaderBoardFormat format,
            LeaderBoardCalculation<team> calculation,
            int priority,
            bool ascending = true)
            : base(leaderBoardName, leaderBoardKey, format, calculation, priority, false, ascending)
        {
            
        }
    }

    public class PlayerLeaderBoard : SingleEntityLeaderBoard<player>
    {
        public PlayerLeaderBoard(
            string leaderBoardName,
            string leaderBoardKey,
            LeaderBoardFormat format,
            LeaderBoardCalculation<player> calculation,
            int priority,
            bool ascending = true)
            : base(leaderBoardName, leaderBoardKey, format, calculation, priority, true, ascending)
        {

        }
    }
}