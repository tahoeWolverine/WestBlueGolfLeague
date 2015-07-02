using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry.LeaderBoard
{
    public interface ILeaderBoard
    {
        LeaderBoardFormat Format { get; set; }
        string LeaderBoardKey { get; set; }
        string LeaderBoardName { get; set; }
        bool Ascending { get; set; }
        bool IsPlayerBoard { get; }
        int Priority { get; }
    }
}
