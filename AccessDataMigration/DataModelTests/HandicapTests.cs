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
        [TestInitialize()]
        public void Initialize()
        {

        }


        [TestMethod]
        public void TestHandicapsFor2013()
        {
            int peteHandicap = this.FinishingHandicapFor("Pete Mohs", 2013);
            int jaysonHandicap = this.FinishingHandicapFor("Jayson Walberg", 2013);
            int brianHandicap = this.FinishingHandicapFor("Brian Schwartz", 2013);

            peteHandicap.Should().Equal(11);
            jaysonHandicap.Should().Equal(7);
            brianHandicap.Should().Equal(12);
        }

        [TestMethod]
        public void TestHandicapsFor2012()
        {
            int mikeBosquezHandicap = this.FinishingHandicapFor("Mike Bosquez", 2012);
            int mattEngstromHandicap = this.FinishingHandicapFor("Matt Engstrom", 2012);
            int evanStoltzHandicap = this.FinishingHandicapFor("Evan Stoltz", 2012);

            mikeBosquezHandicap.Should().Equal(11);
            mattEngstromHandicap.Should().Equal(10);
            evanStoltzHandicap.Should().Equal(6);
        }

        [TestMethod]
        public void TestHandicapsFor2011()
        {
            int andyMuellerHandicap = this.FinishingHandicapFor("Andy Mueller", 2011);
            int donovanSchwartzHandicap = this.FinishingHandicapFor("Donavan Schwartz", 2011);
            int ryanHuneckeHandicap = this.FinishingHandicapFor("Ryan Hunecke", 2011);

            andyMuellerHandicap.Should().Equal(20);
            donovanSchwartzHandicap.Should().Equal(20);
            ryanHuneckeHandicap.Should().Equal(6);
        }

        [TestMethod]
        public void TestHandicapsFor2010()
        {
            int conryHandicap = this.FinishingHandicapFor("Jim Conry", 2010);
            int nolandHandicap = this.FinishingHandicapFor("Mac Noland", 2010);
            int harlowHandicap = this.FinishingHandicapFor("Michael Harlow", 2010);

            conryHandicap.ShouldEqual(9);
            nolandHandicap.ShouldEqual(8);
            harlowHandicap.ShouldEqual(10);
        }

        private int FinishingHandicapFor(string playerName, int year)
        {
            var player = DataModel.Players.First(x => string.Equals(playerName, x.Name, StringComparison.OrdinalIgnoreCase));

            var yearDataForPlayer = DataModel.YearDatas.First(x => x.Player.Id == player.Id && x.Year.Value == year);

            return yearDataForPlayer.FinishingHandicap;
        }
    }
}
