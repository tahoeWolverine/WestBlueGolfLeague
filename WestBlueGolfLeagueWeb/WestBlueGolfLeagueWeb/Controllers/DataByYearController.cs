using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Responses;
using System.Data.Entity;

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
            
            // TODO: Invalid players might need to be added to this (no shows, etc)
            var yearDataWithPlayerForYear = db.playeryeardatas.Include(p => p.player).AsNoTracking().Where(x => x.year.value == year).ToList();

            var weeksForYear = db.weeks.Where(w => w.year.value == year).Include(w => w.course).AsNoTracking().ToList();

            var teamsForYear = db.teams.AsNoTracking().Where(x => x.playeryeardatas.Any(y => y.year.value == year)).ToList();
            var leaderboards = db.leaderboards.AsNoTracking().ToList();
            var leaderBoardDataForYear = db.leaderboarddatas.AsNoTracking().Where(x => x.year.value == year).ToList();
            var courses = weeksForYear.Select(w => w.course).GroupBy(c => c.id).Select(g => g.First());
            var teamMatchupsForYear = db.teammatchups.Include(x => x.matchups).Include("matchups.results").Where(x => x.week.year.value == year).ToList();

            var dby = new DataByYear
            {
                PlayersForYear = yearDataWithPlayerForYear.Select(x => PlayerResponse.From(x)).ToList(),
                LeaderboardDataForYear = leaderBoardDataForYear.Select(x => LeaderboardDataResponse.From(x)).ToList(),
                Leaderboards = leaderboards,
                TeamsForYear = teamsForYear.Select(x => TeamResponse.From(x)).ToList(),
                TeamMatchups = teamMatchupsForYear.Select(x => TeamMatchupResponse.From(x)).ToList(),
                Courses = courses.Select(x => CourseResponse.From(x)).ToList(),
                Weeks = weeksForYear.Select(x => WeekResponse.From(x)).ToList()
            };

            return Ok(dby);
        }

        [ResponseType(typeof(List<YearResponse>))]
        public IHttpActionResult GetAvailableYears()
        {
            return Ok(db.years.ToList().Select(x => YearResponse.From(x)));
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
