using System.Web.Mvc;
using WestBlueGolfLeagueWeb.Models.Admin;

namespace WestBlueGolfLeagueWeb.Admin
{
    [Authorize(Roles = AdminRole.Admin.Name + "," + AdminRole.TeamCaptain.Name)]
    public class AdminController : Controller
    {
        // GET: Admin
        public ActionResult Index()
        {


            return View();
        }
    }
}