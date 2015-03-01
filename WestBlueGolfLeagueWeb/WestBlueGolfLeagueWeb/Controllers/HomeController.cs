using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.Entity;
using WestBlueGolfLeagueWeb.Models.ViewModels;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class HomeController : WestBlueDbMvcController
    {
        public ActionResult Index()
        {
            int selectedYear = 2014;
            
            var rankingValuesForYear = this.Db.leaderboarddatas.Where(x => x.year.value == selectedYear && x.leaderboard.key == "team_ranking").OrderBy(x => x.rank).ToList();
            var year = this.Db.years.Where(x => x.value == selectedYear).ToList().First();

            return View(new HomeViewModel { TeamRankingDataForYear = rankingValuesForYear, ScheduleYear = year, SelectedYear = selectedYear });
        }

        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}