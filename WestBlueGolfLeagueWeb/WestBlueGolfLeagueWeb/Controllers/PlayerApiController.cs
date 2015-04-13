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
    public class PlayerApiController : WestBlueDbApiController
    {
        [ResponseType(typeof(PlayerProfileData))]
        public async Task<IHttpActionResult> GetProfileData(int id)
        {
            var p = this.Db.players.FindAsync(id);

            var player = await p;

            if (player == null)
            {
                return NotFound();
            }

            int year = await this.ControllerHelper.GetSelectedYearAsync(this.Db); // DateTimeOffset.UtcNow.Year;

            // get leaderboards for player.
            var boardData = this.Db
                .leaderboarddatas
                .Include(x => x.leaderboard)
                .AsNoTracking()
                .Where(
                    x => x.playerId == player.id &&
                        (x.leaderboard.key == "player_handicap" ||
                        x.leaderboard.key == "player_best_score" ||
                        x.leaderboard.key == "player_avg_points" ||
                        x.leaderboard.key == "player_net_best_score" ||
                        x.leaderboard.key == "player_season_improvement") &&
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
                            x.playerId == player.id &&
                            x.year.value == year
                    ).ToListAsync();
                   
            IEnumerable<leaderboarddata> leaderBoardDatas = await boardData;
            IEnumerable<result> resultsForYear = await results;

            var keyToBoardData = leaderBoardDatas.ToDictionary(x => x.leaderboard.key);

            return Ok(
                new PlayerProfileData 
                { 
                    PlayerName = player.name,
					AveragePoints = TryGetFormattedValue(keyToBoardData, "player_avg_points"), 
                    Handicap = TryGetFormattedValue(keyToBoardData, "player_handicap"), 
                    Improved = TryGetFormattedValue(keyToBoardData, "player_season_improvement"), 
                    LowNet = TryGetFormattedValue(keyToBoardData, "player_net_best_score"), 
                    LowScore = TryGetFormattedValue(keyToBoardData, "player_best_score"),
                    ResultsForYear = resultsForYear.Select(x => new PlayerProfileResult(player, x))
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