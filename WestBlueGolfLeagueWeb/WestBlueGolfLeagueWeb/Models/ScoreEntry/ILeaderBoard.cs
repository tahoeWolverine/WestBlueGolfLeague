using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    interface ILeaderBoard<T>
    {
        int Format { get; set; }
        string LeaderBoardKey { get; set; }
        string LeaderBoardName { get; set; }
        bool Ascending { get; set; }
        double DoCalculation(T t);
    }
}
