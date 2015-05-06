using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Responses;
using WestBlueGolfLeagueWeb.Models.Responses.LeaderBoard;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class LeaderBoardApiController : WestBlueDbApiController
    {
        // GET: api/LeaderBoardApi
        public IQueryable<leaderboarddata> Getleaderboarddatas()
        {
            return this.Db.leaderboarddatas;
        }

        // GET: api/LeaderBoardApi/5
        [ResponseType(typeof(AvailableLeaderBoardsResponse))]
        public async Task<IHttpActionResult> GetAvailableLeaderBoards()
        {
            this.Db.Configuration.ProxyCreationEnabled = false;

            var leaderboards = await this.Db.leaderboards.AsNoTracking().ToListAsync();

            return Ok(new AvailableLeaderBoardsResponse { LeaderBoards = leaderboards });
        }

        [ResponseType(typeof(FullLeaderBoardForYearResponse))]
        public async Task<IHttpActionResult> GetLeaderBoard(string key)
        {
            int year = this.SelectedYear;

            // validate that we have a valid key.
            var leaderBoard = await this.Db.leaderboards.Where(x => x.key == key).FirstOrDefaultAsync();
            var leaderBoardDatas = await this.Db.leaderboarddatas.Include(x => x.player).Include(x => x.team).Where(x => x.leaderboard.key == key && x.year.value == year).ToListAsync();

            if (leaderBoard == null)
            {
                return NotFound();
            }

            return Ok(new FullLeaderBoardForYearResponse { LeaderBoardData = leaderBoardDatas.Select(x => new LeaderBoardDataWebResponse(x)), LeaderBoard = new LeaderBoardResponse(leaderBoard) });
        }
    }
}