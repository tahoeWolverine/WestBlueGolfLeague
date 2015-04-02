using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Http.Description;
using System.Web.Mvc;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Responses;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class TeamApiController : WestBlueDbApiController
    {
        [ResponseType(typeof(TeamProfileData))]
        public async Task<IHttpActionResult> GetProfileData(int id)
        {
            var t = this.Db.teams.FindAsync(id);

            var team = await t;

            if (team == null)
            {
                return NotFound();
            }

            int year = await this.ControllerHelper.GetSelectedYearAsync(this.Db); // DateTimeOffset.UtcNow.Year;

            // get leaderboards for team.
            var boardData = this.Db
                .leaderboarddatas
                .Include(x => x.leaderboard)
                .AsNoTracking()
                .Where(
                    x => x.teamId == team.id &&
                        (x.leaderboard.key == "team_avg_handicap" ||
                        x.leaderboard.key == "team_total_match_wins" ||
                        x.leaderboard.key == "team_ranking" ||
                        x.leaderboard.key == "team_win_loss_ratio" ||
                        x.leaderboard.key == "team_season_improvement") &&
                        x.year.value == year).ToListAsync();

            var results =
                this.Db
                    .results
                    .Include(x => x.match)
                    .Include(x => x.match.teammatchup.week)
                    .Include(x => x.match.results)
                    .Include(x => x.match.teammatchup.teams)
                    .Include(x => x.player)
                    .Where(
                        x =>
                            x.teamId == team.id &&
                            x.year.value == year
                    ).ToListAsync();
                   
            IEnumerable<leaderboarddata> leaderBoardDatas = await boardData;
            IEnumerable<result> resultsForYear = await results;

            var keyToBoardData = leaderBoardDatas.ToDictionary(x => x.leaderboard.key);

            // TODO: handle players that don't have leaderboard data yet.

            return Ok(
                new TeamProfileData ()
                { 
                    TeamName = team.teamName, 
                    TotalPoints = keyToBoardData["team_ranking"].formattedValue,
                    AvgHandicap = keyToBoardData["team_avg_handicap"].formattedValue, 
                    Improved = keyToBoardData["team_season_improvement"].formattedValue, 
                    TotalWins = keyToBoardData["team_total_match_wins"].formattedValue, 
                    WinLossRatio = keyToBoardData["team_win_loss_ratio"].formattedValue,
                    ResultsForYear = resultsForYear.Select(x => new TeamProfileResult(team, x))
                });
        }
    }
}