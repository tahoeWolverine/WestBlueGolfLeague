using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using WestBlueGolfLeagueWeb.Models.Extensions;
using System.Data.Entity;
using WestBlueGolfLeagueWeb.Models.Responses.Schedule;
using WestBlueGolfLeagueWeb.Models.Responses.LeaderBoard;
using WestBlueGolfLeagueWeb.Models.Playoffs;
using WestBlueGolfLeagueWeb.Models.Responses.Team;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class HomeApiController : WestBlueDbApiController
    {
        [HttpGet]
        public async Task<IHttpActionResult> Index()
        {
            var selectedYear = this.SelectedYear;

            // populated weeks
            var weeks = await this.Db.GetSchedule(selectedYear, false);

            var latestNote = await this.Db.notes.OrderByDescending(x => x.date).FirstOrDefaultAsync();

            // validate that we have a valid key.
            var leaderBoard = await this.Db.leaderboards.Where(x => x.key == "team_ranking").FirstOrDefaultAsync();
            var leaderBoardDatas = await this.Db.leaderboarddatas.Include(x => x.team).Where(x => x.leaderboard.key == "team_ranking" && x.year.value == selectedYear).OrderBy(x => x.rank).ToListAsync();

            var teamStandingData = new FullLeaderBoardForYearResponse { LeaderBoardData = leaderBoardDatas.Select(x => new LeaderBoardDataWebResponse(x)), LeaderBoard = new LeaderBoardResponse(leaderBoard, false) };

            var playoffPredictorResults = new PlayoffPredictor(leaderBoardDatas, weeks).PredictPlayoffMatchups();

            var playoffLookup = playoffPredictorResults.ToDictionary(x => x.Week.id, x => x);

            return Ok(
                new 
                { 
                    leagueNote = latestNote, 
                    selectedYear = selectedYear, 
                    standings = teamStandingData, 
                    schedule = new ScheduleResponse { Weeks = weeks.Select(x => {

                        GroupedPlayoffMatchup matchup = null;

                        playoffLookup.TryGetValue(x.id, out matchup);

                        return new ScheduleWeek(x, matchup, false);
                    })}
                });
        }

        public async void NewHomeEndpoint()
        {
            
        }
    }
}
