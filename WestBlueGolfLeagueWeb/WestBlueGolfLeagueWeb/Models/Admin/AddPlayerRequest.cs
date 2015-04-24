using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Admin
{
    public class AddPlayerRequest
    {
        public string PlayerName { get; set; }
        public int Handicap { get; set; }
        public int TeamId { get; set; }
    }
}