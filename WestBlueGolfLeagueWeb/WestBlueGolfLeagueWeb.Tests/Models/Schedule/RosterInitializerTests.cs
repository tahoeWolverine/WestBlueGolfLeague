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
				new TeamRoster(new team(), new string[]{ "test", "another player" })
			};

            var leaguePlayers = 
                new List<player> 
                { 
                    new player 
                    { 
                        name = "test", 
                        playeryeardatas = new List<playeryeardata> 
                                          { 
                                            new playeryeardata 
                                            { 
                                                year = new year { value = 2014 }, 
                                                finishingHandicap = 10, 
                                                startingHandicap = 7, 
                                                week0Score = 43 
                                            } 
                                          } 
                    } 
                };

			RosterInitializer ri = new RosterInitializer(teamRosters, leaguePlayers, new year { value = 2015 });

            Assert.IsTrue(ri.NewPlayerYearDatas.Count() == 1);
            Assert.IsTrue(ri.NewPlayers.Count() == 1);
            Assert.AreEqual("test", ri.NewPlayerYearDatas.First().player.name);
            Assert.IsTrue(ri.NewPlayerYearDatas.First().player.playeryeardatas.Any(x => x.year.value == 2015));

            var pyd = ri.NewPlayerYearDatas.First().player.playeryeardatas.First(x => x.year.value == 2015);
            Assert.IsTrue(pyd.week0Score == 46); // defined as finishing handicap from previous year + 36
            Assert.IsTrue(pyd.startingHandicap == 10);
		}
	}
}
