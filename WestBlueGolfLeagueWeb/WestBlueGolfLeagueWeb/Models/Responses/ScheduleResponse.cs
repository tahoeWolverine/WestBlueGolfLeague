using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class ScheduleResponse
    {
        public IEnumerable<WeekWebResponse> Weeks { get; set; }
    }
}