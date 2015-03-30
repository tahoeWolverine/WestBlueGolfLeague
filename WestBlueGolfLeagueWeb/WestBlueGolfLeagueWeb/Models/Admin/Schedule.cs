using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Admin
{
    public class Schedule
    {
        public List<teammatchup> Matchups { get; set; }
        public List<week> Weeks { get; set; }
    }
}