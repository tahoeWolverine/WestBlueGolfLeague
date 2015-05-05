using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.ViewModels
{
    public class YearSelectorViewModel
    {
        public IEnumerable<year> Years { get; set; }
        public int SelectedYear { get; set; }
    }
}