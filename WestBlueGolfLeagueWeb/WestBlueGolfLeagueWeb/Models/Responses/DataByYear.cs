using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class DataByYear
    {
        public List<player> PlayersForYear { get; set; }
        public List<leaderboarddata> LeaderboardDataForYear { get; set; }
        public List<TeamResponse> TeamsForYear { get; set; }
        public List<leaderboard> Leaderboards { get; set; }
        public List<TeamMatchupResponse> TeamMatchups { get; set; }
    }
}