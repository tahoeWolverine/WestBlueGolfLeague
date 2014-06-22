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
    public class LeaderBoardApiController : ApiController
    {
        private WestBlue db = new WestBlue();

        // GET: api/LeaderBoardApi
        public IQueryable<leaderboarddata> Getleaderboarddatas()
        {
            return db.leaderboarddatas;
        }

        // GET: api/LeaderBoardApi/5
        [ResponseType(typeof(AvailableLeaderBoardsResponse))]
        public async Task<IHttpActionResult> GetAvailableLeaderBoards()
        {

            db.Configuration.ProxyCreationEnabled = false;

            var leaderboards = await db.leaderboards.AsNoTracking().ToListAsync();

            return Ok(new AvailableLeaderBoardsResponse { LeaderBoards = leaderboards });
        }

        [ResponseType(typeof(FullLeaderBoardForYearResponse))]
        public async Task<IHttpActionResult> GetLeaderBoard(string key)
        {
            // validate that we have a valid key.
            var leaderBoard = db.leaderboards.AsNoTracking().Where(x => x.key == key).ToListAsync();
            var leaderBoardDatas = db.leaderboarddatas.Include(x => x.player).Include(x => x.team).Where(x => x.leaderboard.key == key && x.year.value == DateTime.Now.Year).ToListAsync();

            var lbdResponse = await leaderBoard;

            if (lbdResponse.Count() != 1)
            {
                return NotFound();
            }

            var datas = await leaderBoardDatas;

            return Ok(new FullLeaderBoardForYearResponse { LeaderBoardData = datas.Select(x => new LeaderBoardDataWebResponse(x)) });
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool leaderboarddataExists(int id)
        {
            return db.leaderboarddatas.Count(e => e.id == id) > 0;
        }
    }
}