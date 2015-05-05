using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    public class HandicapCalculationResult
    {
        public int Handicap { get; set; }
        public IEnumerable<int> WeeksUsed { get; set; }
    }
}