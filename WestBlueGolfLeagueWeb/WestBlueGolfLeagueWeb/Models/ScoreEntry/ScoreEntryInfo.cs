using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Responses.Admin;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    public class ScoreEntryInfo
    {
        public TeamMatchupWithMatches TeamMatchupWithMatches { get; set; }
        public week Week { get; set; }
    }
}