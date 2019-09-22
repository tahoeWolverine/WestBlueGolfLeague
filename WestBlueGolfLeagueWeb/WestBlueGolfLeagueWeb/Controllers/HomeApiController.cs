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
            var weeksTask = this.Db.GetSchedule(selectedYear, true);

            var latestNoteTask = this.Db.notes.OrderByDescending(x => x.date).FirstOrDefaultAsync();

            var playersForYearTask = this.Db.GetPlayersForYear(selectedYear);

            // validate that we have a valid key.
            var leaderBoardTask = this.Db.leaderboards.Where(x => x.key == "team_ranking").FirstOrDefaultAsync();
            var leaderBoardDataTask = this.Db.leaderboarddatas.Include(x => x.team).Where(x => x.leaderboard.key == "team_ranking" && x.year.value == selectedYear).OrderBy(x => x.rank).ToListAsync();

            var firstHalfLeaderBoardTask = this.Db.leaderboards.Where(x => x.key == "team_ranking_1st").FirstOrDefaultAsync();
            var firstHalfLeaderBoardDataTask = this.Db.leaderboarddatas.Include(x => x.team).Where(x => x.leaderboard.key == "team_ranking_1st" && x.year.value == selectedYear).OrderBy(x => x.rank).ToListAsync();

            var secondHalfLeaderBoardTask = this.Db.leaderboards.Where(x => x.key == "team_ranking_2nd").FirstOrDefaultAsync();
            var secondHalfLeaderBoardDataTask = this.Db.leaderboarddatas.Include(x => x.team).Where(x => x.leaderboard.key == "team_ranking_2nd" && x.year.value == selectedYear).OrderBy(x => x.rank).ToListAsync();

            var weeks = await weeksTask;
            var leaderBoardDatas = await leaderBoardDataTask;
            var firstHalfLeaderBoardDatas = await firstHalfLeaderBoardDataTask;
            var secondHalfLeaderBoardDatas = await secondHalfLeaderBoardDataTask;

            var teamStandingData = new FullLeaderBoardForYearResponse { LeaderBoardData = leaderBoardDatas.Select(x => new LeaderBoardDataWebResponse(x)), LeaderBoard = new LeaderBoardResponse(await leaderBoardTask, false) };
            var firstHalfData = new FullLeaderBoardForYearResponse { LeaderBoardData = firstHalfLeaderBoardDatas.Select(x => new LeaderBoardDataWebResponse(x)), LeaderBoard = new LeaderBoardResponse(await firstHalfLeaderBoardTask, false) };
            var secondHalfData = new FullLeaderBoardForYearResponse { LeaderBoardData = secondHalfLeaderBoardDatas.Select(x => new LeaderBoardDataWebResponse(x)), LeaderBoard = new LeaderBoardResponse(await secondHalfLeaderBoardTask, false) };

            var playoffPredictorResults = new PlayoffPredictor(leaderBoardDatas, firstHalfLeaderBoardDatas, secondHalfLeaderBoardDatas, weeks).PredictPlayoffMatchups();

            var playoffLookup = playoffPredictorResults.ToDictionary(x => x.Week.id, x => x);

            return Ok(
                new 
                { 
                    leagueNote = await latestNoteTask,
                    selectedYear = selectedYear,
                    standings = teamStandingData,
                    standingsFirstHalf = firstHalfData,
                    standingsSecondHalf = secondHalfData,
                    players = (await playersForYearTask).Select(x => new { id = x.id, name = x.name }),
                    schedule = new ScheduleResponse { Weeks = weeks.Select(x => {

                        GroupedPlayoffMatchup matchup = null;

                        playoffLookup.TryGetValue(x.id, out matchup);

                        return new ScheduleWeek(x, matchup, true);
                    })}
                });
        }

        public async void NewHomeEndpoint()
        {
            
        }
    }
}
