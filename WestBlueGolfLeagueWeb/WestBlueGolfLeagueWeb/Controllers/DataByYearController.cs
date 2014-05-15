using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Responses;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class DataByYearController : ApiController
    {
        private WestBlue db = new WestBlue();

        // GET: api/DataByYear
        [ResponseType(typeof(DataByYear))]
        public IHttpActionResult GetDataForYear(int year)
        {
            if (year < 1999 || year > DateTimeOffset.UtcNow.Year)
            {
                return BadRequest("year not in valid range");
            }

            db.Configuration.ProxyCreationEnabled = false;
            
            var playersForYear = db.players.AsNoTracking().Where(x => x.playeryeardatas.Any(y => y.year.value == year)).ToList();
            var teamsForYear = db.teams.AsNoTracking().Where(x => x.playeryeardatas.Any(y => y.year.value == year)).ToList();
            var leaderboards = db.leaderboards.AsNoTracking().ToList();
            var leaderBoardDataForYear = db.leaderboarddatas.AsNoTracking().Where(x => x.year.value == year).ToList();

            var dby = new DataByYear { PlayersForYear = playersForYear, LeaderboardDataForYear = leaderBoardDataForYear, Leaderboards = leaderboards, TeamsForYear = teamsForYear };

            return Ok(dby);
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
