using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.ViewModels
{
    public class TeamResultsViewModel
    {
        public IEnumerable<result> ResultsForYear { get; set; }
        public team Team { get; set; }

        //public playeryeardata YearData { get; set; }
    }
}