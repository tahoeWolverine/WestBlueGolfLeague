using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    public class ScoreResult
    {
        private ScoreResult()
        {

        }

        public ScoreResult(Result result)
        {
            this.Week = result.Matchup.TeamMatchup.Week.SeasonIndex;
            this.ScoreOverPar = Math.Min(result.Score - result.Matchup.TeamMatchup.Week.Course.Par, 20);
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
