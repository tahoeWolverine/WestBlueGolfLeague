using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    interface ILeaderBoard<T>
    {
        public int Format { get; set; }
        public string LeaderBoardKey { get; set; }
        public string LeaderBoardName { get; set; }
        public bool Ascending { get; set; }
        public double DoCalculation(T t);
    }
}
