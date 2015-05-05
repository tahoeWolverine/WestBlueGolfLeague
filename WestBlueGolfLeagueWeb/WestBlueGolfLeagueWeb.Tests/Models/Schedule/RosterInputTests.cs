using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Schedule;

namespace WestBlueGolfLeagueWeb.Tests.Models.Schedule
{
	[TestClass]
	public class RosterInputTests
	{
		[TestMethod]
		[DeploymentItem(@"TestData\rosterTestData.txt", "TestData")]
		public void RosterImportWorks()
		{
			var rosterTestDataFile = Directory.GetCurrentDirectory() + @"\TestData\rosterTestData.txt";

			using (var reader = new RosterReader(new FileStream(rosterTestDataFile, FileMode.Open)))
			{
                var results = reader.GetRoster(new List<team> { new team { teamName = "Pinseekers" }, new team { teamName = "Eagles" }, new team { teamName = "Missing Links" } });

				Assert.AreEqual(3, results.Count());
                Assert.AreEqual("Missing Links", results.First().Team.teamName);
				Assert.AreEqual(3, results.First().GetPlayers().Count());
			}
		}
	}
}
