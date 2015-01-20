using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using WestBlueGolfLeagueWeb.Models;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class WestBlueDbApiController : ApiController
    {
        private WestBlue db = new WestBlue();
        private IdentityContext identityDb = IdentityContext.Create();

        public WestBlue Db { get { return this.db; } }
        public IdentityContext IdentityDb { get { return this.identityDb; } }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
                identityDb.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}