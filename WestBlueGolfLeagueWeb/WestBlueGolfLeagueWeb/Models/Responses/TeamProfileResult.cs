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
            this.WasLoss = r.WasLoss();
            this.ScoreDifference = r.ScoreDifference();
            this.OpponentScoreDifference = opponentResult.ScoreDifference();
            this.Score = r.score;
            this.OpponentScore = opponentResult.score;
        }

        public TeamProfileResult(team t, teammatchup tm)
        {
            this.OpponentName = "";
            this.PriorHandicapForOpponent = 0;
            this.PriorHandicapForPlayer = 0;
            this.OpponentPoints = 0;
            this.Points = 0;
            this.ScoreDifference = 0;
            this.OpponentScoreDifference = 0;
            this.Score = 0;
            this.OpponentScore = 0;

            foreach(match m in tm.matches)
            {
                foreach (result r in m.results)
                {
                    if (r.team.id == t.id)
                    {
                        this.PriorHandicapForPlayer += r.priorHandicap;
                        this.Points += r.points;
                        this.ScoreDifference += r.ScoreDifference();
                        this.Score += r.score;
                    }
                    else
                    {
                        if (this.OpponentName == null || this.OpponentName == "")
                        {
                            this.OpponentName = r.team.teamName;
                        }
                        this.PriorHandicapForOpponent += r.priorHandicap;
                        this.OpponentPoints += r.points;
                        this.OpponentScoreDifference += r.ScoreDifference();
                        this.OpponentScore += r.score;
                    }
                }
            }

            this.WeekIndex = tm.week.seasonIndex;
            this.WeekDate = tm.week.date;
            this.WasWin = this.Points > 48;
            this.WasLoss = this.Points < 48;
        }

        public string OpponentName { get; set; }
        public int WeekIndex { get; set; }
        public int? PriorHandicapForPlayer { get; set; }
        public int? PriorHandicapForOpponent { get; set; }

        public DateTime WeekDate { get; set; }

        public int? OpponentScoreDifference { get; set; }

        public int? ScoreDifference { get; set; }

        public bool WasWin { get; set; }

        public bool WasLoss { get; set; }

        public int? OpponentPoints { get; set; }

        public int? Points { get; set; }

        public int? OpponentScore { get; set; }

        public int? Score { get; set; }
    }
}