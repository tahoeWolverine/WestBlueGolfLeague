using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class WestBlueDbMvcController : Controller
    {
		private WestBlue db = null;
        private int minYear = -1;

		protected WestBlueDbMvcController(bool needWriteAccess = false)
		{
			this.db = new WestBlue(needWriteAccess);
		}

		public WestBlue Db { get { return this.db; } }

		public int SelectedYear { get; private set; }

        public int CurrentYear { get; private set; }

	    protected override void OnActionExecuting(ActionExecutingContext filterContext)
	    {
            var allYears = this.db.years.ToList();

            // populate required fields, initializing selected year to the current year.
            this.CurrentYear = this.SelectedYear = allYears.Max(x => x.value);
            this.minYear = allYears.Min(x => x.value);

			var cookieVal = filterContext.HttpContext.Request.Cookies["westBlueYear"];

		    if (cookieVal == null || string.IsNullOrEmpty(cookieVal.Value))
		    {
                return;
		    }

            int selectedYear = -1;

            // If the value is set but it is invalid, clear it out.
            if (!Int32.TryParse(cookieVal.Value, out selectedYear) || selectedYear < minYear || selectedYear > this.CurrentYear)
            {
                var westBlueYearCookie = new HttpCookie("westBlueYear");
                westBlueYearCookie.Expires = DateTime.UtcNow.AddDays(-2);
                filterContext.HttpContext.Response.Cookies.Add(westBlueYearCookie);
                return;
            }

            // Selected year is valid!
            this.SelectedYear = selectedYear;
	    }

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