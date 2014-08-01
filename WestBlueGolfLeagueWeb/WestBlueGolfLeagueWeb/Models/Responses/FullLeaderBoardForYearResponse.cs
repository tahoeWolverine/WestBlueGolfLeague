using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class FullLeaderBoardForYearResponse
    {
        public IEnumerable<LeaderBoardDataWebResponse> LeaderBoardData { get; set; }
        public LeaderBoardResponse LeaderBoard { get; set; }
    }
}