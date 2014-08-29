using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Playoffs
{
    public class GroupedPlayoffMatchup
    {
        public week Week { get; set; }
        public IEnumerable<PlayoffMatchup> PlayoffMatchups { get; set; }
    }
}