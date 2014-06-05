using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class FullLeaderBoardForYearResponse
    {
        public IEnumerable<LeaderBoardDataResponse> LeaderBoardData { get; set; }
    }
}