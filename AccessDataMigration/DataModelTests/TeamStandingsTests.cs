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
    public class TeamStandingsTests : DataModelTestBase
    {
        private LeaderBoard pointsLeaderBoard;
        private IEnumerable<LeaderBoardData> teamStandings2013LBD;

        [TestInitialize]
        public void Init()
        {
            this.pointsLeaderBoard = DataModel.LeaderBoards.Where(x => string.Equals(x.Key, "team_ranking")).First();
            teamStandings2013LBD = DataModel.LeaderBoardDatas.Where(x => x.LeaderBoard.Id == pointsLeaderBoard.Id && x.Year.Value == 2013).OrderBy(x => x.Rank);
        }

        [TestMethod]
        public void BushwoodsFinestWins2013()
        {
            LeaderBoardData bushwoods = this.teamStandings2013LBD.First();

            bushwoods.Team.Name.Should().StartWith("Bushwoods Finest");
            bushwoods.Value.Should().Equal(836);
            bushwoods.Rank.Should().Equal(1);
            bushwoods.IsPlayer.ShouldBeFalse();
        }
    }
}
