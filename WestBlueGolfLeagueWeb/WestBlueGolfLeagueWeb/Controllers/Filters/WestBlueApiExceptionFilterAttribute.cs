using log4net;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http.Filters;

namespace WestBlueGolfLeagueWeb.Controllers.Filters
{
    public class WestBlueApiExceptionFilterAttribute : ExceptionFilterAttribute
    {
        private static readonly ILog Logger = LogManager.GetLogger(typeof(WestBlueApiExceptionFilterAttribute));

        public override void OnException(HttpActionExecutedContext actionExecutedContext)
        {
            if (actionExecutedContext.Exception != null)
            {
                Logger.Error("Global API exception filter", actionExecutedContext.Exception);
            }
        }
    }
}