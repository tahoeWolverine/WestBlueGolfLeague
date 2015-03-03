using System.Web.Mvc;

namespace WestBlueGolfLeagueWeb.Admin
{
    [Authorize]
    public class AdminController : Controller
    {
        // GET: Admin
        public ActionResult Index()
        {
            return View();
        }
    }
}