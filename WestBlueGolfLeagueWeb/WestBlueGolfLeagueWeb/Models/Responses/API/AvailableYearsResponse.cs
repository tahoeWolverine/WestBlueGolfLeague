using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Responses.API
{
    public class AvailableYearsResponse
    {
        public List<YearResponse> AvailableYears { get; set; }
    }
}