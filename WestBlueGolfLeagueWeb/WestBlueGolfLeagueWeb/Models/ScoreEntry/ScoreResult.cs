using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    public interface ScoreResult
    {
        int Week
        {
            get;
        }

        int ScoreOverPar
        {
            get;
        }
    }

    public class EquitableScoreResult : ScoreResult
    {
        public EquitableScoreResult(result result)
        {
            this.Week = result.match.teammatchup.week.seasonIndex;
            this.ScoreOverPar = result.scoreVariant.Value - result.match.teammatchup.week.course.par;
        }

        public int Week
        {
            get;
            private set;
        }

        public int ScoreOverPar
        {
            get;
            private set;
        }
    }

    public class ClassicScoreResult : ScoreResult
    {
        public ClassicScoreResult(result result)
        {
            this.Week = result.match.teammatchup.week.seasonIndex;
            this.ScoreOverPar = Math.Min(result.score.Value - result.match.teammatchup.week.course.par, 20);
        }

        public ClassicScoreResult() { }

        public int Week
        {
            get;
            set;
        }

        public int ScoreOverPar
        {
            get;
            set;
        }
    }
}