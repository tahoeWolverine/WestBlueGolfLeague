using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using WestBlueGolfLeagueWeb.Models.Admin;
using System.Data.Entity;
using WestBlueGolfLeagueWeb.Models.Responses;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Requests.Admin;
using WestBlueGolfLeagueWeb.Models.Schedule;

namespace WestBlueGolfLeagueWeb.Controllers.Admin
{
    [Authorize(Roles = AdminRole.Admin.Name)]
    public class AdminInfoController : WestBlueDbApiController
    {
        public AdminInfoController()
            : base(true)
        {

        }

        [HttpGet]
        public async Task<IHttpActionResult> AdminInfo()
        {
            var years = await this.Db.years.OrderBy(x => x.value).ToListAsync();

            bool newYearAvailable = false;
            int yearToCreate = DateTimeOffset.UtcNow.Year;

            if (!years.Any(x => x.value == yearToCreate)) 
            {
                newYearAvailable = true;
            }

            return Ok(new { newYearAvailable = newYearAvailable, yearToCreate = yearToCreate });
        }

        [HttpGet]
        public async Task<IHttpActionResult> YearWizardInfo()
        {
            int currYear = await this.ControllerHelper.GetSelectedYearAsync(this.Db);

            var teams = await this.Db.teamyeardatas.Include(x => x.team).Include(x => x.year).Where(x => x.year.value >= currYear - 2).ToListAsync();

            var sortedUniqueTeams = teams.OrderByDescending(x => x.year.value).GroupBy(x => x.team.id).Select(x => x.First()).Select(x => x.team).Where(x => x.validTeam);

            return Ok(new { teams = sortedUniqueTeams.Select(x => TeamResponse.From(x)) });
        }

        [HttpPost]
        public async Task<IHttpActionResult> SaveYear(CreateYearRequest request)
        {
            // TODO: validate everything, including the date.
                        
            try
            {
                // get teams
                var selectedTeams = this.Db.teams.Where(x => request.TeamIds.Contains(x.id)).ToListAsync();

                // get possible pairings
                var pairings = this.Db.pairings.ToListAsync();

                // TODO: use real courses
                var courses = this.Db.courses.ToListAsync();

                await Task.WhenAll(selectedTeams, pairings, courses);

                // update players??

                // create schedule (weeks, team match ups, etc).
                GolfYear golfYear = new GolfYear(selectedTeams.Result, request.WeekDate, request.NumberOfWeeks, pairings.Result, courses.Result);

                await golfYear.PersistScheduleAsync(this.Db);
            }
            catch (Exception e)
            {
                return this.InternalServerError(e);
            }

            return Ok();
        }
    }
}