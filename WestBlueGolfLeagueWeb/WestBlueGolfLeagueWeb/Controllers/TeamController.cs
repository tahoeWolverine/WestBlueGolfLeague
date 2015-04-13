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
    public class TeamController : WestBlueDbMvcController
    {
        //
        // GET: /Team/
        public async Task<ActionResult> Index()
        {
            int year = await this.ControllerHelper.GetSelectedYearAsync(this.Db);

            var teamsForYear = this.Db.GetTeamsForYear(year);

            return View(new TeamListViewModel { TeamsForYear = teamsForYear.Select(x => new { Name = x.teamName, Valid = x.validTeam, Id = x.id }) });
        }
    }
}
