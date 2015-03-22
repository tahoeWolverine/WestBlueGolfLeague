using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WestBlueGolfLeagueWeb.Models.Entities;
using System.Data.Entity;
using WestBlueGolfLeagueWeb.Models.ViewModels;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class ResultsTableController : WestBlueDbMvcController
    {
        // GET: ResultsTable
        public ActionResult Index()
        {
            return Details(null);
        }

        public ActionResult Details(int? id)
        {
            int year = this.ControllerHelper.GetSelectedYear();

            var allTeamsForYear = this.Db.teams.AsNoTracking().Where(x => x.validTeam == true && x.playeryeardatas.Any(y => y.year.value == year)).ToList();

            if (allTeamsForYear.Count() == 0)
            {
                // return some empty view here.
            }

            if (id == null)
            {
                id = allTeamsForYear.First().id;
            }

            var team = this.Db.teams.Where(x => x.id == id).FirstOrDefault();

            var yearDatasForYearForTeam = this.Db.playeryeardatas
                            .Include(y => y.player)
                            .Include("player.results")
                            .Include("player.results.year")
                            .Include("player.results.match.teammatchup.week")
                            .Where(y => y.year.value == year && y.teamId == id)
                            .ToList();

            var weeksForYear = this.Db.weeks.Include(w => w.course).Where(w => w.year.value == year).OrderBy(x => x.seasonIndex).ToList();

            if (team == null)
            {
                // 404
            }

            // Hmmmm... so this got messy.  Needs to be somewhere else. Extension method on db context perhaps?
            // Also, need some better data structures for data to avoid bad performance in views.
            return View("Details", new ResultsTableViewModel
            {
                TeamsForYear = allTeamsForYear,
                WeeksForYear = weeksForYear,
                Team = team,
                PlayersForTeamForYear =
                    yearDatasForYearForTeam.Select(y => new PlayerResultsViewModel
                                                        {
                                                            Player = y.player,
                                                            YearData = y,
                                                            ResultsForYear = y.player.results
                                                                            .Where(r => r.year.value == year)
                                                                            .OrderBy(r => r.match.teammatchup.week.seasonIndex)
                                                        })
            });
        }
    }
}