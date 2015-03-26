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

        public DateTimeOffset WeekDate { get; set; }

        [Required]
        [Range(5, 100, ErrorMessage = "Must be between 5 and 100")]
        public int NumberOfWeeks { get; set; }

        public List<int> PlayersInLeagueForYear { get; set; }
    }
}