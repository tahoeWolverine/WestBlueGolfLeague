using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    public class ScoreResultFactory
    {
        private int year;

        public ScoreResultFactory(int year)
        {
            this.year = year;
        }

        public ScoreResult CreateScoreResult(result result)
        {
            if (this.year < 2015)
            {
                return new ClassicScoreResult(result);
            }

            return new EquitableScoreResult(result);
        }

        public ScoreResult CreateWeek0Score(int week0Score)
        {
            return new ClassicScoreResult { ScoreOverPar = week0Score - 36, Week = 0 };
        }
    }
}