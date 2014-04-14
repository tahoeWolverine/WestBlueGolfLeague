using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Should;
using Should.Fluent;
using AccessExport;
using AccessExport.Entities;

namespace DataModelTests
{
    [TestClass]
    public class SeasonImprovementTests : DataModelTestBase
    {
        private IEnumerable<LeaderBoardData> seasonImprovementLbd2013;

        [TestInitialize]
        public void Init()
        {
            this.seasonImprovementLbd2013 = DataModel.LeaderBoardDatas.Where(x => x.Year.Value == 2013 && x.LeaderBoard.Key == "player_season_improvement");
        }

        [TestMethod]
        public void ShouldBe12SeasonImprovementsOfNegative2()
        {
            var lbds = this.seasonImprovementLbd2013.Where(x => x.Rank == 5);

            lbds.Count().ShouldEqual(12);
            lbds.First().Value.ShouldEqual(-2);
        }
    }
}
