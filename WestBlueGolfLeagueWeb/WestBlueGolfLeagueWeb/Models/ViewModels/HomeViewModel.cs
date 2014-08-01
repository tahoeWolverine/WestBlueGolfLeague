using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.ViewModels
{
    public class HomeViewModel
    {
        public IEnumerable<leaderboarddata> TeamRankingDataForYear { get; set; }
        public int SelectedYear { get; set; }
    }
}