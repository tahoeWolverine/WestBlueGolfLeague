using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class PlayerController : Controller
    {
        private WestBlue db = new WestBlue();

        //
        // GET: /Player/
        public ActionResult Index()
        {
            var players = db.players.Where(p => p.validPlayer).ToList();

            return View(players);
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
