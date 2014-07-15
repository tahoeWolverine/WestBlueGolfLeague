using System.Collections.Generic;
using WestBlueGolfLeagueWeb.Models.Responses;

namespace WestBlueGolfLeagueWeb.Models.ViewModels
{
    public class PlayerListViewModel
    {
        public IEnumerable<PlayerResponse> PlayersForYear { get; set; }
    }
}