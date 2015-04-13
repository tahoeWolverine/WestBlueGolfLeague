using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Requests.Admin
{
    public class CreateYearRequest
    {
        public List<int> TeamIds { get; set; }

        public List<DateTimeOffset> SelectedDates { get; set; }

        public List<int> PlayersInLeagueForYear { get; set; }

        public List<string> TeamsToCreate { get; set; }
    }
}