using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses.LeaderBoard
{
    public class AvailableLeaderBoardsResponse
    {
        public IEnumerable<leaderboard> LeaderBoards { get; set; }
    }
}