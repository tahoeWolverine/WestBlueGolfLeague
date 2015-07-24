using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;
using System.Data.Entity;
using WestBlueGolfLeagueWeb.Models.Responses;
using WestBlueGolfLeagueWeb.Models.Responses.Schedule;

namespace WestBlueGolfLeagueWeb.Controllers.Schedule
{
    public class ScheduleController : WestBlueDbApiController
    {
        [HttpGet]
        public async Task<IHttpActionResult> Index()
        {
            var currentYear = this.CurrentYear;

            // populated weeks
            var weeks = await this.Db.weeks
                .Include(x => x.teammatchups)
                .Include("teammatchups.teams")
                .Include(x => x.pairing)
                .Include(x => x.course)
                .Where(x => x.year.value == currentYear)
                .OrderBy(x => x.date).ToListAsync();

            var latestNote = await this.Db.notes.OrderByDescending(x => x.date).FirstOrDefaultAsync();

            // TODO: add note as well as other home page info here?? Maybe split this out in to service or something and
            // have separate infos for home page
            return Ok(new ScheduleResponse { Weeks = weeks.Select(x => new ScheduleWeek(x)) });
        }
    }
}