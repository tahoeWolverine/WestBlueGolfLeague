using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WestBlueGolfLeagueWeb.Models;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class TopScoreController : Controller
    {
        private WestBlueGolfDbContext context = new WestBlueGolfDbContext();

        //
        // GET: /TopScore/
        public ActionResult Index()
        {
            var players = context.Players;

            return View(players.ToList());
        }
	}
}