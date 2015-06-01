using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Extensions;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry.LeaderBoard
{
    public delegate double? LeaderBoardCalculation<T>(T entity, year year, IEnumerable<result> results);

    public abstract class SingleEntityLeaderBoard<T> : ILeaderBoard
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

        public abstract IEnumerable<result> AllResultsForYear(T t, year y);
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

        public override IEnumerable<result> AllResultsForYear(team t, year y)
        {
            return t.AllResultsForYear(y);
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

        public override IEnumerable<result> AllResultsForYear(player p, year y)
        {
            return p.AllResultsForYear(y);
        }
    }
}