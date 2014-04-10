using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using Should;
using Should.Fluent;
using System.Linq;
using System.Collections.Generic;
using AccessExport;

namespace DataModelTests
{
    [TestClass]
    public class HandicapTests : DataModelTestBase
    {
        private IEnumerable<YearData> bushwoods2013Yd;
        private IEnumerable<YearData> kraftDinner2012Yd;
        private IEnumerable<YearData> swingDoctors2011Yd;

        [TestInitialize()]
        public void Initialize()
        {
            {
                var bushwoodsFinest = DataModel.Teams.First(x => string.Equals(x.Name, "Bushwoods Finest", StringComparison.OrdinalIgnoreCase));
                bushwoods2013Yd = DataModel.YearDatas.Where(x => x.Year.Value == 2013 && x.Player.Team.Id == bushwoodsFinest.Id);
            }

            {
                var kraftDinner = DataModel.Teams.First(x => string.Equals(x.Name, "Kraft Dinner", StringComparison.OrdinalIgnoreCase));
                kraftDinner2012Yd = DataModel.YearDatas.Where(x => x.Year.Value == 2012 && x.Player.Team.Id == kraftDinner.Id);
            }

            {
                var swingDoctors = DataModel.Teams.First(x => string.Equals(x.Name, "Swing Doctors", StringComparison.OrdinalIgnoreCase));
                swingDoctors2011Yd = DataModel.YearDatas.Where(x => x.Year.Value == 2011 && x.Player.Team.Id == swingDoctors.Id);
            }
        }


        [TestMethod]
        public void TestHandicapsFor2013()
        {
            var peteMohs = DataModel.Players.First(x => string.Equals("Pete Mohs", x.Name, StringComparison.OrdinalIgnoreCase));
            var jaysonWalberg = DataModel.Players.First(x => string.Equals("Jayson Walberg", x.Name, StringComparison.OrdinalIgnoreCase));
            var brianSchwartz = DataModel.Players.First(x => string.Equals("Brian Schwartz", x.Name, StringComparison.OrdinalIgnoreCase));

            int peteHandicap = bushwoods2013Yd.First(x => x.Player.Id == peteMohs.Id).FinishingHandicap;
            int jaysonHandicap = bushwoods2013Yd.First(x => x.Player.Id == jaysonWalberg.Id).FinishingHandicap;
            int brianHandicap = bushwoods2013Yd.First(x => x.Player.Id == brianSchwartz.Id).FinishingHandicap;

            peteHandicap.Should().Equal(11);
            jaysonHandicap.Should().Equal(7);
            brianHandicap.Should().Equal(12);
        }

        [TestMethod]
        public void TestHandicapsFor2012()
        {
            var mikeBosquez = DataModel.Players.First(x => string.Equals("Mike Bosquez", x.Name, StringComparison.OrdinalIgnoreCase));
            var mattEngstrom = DataModel.Players.First(x => string.Equals("Matt Engstrom", x.Name, StringComparison.OrdinalIgnoreCase));
            var evanStoltz = DataModel.Players.First(x => string.Equals("Evan Stoltz", x.Name, StringComparison.OrdinalIgnoreCase));

            int mikeBosquezHandicap = kraftDinner2012Yd.First(x => x.Player.Id == mikeBosquez.Id).FinishingHandicap;
            int mattEngstromHandicap = kraftDinner2012Yd.First(x => x.Player.Id == mattEngstrom.Id).FinishingHandicap;
            int evanStoltzHandicap = kraftDinner2012Yd.First(x => x.Player.Id == evanStoltz.Id).FinishingHandicap;

            mikeBosquezHandicap.Should().Equal(11);
            mattEngstromHandicap.Should().Equal(10);
            evanStoltzHandicap.Should().Equal(6);
        }

        [TestMethod]
        public void TestHandicapsFor2011()
        {
            var andyMueller = DataModel.Players.First(x => string.Equals("Andy Mueller", x.Name, StringComparison.OrdinalIgnoreCase));
            var donovanSchwartz = DataModel.Players.First(x => string.Equals("Donavan Schwartz", x.Name, StringComparison.OrdinalIgnoreCase));
            var ryanHunecke = DataModel.Players.First(x => string.Equals("Ryan Hunecke", x.Name, StringComparison.OrdinalIgnoreCase));

            int andyMuellerHandicap = swingDoctors2011Yd.First(x => x.Player.Id == andyMueller.Id).FinishingHandicap;
            int donovanSchwartzHandicap = swingDoctors2011Yd.First(x => x.Player.Id == donovanSchwartz.Id).FinishingHandicap;
            int ryanHuneckeHandicap = swingDoctors2011Yd.First(x => x.Player.Id == ryanHunecke.Id).FinishingHandicap;

            andyMuellerHandicap.Should().Equal(20);
            donovanSchwartzHandicap.Should().Equal(20);
            ryanHuneckeHandicap.Should().Equal(6);
        }
    }
}
