using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WestBlueGolfLeagueWeb.Models.Entities;
using System.Data.Entity;
using WestBlueGolfLeagueWeb.Models.Responses;
using WestBlueGolfLeagueWeb.Models.ViewModels;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class TeamController : WestBlueDbMvcController
    {
        //
        // GET: /Team/
        public ActionResult Index()
        {
            int year = 2014;

            var teamsForYear = this.Db.GetTeamsForYear(year);

            return View(new TeamListViewModel { TeamsForYear = teamsForYear.Select(x => new { Name = x.teamName, Valid = x.validTeam, Id = x.id }) });
        }

        //
        // GET: /Team/Details/5
        public ActionResult Details(int id)
        {
            var team = this.Db.teams.Where(x => x.id == id).FirstOrDefault();

            if (team == null)
            {
                // do 404 here
            }

            return View(team);
        }
    }
}
