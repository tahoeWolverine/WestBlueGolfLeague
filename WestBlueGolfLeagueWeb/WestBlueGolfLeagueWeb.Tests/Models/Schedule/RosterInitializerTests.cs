using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Schedule;

namespace WestBlueGolfLeagueWeb.Tests.Models.Schedule
{
	[TestClass]
	public class RosterInitializerTests
	{
		

		[TestMethod]
		public void RosterInitializerIntializesRoster()
		{
			var teamRosters = new List<TeamRoster>
			{
				new TeamRoster(new team(), new string[]{ "test" })
			};

			var leaguePlayers = new List<player>();

			RosterInitializer ri = new RosterInitializer(teamRosters, leaguePlayers);
		}
	}
}
