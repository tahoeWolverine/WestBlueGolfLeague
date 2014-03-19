using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models
{
    public class Player
    {
        public int ID { get; set; }
        public string PlayerName { get; set; }
        public string Status { get; set; }
        public int Week0Score { get; set; }
    }
}