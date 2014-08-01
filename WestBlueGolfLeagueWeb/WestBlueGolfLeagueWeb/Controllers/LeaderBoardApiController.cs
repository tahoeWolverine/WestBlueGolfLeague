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
            // validate that we have a valid key.
            var leaderBoard = this.Db.leaderboards.AsNoTracking().Where(x => x.key == key).ToListAsync();
            var leaderBoardDatas = this.Db.leaderboarddatas.Include(x => x.player).Include(x => x.team).Where(x => x.leaderboard.key == key && x.year.value == DateTime.Now.Year).ToListAsync();

            var lbdResponse = await leaderBoard;

            if (lbdResponse.Count() != 1)
            {
                return NotFound();
            }

            var datas = await leaderBoardDatas;

            return Ok(new FullLeaderBoardForYearResponse { LeaderBoardData = datas.Select(x => new LeaderBoardDataWebResponse(x)) });
        }

        private bool leaderboarddataExists(int id)
        {
            return this.Db.leaderboarddatas.Count(e => e.id == id) > 0;
        }
    }
}