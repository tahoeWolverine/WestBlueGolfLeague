using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Playoffs
{
    public class PlayoffMatchup
    {
        public int Team1 { get; set; }
        public int Team2 { get; set; }
        public int Team1Seed { get; set; }
        public int Team2Seed { get; set; }
        public string PlayoffType { get; set; }
    }
}