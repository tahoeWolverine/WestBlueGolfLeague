using Should;
using Should.Fluent;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using AccessExport;
using AccessExport.Entities;

namespace DataModelTests
{
    [TestClass]
    public class WinLossTests : DataModelTestBase
    {
        private IEnumerable<LeaderBoardData> winLossLbd2013;

        [TestInitialize]
        public void Init()
        {
            this.winLossLbd2013 = DataModel.LeaderBoardDatas.Where(x => x.Year.Value == 2013 && string.Equals(x.LeaderBoard.Key, "player_win_loss_ratio"));
        }

        [TestMethod]
        public void ShouldBeFivePlayersWith750WinLossRatioIn2013()
        {
            var wats = this.winLossLbd2013.OrderByDescending(x => x.Value);
            var secondRankWinLoss = this.winLossLbd2013.Where(x => x.Rank == 2);

            secondRankWinLoss.Count().ShouldEqual(5);
            secondRankWinLoss.First().Value.ShouldEqual(.750, .002);
        }
    }
}
