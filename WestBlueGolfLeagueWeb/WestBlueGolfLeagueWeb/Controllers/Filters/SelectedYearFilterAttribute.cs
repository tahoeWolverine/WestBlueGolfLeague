using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;
using System.Data.Entity;
using System.Net.Http.Headers;
using System.Net.Http;


namespace WestBlueGolfLeagueWeb.Controllers
{
	public class SelectedYearFilterAttribute : ActionFilterAttribute
	{
        public async override Task OnActionExecutingAsync(HttpActionContext actionContext, CancellationToken cancellationToken)
		{
            var controller = actionContext.ControllerContext.Controller as WestBlueDbApiController;

            if (controller == null)
            {
                throw new Exception("Can only apply this attribute to WestBlueDbApiController.");
            }

            var allYears = await controller.Db.years.AsNoTracking().ToListAsync();
            int maxYear = allYears.Max(x => x.value);
            int minYear = allYears.Min(x => x.value);
            
            controller.CurrentYear = controller.SelectedYear = maxYear;

            var cookieHeaderVals = actionContext.Request.Headers.GetCookies("westBlueYear");

		    if (cookieHeaderVals == null || cookieHeaderVals.Count == 0)
		    {
                return;
		    }

            var westBlueCookieState = cookieHeaderVals.First().Cookies
                                    .FirstOrDefault(x => string.Equals(x.Name, "westBlueYear", StringComparison.OrdinalIgnoreCase));

            if (westBlueCookieState == null)
            {
                return;
            }

            int selectedYear = -1;

            // If the value is set but it is invalid, just continue.  
            // Note that we don't reset the cookie (unlike the MVC controller)
            // this is because the MVC controller will be hit first and do the reset.
            if (!Int32.TryParse(westBlueCookieState.Value, out selectedYear) || selectedYear < minYear || selectedYear > controller.CurrentYear)
            {
                return;
            }

            // Selected year is valid!
            controller.SelectedYear = selectedYear;
		}
	}
}