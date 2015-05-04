using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using WestBlueGolfLeagueWeb.Models;
using WestBlueGolfLeagueWeb.Models.Entities;
using System.Net.Http;
using Microsoft.AspNet.Identity.Owin;

namespace WestBlueGolfLeagueWeb.Controllers
{
    [SelectedYearFilterAttribute]
    public class WestBlueDbApiController : ApiController
    {
        private WestBlue db = null;
        private IdentityContext identityDb = IdentityContext.Create();

        public WestBlue Db { get { return this.db; } }
        public IdentityContext IdentityDb { get { return this.identityDb; } }

        // These have public setters because the filter needs to set them.
        public int CurrentYear { get; set; }
        public int SelectedYear { get; set; }

        public WestBlueDbApiController(bool needsWriteAccess = false)
        {
            this.db = new WestBlue(needsWriteAccess);
	        //this.db.Database.Log = s => System.Diagnostics.Debug.WriteLine(s);
        }
                
        public ApplicationRoleManager RoleManager
        {
            get
            {
                return this.Request.GetOwinContext().Get<ApplicationRoleManager>();
            }
        }

        public ApplicationUserManager UserManager
        {
            get
            {
                return this.Request.GetOwinContext().GetUserManager<ApplicationUserManager>();
            }
        }

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