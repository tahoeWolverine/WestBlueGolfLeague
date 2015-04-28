using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;
using System.Web.Http;
using System.Threading.Tasks;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Responses;


namespace WestBlueGolfLeagueWeb.Controllers.Admin
{
    public class ScoreEntryController : WestBlueDbApiController
    {
        /// <summary>
        /// Get the overall schedule data
        /// </summary>
        /// <returns></returns>
        public async Task<IHttpActionResult> GetWeeks()
        {
            var weeks = await this.Db.GetWeeksWithMatchUpsForYearAsync(this.CurrentYear);

            // TODO: get correct current week.
            return Ok(new ScheduleResponse { Weeks = weeks.Where(x => x.teammatchups.Count > 0).Select(x => new WeekWebResponse(x)) });
        }

        /// <summary>
        /// Get data for a specific week
        /// </summary>
        /// <returns></returns>
        public async Task<IHttpActionResult> GetMatchup(int weekId, int matchupId)
        {
            var matchup = await this.Db.teammatchups.FirstOrDefaultAsync(x => x.week.id == weekId && x.week.year.value == this.CurrentYear && x.id == matchupId);

            if (matchup == null)
            {
                return NotFound();
            }

            // TODO: include matches in this response.
            //var matchUps = week.teammatchups;

            return Ok(new { teamMatchup = new TeamMatchupWebResponse(matchup) });
        }
    }
}