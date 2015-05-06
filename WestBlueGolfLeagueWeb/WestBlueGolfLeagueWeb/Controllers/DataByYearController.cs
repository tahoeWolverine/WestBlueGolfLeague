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
using WestBlueGolfLeagueWeb.Models.Responses.LeaderBoard;
using WestBlueGolfLeagueWeb.Models.Responses.API;
using WestBlueGolfLeagueWeb.Models.Responses.Player;
using WestBlueGolfLeagueWeb.Models.Responses.Team;
using WestBlueGolfLeagueWeb.Models.Responses.Schedule;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class DataByYearController : WestBlueDbApiController
    {
        // GET: api/DataByYear
        [ResponseType(typeof(DataByYear))]
        public IHttpActionResult GetDataForYear(int year)
        {
            if (year < 1999 || year > DateTimeOffset.UtcNow.Year)
            {
                return BadRequest("year not in valid range");
            }

            this.Db.Configuration.ProxyCreationEnabled = false;
            
            // TODO: Invalid players might need to be added to this (no shows, etc)
            var yearDataWithPlayerForYear = this.Db.playeryeardatas.Include(p => p.player).AsNoTracking().Where(x => x.year.value == year).ToList();

            var weeksForYear = this.Db.weeks.Where(w => w.year.value == year).Include(w => w.course).AsNoTracking().ToList();

            var teamsForYear = this.Db.teams.AsNoTracking().Where(x => x.playeryeardatas.Any(y => y.year.value == year)).ToList();
            var leaderboards = this.Db.leaderboards.AsNoTracking().ToList();
            var pairings = this.Db.pairings.AsNoTracking().ToList();
            var leaderBoardDataForYear = this.Db.leaderboarddatas.AsNoTracking().Where(x => x.year.value == year).ToList();
            var courses = weeksForYear.Select(w => w.course).GroupBy(c => c.id).Select(g => g.First());
            var teamMatchupsForYear = this.Db.teammatchups.Include(x => x.teams).Include(x => x.matches).Include("matches.results").Where(x => x.week.year.value == year).ToList();

            var dby = new DataByYear
            {
                PlayersForYear = yearDataWithPlayerForYear.Select(x => PlayerResponse.From(x)).ToList(),
                LeaderboardDataForYear = leaderBoardDataForYear.Select(x => LeaderBoardDataResponse.From(x)).ToList(),
                Leaderboards = leaderboards.Select(x => new LeaderBoardResponse(x)).ToList(),
                TeamsForYear = teamsForYear.Select(x => TeamResponse.From(x)).ToList(),
                TeamMatchups = teamMatchupsForYear.Select(x => TeamMatchupResponse.From(x)).ToList(),
                Courses = courses.Select(x => CourseResponse.From(x)).ToList(),
                Weeks = weeksForYear.Select(x => new WeekResponse(x)).ToList(),
                Pairings = pairings
            };

            return Ok(dby);
        }

        [ResponseType(typeof(AvailableYearsResponse))]
        public IHttpActionResult GetAvailableYears()
        {
            return Ok(new AvailableYearsResponse { AvailableYears = this.Db.years.ToList().Select(x => YearResponse.From(x)).ToList() });
        }
    }
}
