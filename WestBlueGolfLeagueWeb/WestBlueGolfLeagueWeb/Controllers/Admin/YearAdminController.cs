using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.Entity;
using WestBlueGolfLeagueWeb.Models.Entities;
using System.Threading.Tasks;

namespace WestBlueGolfLeagueWeb.Controllers
{
	[Authorize]
	public class YearAdminController : WestBlueDbMvcController
	{
		public YearAdminController()
			: base(true)
		{
		}

		// YearAdmin/
		public async Task<ActionResult> Index()
		{
			List<year> allYears = await this.Db.years.OrderBy(x => x.value).ToListAsync();
			return View(allYears);
		}
	}
}