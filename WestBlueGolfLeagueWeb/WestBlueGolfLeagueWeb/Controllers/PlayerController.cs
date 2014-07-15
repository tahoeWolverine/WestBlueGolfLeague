using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WestBlueGolfLeagueWeb.Models.Entities;
using System.Data.Entity;
using WestBlueGolfLeagueWeb.Models.Responses;
using WestBlueGolfLeagueWeb.Models.ViewModels;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class PlayerController : Controller
    {
        private WestBlue db = new WestBlue();

        //
        // GET: /Player/
        public ActionResult Index()
        {
            var playersForYear = db.GetPlayersForYear();

            return View(new PlayerListViewModel { PlayersForYear = playersForYear.Select(x => PlayerResponse.From(x)) });
        }

        //
        // GET: /Player/Details/5
        public ActionResult Details(int id)
        {
            var player = db.players.Where(x => x.id == id).FirstOrDefault();

            if (player == null)
            {
                // do 404 here
            }

            return View(player);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}
