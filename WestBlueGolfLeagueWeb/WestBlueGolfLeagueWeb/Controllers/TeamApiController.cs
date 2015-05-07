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
using WestBlueGolfLeagueWeb.Models.Responses.Team;

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

            int year = this.SelectedYear;

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

            var teamMatchups =
                this.Db
                    .teammatchups
                    .Include(x => x.matches)
                    .Include(x => x.starttime)
                    .Include(x => x.week)
                    .Include(x => x.teams)
                    .Where(
                        x =>
                            x.teams.Any(y => y.id == team.id) &&
                            x.week.year.value == year
                    ).ToListAsync();
                   
            IEnumerable<leaderboarddata> leaderBoardDatas = await boardData;
            IEnumerable<result> resultsForYear = await results;
            IEnumerable<teammatchup> teamMatcupsForYear = await teamMatchups;

            var keyToBoardData = leaderBoardDatas.ToDictionary(x => x.leaderboard.key);

            // TODO: handle teams that don't have leaderboard data yet.

            return Ok(
                new TeamProfileData ()
                { 
                    TeamName = team.teamName,
					TotalPoints = TryGetFormattedValue(keyToBoardData, "team_ranking"),
                    AvgHandicap = TryGetFormattedValue(keyToBoardData, "team_avg_handicap"), 
                    Improved = TryGetFormattedValue(keyToBoardData, "team_season_improvement"), 
                    TotalWins = TryGetFormattedValue(keyToBoardData, "team_total_match_wins"), 
                    WinLossRatio = TryGetFormattedValue(keyToBoardData, "team_win_loss_ratio"),
                    ResultsForYear = resultsForYear.Select(x => new TeamProfileResult(team, x)),
                    CompleteResultsForYear = resultsForYear.Where(x => x.match.teammatchup.matchComplete).Select(x => new TeamProfileResult(team, x)),
                    TeamMatchupsForYear = teamMatcupsForYear.Select(x => new TeamProfileResult(team, x)),
                    CompleteMatchups = teamMatcupsForYear.Where(x => x.matchComplete).Select(x => new TeamProfileResult(team, x)),
                    IncompleteMatchups = teamMatcupsForYear.Where(x => x.matchComplete == false).Select(x => new TeamProfileResult(team, x))
                });
        }

	    private string TryGetFormattedValue(Dictionary<string, leaderboarddata> dictionary, string leaderboardName)
	    {
		    leaderboarddata leaderboarddata = null;

		    if (dictionary.TryGetValue(leaderboardName, out leaderboarddata))
		    {
			    return leaderboarddata.formattedValue;
		    }

		    return string.Empty;
	    }
    }
}