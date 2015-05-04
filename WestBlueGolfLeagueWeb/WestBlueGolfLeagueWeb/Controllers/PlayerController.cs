using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WestBlueGolfLeagueWeb.Models.Entities;
using System.Data.Entity;
using WestBlueGolfLeagueWeb.Models.Responses;
using WestBlueGolfLeagueWeb.Models.ViewModels;
using System.Threading.Tasks;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class PlayerController : WestBlueDbMvcController
    {
        //
        // GET: /Player/
        public ActionResult Index()
        {
            int year = this.SelectedYear;

            var playersForYear = this.Db.GetPlayersWithTeamsForYear(year);

	        return
		        View(new PlayerListViewModel
		        {
			        PlayersForYear =
				        playersForYear.Select(
					        x =>
						        new { Name = x.Item1.name, CH = x.Item1.currentHandicap, TeamName = x.Item2.teamName, Id = x.Item1.id })
		        });

        }
    }
}
