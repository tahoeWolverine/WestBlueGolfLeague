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
    public class PointsTests : DataModelTestBase
    {
        private Player rickRowan;
        private IEnumerable<LeaderBoardData> rickRowanLbd2013;
        private Team mulligans;
        private IEnumerable<LeaderBoardData> mulligansLbd2013;
        private Team kraftDinner;
        private IEnumerable<LeaderBoardData> kraftDinnerLbd2013;
        private IEnumerable<LeaderBoardData> averagePoints2013;
        private IEnumerable<LeaderBoardData> mostPointsInMatch2013;
        private IEnumerable<LeaderBoardData> totalPoints2013;

        [TestInitialize]
        public void Init()
        {
            this.rickRowan = DataModel.Players.First(x => string.Equals("Rick Rowan", x.Name));
            this.rickRowanLbd2013 = DataModel.LeaderBoardDatas.Where(x => x.IsPlayer && x.Player.Id == rickRowan.Id && x.Year.Value == 2013);
            this.mulligans = DataModel.Teams.First(x => string.Equals("Mulligans", x.Name));
            this.mulligansLbd2013 = DataModel.LeaderBoardDatas.Where(x => x.IsPlayer == false && x.Year.Value == 2013 && x.Team.Id == mulligans.Id);
            this.kraftDinner = DataModel.Teams.First(x => string.Equals("Kraft Dinner", x.Name));
            this.kraftDinnerLbd2013 = DataModel.LeaderBoardDatas.Where(x => x.IsPlayer == false && x.Year.Value == 2013 && x.Team.Id == kraftDinner.Id);
            this.averagePoints2013 = DataModel.LeaderBoardDatas.Where(x => x.Year.Value == 2013 && x.IsPlayer == true && string.Equals(x.LeaderBoard.Key, "player_average_points"));
            this.mostPointsInMatch2013 = DataModel.LeaderBoardDatas.Where(x => x.Year.Value == 2013 && x.LeaderBoard.Key == "player_points_in_match");
            this.totalPoints2013 = DataModel.LeaderBoardDatas.Where(x => x.Year.Value == 2013 && x.LeaderBoard.Key == "player_total_points");
        }


        [TestMethod]
        public void RickRowanPoints2013()
        {
            var playerPointsLbd = this.rickRowanLbd2013.First(x => x.LeaderBoard.Key == "player_total_points");

            playerPointsLbd.Value.ShouldEqual(149);

            var avgPointsLbd = this.rickRowanLbd2013.First(x => x.LeaderBoard.Key == "player_average_points");

            avgPointsLbd.Value.ShouldEqual(10.6, .1);
        }

        [TestMethod]
        public void MulligansPoints2013()
        {
            var teamPointsLbd = this.mulligansLbd2013.First(x => x.LeaderBoard.Key == "team_ranking");

            teamPointsLbd.Value.ShouldEqual(681);
        }

        [TestMethod]
        public void KraftDinnerHasSecondMostPointsInWeek2013()
        {
            var pointsInWeekLbd2013 = DataModel.LeaderBoardDatas.Where(x => string.Equals("team_most_points_in_week", x.LeaderBoard.Key) && x.Year.Value == 2013);
            var lbd = this.kraftDinnerLbd2013.First(x => string.Equals("team_most_points_in_week", x.LeaderBoard.Key));

            lbd.Value.ShouldEqual(73);
            lbd.Rank.ShouldEqual(2);
        }

        [TestMethod]
        public void BradShouldHaveBestAveragePoints2013()
        {
            var firstRank = this.averagePoints2013.Where(x => x.Rank == 1);

            firstRank.Count().ShouldEqual(1);
            firstRank.First().Value.ShouldEqual(15.38, .1);
            firstRank.First().Player.Name.ShouldEqual("Brad Zilge");
        }

        [TestMethod]
        public void FourPlayersWith22PointsInMatchAndRank22013()
        {
            var pointsLbd = this.mostPointsInMatch2013.Where(x => x.Rank == 2);

            pointsLbd.Count().ShouldEqual(4);
            pointsLbd.First().Value.ShouldEqual(22);
        }

        [TestMethod]
        public void PerryHasMostPoints2013()
        {
            var totalPoints = this.totalPoints2013.Where(x => x.Rank == 1);

            totalPoints.Count().ShouldEqual(1);
            totalPoints.First().Value.ShouldEqual(211);
        }
    }
}
