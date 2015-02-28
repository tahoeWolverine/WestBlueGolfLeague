using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class TeamProfileResult
    {
        public TeamProfileResult(team t, result r)
        {
            var opponentResult = r.OpponentResult();

            this.PriorHandicapForOpponent = opponentResult.priorHandicap;
            this.PriorHandicapForPlayer = r.priorHandicap;
            this.WeekIndex = r.match.teammatchup.week.seasonIndex;
            this.OpponentName = opponentResult.player.name;
            this.WeekDate = r.match.teammatchup.week.date;
            this.Points = r.points;
            this.OpponentPoints = opponentResult.points;
            this.WasWin = r.WasWin();
            this.ScoreDifference = r.ScoreDifference();
            this.OpponentScoreDifference = opponentResult.ScoreDifference();
            this.Score = r.score;
            this.OpponentScore = opponentResult.score;
        }

        public string OpponentName { get; set; }
        public int WeekIndex { get; set; }
        public int PriorHandicapForPlayer { get; set; }
        public int PriorHandicapForOpponent { get; set; }

        public DateTime WeekDate { get; set; }

        public int OpponentScoreDifference { get; set; }

        public int ScoreDifference { get; set; }

        public bool WasWin { get; set; }

        public int OpponentPoints { get; set; }

        public int Points { get; set; }

        public int OpponentScore { get; set; }

        public int Score { get; set; }
    }
}