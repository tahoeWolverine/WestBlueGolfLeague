using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses.Team
{
    public class TeamProfileResult
    {
        // Need to get results for year, and in turn, individual win/loss string
        public TeamProfileResult(team t, result r)
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
                    if (t.id != aTeam.id)
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
            this.TeeTime = tm.teeTimeText();
            this.CourseName = tm.week.course.name;
        }

        // Needed for most other team display
        public TeamProfileResult(team t, teammatchup tm)
        {
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
                        this.PriorHandicapForOpponent += r.priorHandicap;
                        this.OpponentPoints += r.points;
                        this.OpponentScoreDifference += r.ScoreDifference();
                        this.OpponentScore += r.score;
                    }
                }
            }

            foreach (team aTeam in tm.teams)
            {
                if (t.id != aTeam.id)
                {
                    this.OpponentName = aTeam.teamName;
                }
            }

            this.WeekIndex = tm.week.seasonIndex;
            this.WeekDate = tm.week.date;
            this.TeeTime = tm.teeTimeText();
            this.CourseName = tm.week.course.name;
            this.WasWin = this.Points > 48;
            this.WasLoss = this.Points < 48;
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