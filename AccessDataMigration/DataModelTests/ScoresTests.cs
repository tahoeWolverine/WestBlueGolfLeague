using AccessExport;
using AccessExport.Entities;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Should;
using Should.Fluent;

namespace DataModelTests
{
    [TestClass]
    public class ScoresTests : DataModelTestBase
    {
        private LeaderBoard bestScoreLb;
        private IEnumerable<LeaderBoardData> bestScoreLbd2012;
        private Player harlow;

        [TestInitialize]
        public void Init()
        {
            this.bestScoreLb = DataModel.LeaderBoards.First(x => string.Equals(x.Key, "player_best_score"));
            this.bestScoreLbd2012 = DataModel.LeaderBoardDatas.Where(x => x.Year.Value == 2012 && x.LeaderBoard.Id == bestScoreLb.Id);
            this.harlow = DataModel.Players.First(x => string.Equals(x.Name, "Michael Harlow"));
        }

        [TestMethod]
        public void HarlowTopScore2012()
        {
            var lbd = this.bestScoreLbd2012.First(x => x.IsPlayer && x.Player.Id == this.harlow.Id);

            lbd.Rank.ShouldEqual(1);
            lbd.Value.ShouldEqual(35, .01);
        }

        [TestMethod]
        public void ShouldBeThree36TopScoresIn2012()
        {
            var lbd36Count = this.bestScoreLbd2012.Where(x => x.Value == 36).Count();

            lbd36Count.ShouldEqual(5);
        }
    }
}
