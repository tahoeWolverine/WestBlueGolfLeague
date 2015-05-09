using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.ViewModels
{
    public class ResultsTableViewModel
    {
        public team Team { get; set; }
        public IEnumerable<PlayerResultsViewModel> PlayersForTeamForYear { get; set; }
        public IEnumerable<week> WeeksForYear { get; set; }

        public List<team> TeamsForYear { get; set; }

        public int toggleValue { get; set; }
    }
}