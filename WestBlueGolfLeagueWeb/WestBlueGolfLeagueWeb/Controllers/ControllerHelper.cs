using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;
using System.Data.Entity;
using System.Threading.Tasks;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class ControllerHelper
    {
        /// <summary>
        /// Get the SELECT year (the year that the user selected).  This could be any 
        /// valid year of the league.
        /// 
        /// Currently hard coded until it is actually implemented.
        /// </summary>
        /// <returns></returns>
        public int GetSelectedYear()
        {
            return 2014;
        }

        /// <summary>
        /// Gets the 'current year' of the league.  This is always the latest
        /// year that is ACTIVE.  Eg if the most recent year in the DB is 2014 but
        /// it is 2015, then 2014 will be returned.  If the latest year in the
        /// DB is 2015, then 2015 will be returned.
        /// </summary>
        /// <param name="db"></param>
        /// <returns></returns>
        public async Task<int> GetCurrentYear(WestBlue db)
        {
            return (await db.years.OrderByDescending(x => x.value).Take(1).ToListAsync()).First().value;
        }
    }
}