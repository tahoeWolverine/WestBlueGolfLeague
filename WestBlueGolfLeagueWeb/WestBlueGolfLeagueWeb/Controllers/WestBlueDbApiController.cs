using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class WestBlueDbApiController : ApiController
    {
        private WestBlue db = new WestBlue();

        public WestBlue Db { get { return this.db; } }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}