using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WestBlueGolfLeagueWeb.Models;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class TopScoreController : Controller
    {
        private WestBlue context = new WestBlue();

        //
        // GET: /TopScore/
        public ActionResult Index()
        {
            var players = context.players.Where(p => p.validPlayer);

            return View(players.ToList());
        }
	}
}