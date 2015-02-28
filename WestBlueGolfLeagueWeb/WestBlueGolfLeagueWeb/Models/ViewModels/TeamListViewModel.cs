using System.Collections.Generic;
using WestBlueGolfLeagueWeb.Models.Responses;

namespace WestBlueGolfLeagueWeb.Models.ViewModels
{
    public class TeamListViewModel
    {
        public IEnumerable<object> TeamsForYear { get; set; }
    }
}