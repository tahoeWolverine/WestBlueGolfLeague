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
        private LeaderBoard pointsLeaderBoard2013;
        private IEnumerable<LeaderBoardData> teamStandings2013LBD;

        [TestInitialize]
        public void Init()
        {
            this.pointsLeaderBoard2013 = DataModel.LeaderBoards.Where(x => x.Year.Value == 2013 && string.Equals(x.Key, "team_ranking")).First();
            teamStandings2013LBD = DataModel.LeaderBoardDatas.Where(x => x.LeaderBoard.Id == pointsLeaderBoard2013.Id).OrderBy(x => x.Rank);
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
