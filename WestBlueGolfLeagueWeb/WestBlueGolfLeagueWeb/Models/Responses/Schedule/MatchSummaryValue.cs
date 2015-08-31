using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Responses.Player;

namespace WestBlueGolfLeagueWeb.Models.Responses.Schedule
{
    public class MatchSummaryValue
    {
        public PlayerWebResponse Player { get; set; }
        public string FormattedValue { get; set; }
        public double Value { get; set; }
    }
}