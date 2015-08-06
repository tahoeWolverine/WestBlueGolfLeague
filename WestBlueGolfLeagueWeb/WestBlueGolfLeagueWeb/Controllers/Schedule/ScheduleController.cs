using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;
using System.Data.Entity;
using WestBlueGolfLeagueWeb.Models.Responses;
using WestBlueGolfLeagueWeb.Models.Responses.Schedule;
using WestBlueGolfLeagueWeb.Models.Extensions;

namespace WestBlueGolfLeagueWeb.Controllers.Schedule
{
    public class ScheduleController : WestBlueDbApiController
    {
        [HttpGet]
        public async Task<IHttpActionResult> Index()
        {
            var currentYear = this.CurrentYear;

            // populated weeks
            var weeks = await this.Db.GetSchedule(currentYear);

            return Ok(new ScheduleResponse { Weeks = weeks.Select(x => new ScheduleWeek(x)) });
        }
    }
}