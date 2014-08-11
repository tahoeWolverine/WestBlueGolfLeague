using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class PlayerProfileData
    {
        public string PlayerName { get; set; }
        public string Handicap { get; set; }
        public string LowScore { get; set; }
        public string AveragePoints { get; set; }
        public string LowNet { get; set; }
        public string Improved { get; set; }

        
    }
}