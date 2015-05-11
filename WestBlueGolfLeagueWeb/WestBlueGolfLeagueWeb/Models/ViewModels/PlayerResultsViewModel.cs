using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.ViewModels
{
    public class PlayerResultsViewModel
    {
        public IEnumerable<result> CompleteResultsForYear { get; set; }
        public player Player { get; set; }

        public playeryeardata YearData { get; set; }
    }
}