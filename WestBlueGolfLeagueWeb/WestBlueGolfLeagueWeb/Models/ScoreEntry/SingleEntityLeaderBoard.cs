using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    public delegate double LeaderBoardCalculation<T>(T entity, year year);
    public delegate bool CalculateValueTest<T>(T entity, year year);

    public class SingleEntityLeaderBoard<T> : ILeaderBoard<T>
    {
        private LeaderBoardCalculation<T> calc;
        private CalculateValueTest<T> calculateValueTest;

        public SingleEntityLeaderBoard(
            string leaderBoardName,
            string leaderBoardKey,
            int format,
            LeaderBoardCalculation<T> calculation,
            bool isPlayerBoard = true,
            bool ascending = true,
            CalculateValueTest<T> calculateValueTest = null)
        {
            this.LeaderBoardName = leaderBoardName;
            this.Format = format;
            this.IsPlayerBoard = isPlayerBoard;
            this.LeaderBoardKey = leaderBoardKey;
            this.Ascending = ascending;
            this.calc = calculation;

            if (calculateValueTest == null)
            {
                calculateValueTest = (t, y) => { return true; };
            }
        }

        public string LeaderBoardName { get; set; }

        public int Format { get; set; }

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

        public double DoCalculation(T t, year year)
        {
            return this.calc(t, year);
        }

        public bool ShouldCalculateValue(T t, year year)
        {
            return this.calculateValueTest(t, year);
        }
    }

    public class TeamLeaderBoard : SingleEntityLeaderBoard<team>
    {
        public TeamLeaderBoard(
            string leaderBoardName, 
            string leaderBoardKey, 
            int format,
            LeaderBoardCalculation<team> calculation,
            bool ascending = true, CalculateValueTest<team> calculateValueTest = null)
            : base(leaderBoardName, leaderBoardKey, format, calculation, false, ascending, calculateValueTest)
        {
            
        }
    }

    public class PlayerLeaderBoard : SingleEntityLeaderBoard<player>
    {
        public PlayerLeaderBoard(
            string leaderBoardName,
            string leaderBoardKey,
            int format,
            LeaderBoardCalculation<player> calculation,
            bool ascending = true,
            CalculateValueTest<player> calculateValueTest = null)
            : base(leaderBoardName, leaderBoardKey, format, calculation, true, ascending, calculateValueTest)
        {

        }
    }
}