using System.Data.Entity;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Mvc;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.ViewModels;

namespace WestBlueGolfLeagueWeb.Controllers
{
    [AllowAnonymous]
    public class HomeController : WestBlueDbMvcController
    {
        public async Task<ViewResult> Index()
        {
            int selectedYear = this.SelectedYear;
            
            // Hack to order and rank teams until leaderboards is working
            //var rankingValuesForYear = this.Db.leaderboarddatas.Where(x => x.year.value == selectedYear && x.leaderboard.key == "team_ranking").OrderBy(x => x.rank).ToList();
            var rankingValuesForYear = this.Db.leaderboarddatas.Where(x => x.year.value == selectedYear && x.leaderboard.key == "team_ranking").OrderByDescending(x => x.value).ToList();

            // Re-rank
            for (int i = 0; i < rankingValuesForYear.Count(); i++)
            {
                leaderboarddata lbd = rankingValuesForYear.ElementAt(i);
                lbd.rank = i + 1;
            }

            var year = this.Db.years.Where(x => x.value == selectedYear).ToList().First();

            var latestNote = await this.Db.notes.OrderByDescending(x => x.date).FirstOrDefaultAsync();

            return View(new HomeViewModel { Information = latestNote, TeamRankingDataForYear = rankingValuesForYear, ScheduleYear = year, SelectedYear = selectedYear });
        }

        [ChildActionOnly]
        public async Task<ActionResult> YearSelector()
        {
            var years = await this.Db.years.OrderByDescending(x => x.value).ToListAsync();

            return PartialView(new YearSelectorViewModel { SelectedYear = this.SelectedYear, Years = years });
        }

        public ActionResult AngularMain()
        {
            return View("AngularView");
        }
    }
}