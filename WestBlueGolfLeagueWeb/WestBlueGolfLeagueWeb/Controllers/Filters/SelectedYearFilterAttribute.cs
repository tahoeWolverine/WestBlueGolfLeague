using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;


namespace WestBlueGolfLeagueWeb.Controllers
{
	public class SelectedYearFilterAttribute : ActionFilterAttribute
	{
		public override void OnActionExecuting(ActionExecutingContext filterContext)
		{
			//var cookieVal = filterContext.HttpContext.Request.Cookies["westBlueYear"];

			//var controller = (WestBlueDbMvcController) filterContext.Controller.SelectedYear = cookieVal;
		}
	}
}