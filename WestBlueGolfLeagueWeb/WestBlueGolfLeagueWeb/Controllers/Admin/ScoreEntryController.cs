using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;
using System.Web.Http;
using System.Threading.Tasks;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Responses;
using WestBlueGolfLeagueWeb.Models.Responses.Admin;


namespace WestBlueGolfLeagueWeb.Controllers.Admin
{
    public class ScoreEntryController : WestBlueDbApiController
    {
        /// <summary>
        /// Get the overall schedule data
        /// </summary>
        /// <returns></returns>
        public async Task<IHttpActionResult> GetScoreEntryData()
        {
            var weeks = (await this.Db.GetWeeksWithMatchUpsForYearAsync(this.CurrentYear)).ToList();

	        var now = DateTimeOffset.UtcNow;

	        var currentWeek = weeks.FirstOrDefault(x => now < new DateTimeOffset(x.date)) ?? weeks.LastOrDefault();

	        Dictionary<int, IEnumerable<player>> lookup =
		        this.Db.GetPlayersWithTeamsForYear(this.CurrentYear)
			        .ToLookup(x => x.Item2.id, x => x.Item1)
			        .ToDictionary(x => x.Key, x => (IEnumerable<player>)x);
			
	        return Ok(new ScoreEntryDataResponse(currentWeek, weeks, lookup, this.Db.GetTeamsForYear(this.CurrentYear)));
        }

        /// <summary>
        /// Get data for a specific week
        /// </summary>
        /// <returns></returns>
        public async Task<IHttpActionResult> GetMatchup(int weekId, int matchupId)
        {
            var matchup = await this.Db.teammatchups
                            .Include(x => x.matches)
                            .Include("matches.results")
                            .Include("matches.results.player")
                            .AsNoTracking()
                            .FirstOrDefaultAsync(x => x.week.id == weekId && x.week.year.value == this.CurrentYear && x.id == matchupId);

            if (matchup == null)
            {
                return NotFound();
            }

            return Ok(new { teamMatchup = new TeamMatchupWithMatches(matchup) });
        }
    }
}