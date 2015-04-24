
using System.Linq;
using System.Data.Entity;
using System.Threading.Tasks;
using System.Web.Mvc;
using WestBlueGolfLeagueWeb.Controllers;
using WestBlueGolfLeagueWeb.Models.Admin;

namespace WestBlueGolfLeagueWeb.Admin
{
    [Authorize(Roles = AdminRole.Admin.Name + "," + AdminRole.TeamCaptain.Name)]
    public class AdminController : WestBlueDbMvcController
    {
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
	    public ActionResult AddPlayer(AddPlayerRequest addPlayerRequest)
	    {
			if (!ModelState.IsValid)
			{
				return View(addPlayerRequest);
			}

			// TODO: actually save the player here.

			return RedirectToAction("AddPlayer", new { result = "success" });
	    }
    }
}