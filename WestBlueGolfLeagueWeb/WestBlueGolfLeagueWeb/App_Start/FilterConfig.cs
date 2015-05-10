using System.Web;
using System.Web.Mvc;
using WestBlueGolfLeagueWeb.Controllers.Filters;

namespace WestBlueGolfLeagueWeb
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new WestBlueHandleErrorAttribute());
        }
    }
}
