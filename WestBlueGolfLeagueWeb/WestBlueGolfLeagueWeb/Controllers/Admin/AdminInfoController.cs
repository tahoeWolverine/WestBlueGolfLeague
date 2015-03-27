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
            int currYear = this.ControllerHelper.GetSelectedYear();

            var teams = await this.Db.teamyeardatas.Include(x => x.team).Include(x => x.year).Where(x => x.year.value >= currYear - 2).ToListAsync();

            var sortedUniqueTeams = teams.OrderByDescending(x => x.year.value).GroupBy(x => x.team.id).Select(x => x.First()).Select(x => x.team).Where(x => x.validTeam);

            return Ok(new { teams = sortedUniqueTeams.Select(x => TeamResponse.From(x)) });
        }

        [HttpPost]
        public async Task<IHttpActionResult> SaveYear(CreateYearRequest request)
        {
            // validate everything, including the date.


            // create year
            var year = this.Db.years.Add(new year { value = 2015, isComplete = false });
            

            // get teams

            // create associated year datas on teams
            try
            {
                var selectedTeams = await this.Db.teams.Where(x => request.TeamIds.Contains(x.id)).ToListAsync();

                foreach (team t in selectedTeams)
                {
                    t.teamyeardata.Add(this.Db.teamyeardatas.Add(new teamyeardata { team = t, year = year }));
                }
                
                await this.Db.SaveChangesAsync();
            }
            catch (Exception e)
            {
                return this.InternalServerError(e);
            }

            // update players??

            // create schedule (weeks, team match ups, etc).

            return Ok();
        }
    }
}