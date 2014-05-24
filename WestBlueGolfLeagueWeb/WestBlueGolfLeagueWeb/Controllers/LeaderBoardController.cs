using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class LeaderBoardController : Controller
    {
        // GET: LeaderBoard
        public ActionResult Index()
        {
            return View();
        }
    }
}