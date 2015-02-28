using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class TeamProfileData
    {
        public string TeamName { get; set; }
        public string AvgHandicap { get; set; }
        //public string LowScore { get; set; }
        public string TotalPoints { get; set; }
        //public string LowNet { get; set; }
        public string Improved { get; set; }
        public string WinLossRatio { get; set; }
        public string TotalWins { get; set; }
        public IEnumerable<TeamProfileResult> ResultsForYear { get; set; }
        
    }
}