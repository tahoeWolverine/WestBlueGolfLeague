using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WestBlueGolfLeagueWeb.Controllers.Filters
{
    public class WestBlueHandleErrorAttribute : HandleErrorAttribute
    {
        private static readonly ILog Logger = LogManager.GetLogger(typeof(WestBlueHandleErrorAttribute));

        public override void OnException(ExceptionContext filterContext)
        {
            base.OnException(filterContext);

            if (filterContext != null && filterContext.Exception != null)
            {
                Logger.Error("Exception executing controller action", filterContext.Exception);
            }
        }
    }
}