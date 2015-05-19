using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Extensions
{
    public static class ResultExtensions
    {
        public static bool WasWin(this result r)
        {
            return r.points > 12;
        }

        public static bool WasLoss(this result r)
        {
            return r.points < 12;
        }

        public static result OpponentResult(this result r)
        {
            if (r.match.results.Count < 2)
            {
                return null;
            }
            return r.match.results.First(x => x.id != r.id);
        }

        public static int? ScoreDifference(this result r)
        {
            return r.score - r.match.teammatchup.week.course.par;
        }

        public static int? NetScoreDifference(this result r)
        {
            return r.ScoreDifference() - r.priorHandicap;
        }

        /// <summary>
        /// Score and escore can never be 0.
        /// </summary>
        public static bool IsComplete(this result r)
        {
            return r.points.HasValue && r.score.HasValue && r.score.Value > 0 && (!r.scoreVariant.HasValue || r.scoreVariant > 0);
        }
    }
}