using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    public class ScoreResult
    {
        private ScoreResult()
        {

        }

        public ScoreResult(result result)
        {
            bool useEScore = result.year.value > 2014;

            this.Week = result.match.teammatchup.week.seasonIndex;
            this.ScoreOverPar = Math.Min((useEScore ? result.scoreVariant.Value : result.score.Value) - result.match.teammatchup.week.course.par, 20);
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

        public static ScoreResult CreateWeek0Score(int week0Score)
        {
            return new ScoreResult { ScoreOverPar = week0Score - 36, Week = 0 };
        }
    }
}