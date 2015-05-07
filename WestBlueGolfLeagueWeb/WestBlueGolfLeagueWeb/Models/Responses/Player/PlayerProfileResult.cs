using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Extensions;

namespace WestBlueGolfLeagueWeb.Models.Responses.Player
{
    public class PlayerProfileResult
    {
        public PlayerProfileResult(player p, result r)
        {
            this.PriorHandicapForPlayer = r.priorHandicap;
            this.Points = r.points;
            this.WasWin = r.WasWin();
            this.WasLoss = r.WasLoss();
            this.ScoreDifference = r.ScoreDifference();
            this.Score = r.score;

            var opponentResult = r.OpponentResult();
            if (opponentResult == null)
            {
                foreach (team aTeam in r.match.teammatchup.teams)
                {
                    if (r.team.id != aTeam.id)
                    {
                        this.OpponentName = aTeam.teamName;
                    }
                }

                // These values shouldn't matter, as UI should check for completion before using
                this.PriorHandicapForOpponent = 0;
                this.OpponentPoints = 0;
                this.OpponentScoreDifference = 0;
                this.OpponentScore = 0;
            }
            else
            {
                this.PriorHandicapForOpponent = opponentResult.priorHandicap;
                this.OpponentName = opponentResult.player.name;
                this.OpponentPoints = opponentResult.points;
                this.OpponentScoreDifference = opponentResult.ScoreDifference();
                this.OpponentScore = opponentResult.score;
            }

            var tm = r.match.teammatchup;
            this.WeekIndex = tm.week.seasonIndex;
            this.WeekDate = tm.week.date;
            this.TeeTime = tm.TeeTimeText();
            this.CourseName = tm.week.course.name;
        }

        public string OpponentName { get; set; }
        public string CourseName { get; set; }
        public string TeeTime { get; set; }
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