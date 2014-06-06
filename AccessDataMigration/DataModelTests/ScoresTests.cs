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
        private IEnumerable<LeaderBoardData> bestScoreLbd2012;
        private Player harlow;
        private Player bjerken;
        private IEnumerable<LeaderBoardData> bestScoreLbd2013;
        private IEnumerable<LeaderBoardData> bestNetScoreLbd2013;

        [TestInitialize]
        public void Init()
        {
            {
                var bestScoreLb = DataModel.LeaderBoards.First(x => string.Equals(x.Key, "player_best_score"));
                this.bestScoreLbd2012 = DataModel.LeaderBoardDatas.Where(x => x.Year.Value == 2012 && x.LeaderBoard.Id == bestScoreLb.Id);
                this.harlow = DataModel.Players.First(x => string.Equals(x.Name, "Michael Harlow"));
                this.bestScoreLbd2013 = DataModel.LeaderBoardDatas.Where(x => x.Year.Value == 2013 && x.LeaderBoard.Id == bestScoreLb.Id);
                this.bjerken = DataModel.Players.First(x => string.Equals(x.Name, "Nick Bjerken"));
            }

            {
                var bestNetScoreLb = DataModel.LeaderBoards.First(x => string.Equals(x.Key, "player_net_best_score"));
                this.bestNetScoreLbd2013 = DataModel.LeaderBoardDatas.Where(x => x.Year.Value == 2013 && x.LeaderBoard.Id == bestNetScoreLb.Id);
            }

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

        [TestMethod]
        public void BjerkenTopScore2013()
        {
            var lbd = this.bestScoreLbd2013.First(x => x.IsPlayer && x.Player.Id == this.bjerken.Id);

            lbd.Rank.ShouldEqual(1);
            lbd.Value.ShouldEqual(34);
        }

        [TestMethod]
        public void BestNetScoreShouldBeNegative102013()
        {
            var orderedData = this.bestNetScoreLbd2013.OrderBy(x => x.Rank).ToList();
            var netScoreData = this.bestNetScoreLbd2013.Where(x => x.Rank == 1);

            netScoreData.First().Value.ShouldEqual(-10);
            netScoreData.Count().ShouldEqual(1);
            orderedData.Count().ShouldBeGreaterThan(0);
        }

        [TestMethod]
        public void SecondBestNetScore2013ShouldHaveRank2()
        {
            var netScoreData = this.bestNetScoreLbd2013.Where(x => x.Rank == 2);

            netScoreData.Count().ShouldEqual(4);
        }

        public void ThirdBestNetScore2013ShouldHaveRank6()
        {
            var rank6Data = this.bestNetScoreLbd2013.Where(x => x.Rank == 6);

            rank6Data.Count().ShouldEqual(6);
            rank6Data.First().Value.ShouldEqual(-7);
        }
    }
}
