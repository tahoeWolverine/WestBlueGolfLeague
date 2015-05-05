
using System.Linq;
using System.Data.Entity;
using System.Threading.Tasks;
using System.Web.Mvc;
using WestBlueGolfLeagueWeb.Controllers;
using WestBlueGolfLeagueWeb.Models.Admin;
using System;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Admin
{
    [Authorize(Roles = AdminRole.Admin.Name + "," + AdminRole.TeamCaptain.Name)]
    public class AdminController : WestBlueDbMvcController
    {
        public AdminController() : base(true) { }

        // GET: Admin
        public ActionResult Index()
        {
            return View();
        }

		public ActionResult AddPlayer(string result)
	    {
			if (string.Equals("success", result))
		    {
			    ViewBag.Message = "Player added successfully!";
		    }

			ViewBag.CurrentYear = this.CurrentYear;

			var teams =
				this.Db.teams.Where(x => x.teamyeardata.Any(y => y.year.value == this.CurrentYear)).OrderBy(x => x.teamName);

		    return View(new AddPlayerRequest { Teams = teams });
	    }

		[HttpPost]
		[ValidateAntiForgeryToken]
	    public async Task<ActionResult> AddPlayer(AddPlayerRequest addPlayerRequest)
	    {
			if (!ModelState.IsValid)
			{
				return View(addPlayerRequest);
			}

            var yearTask = this.Db.years.Where(x => x.value == this.CurrentYear).FirstOrDefaultAsync();
            var teamTask = this.Db.teams.Where(x => x.id == addPlayerRequest.TeamId).FirstOrDefaultAsync();

            var playerTask = this.Db.players.Include(x => x.playeryeardatas).Where(x => x.name.ToLower() == addPlayerRequest.PlayerName.ToLower()).FirstOrDefaultAsync();

            await Task.WhenAll(yearTask, teamTask, playerTask);

            player player = null;

            if (playerTask.Result != null)
            {
                player = playerTask.Result;

                // if the player already has a PYD for the current year, delete it.
                var currentYearPyd = player.playeryeardatas.FirstOrDefault(x => x.year.value == this.CurrentYear);

                player.currentHandicap = addPlayerRequest.Handicap;

                if (currentYearPyd != null) 
                {
                    this.Db.playeryeardatas.Remove(currentYearPyd);
                }
            }
            else
            {
                player = new player { validPlayer = true, name = addPlayerRequest.PlayerName, currentHandicap = addPlayerRequest.Handicap };
            }

            var newPyd = new playeryeardata
                                {
                                    isRookie = true,
                                    year = yearTask.Result,
                                    team = teamTask.Result,
                                    player = player,
                                    week0Score = addPlayerRequest.Handicap + 36,
                                    startingHandicap = addPlayerRequest.Handicap,
                                    finishingHandicap = addPlayerRequest.Handicap
                                };

            this.Db.playeryeardatas.Add(newPyd);

            await this.Db.SaveChangesAsync();

			return RedirectToAction("AddPlayer", new { result = "success" });
	    }
    }
}