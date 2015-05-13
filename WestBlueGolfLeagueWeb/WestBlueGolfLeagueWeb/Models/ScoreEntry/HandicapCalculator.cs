using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    public class HandicapCalculator
    {
        private ScoreResultFactory scoreResultFactory;

        public HandicapCalculator(ScoreResultFactory scoreResultFactory)
        {
            this.scoreResultFactory = scoreResultFactory;
        }

        public HandicapCalculationResult CalculateAndCascadeHandicaps(IEnumerable<result> results, int week0Score, bool isRookie)
        {
            if (results == null || results.Count() == 0)
            {
                throw new ArgumentException("Can't call this method with no results.");
            }

            // Get all results for a player for the year.
            var resultsForPlayerForYear = results.ToList();

            HandicapCalculationResult handicapResult = null, firstHandicapResult = null;

            for (int i = resultsForPlayerForYear.Count - 1; i >= 0; i--)
            {
                var subResults = resultsForPlayerForYear.Take(i + 1);

                handicapResult = HandicapsForResults(subResults, week0Score, isRookie);

                // bleh this could be cleaned up.
                if (i == 0)
                {
                    resultsForPlayerForYear[i].priorHandicap = week0Score - 36;
                }

                if (i == resultsForPlayerForYear.Count - 1)
                {
                    firstHandicapResult = handicapResult;
                }
                else
                {
                    resultsForPlayerForYear[i + 1].priorHandicap = handicapResult.Handicap;
                }
            }

            return firstHandicapResult;           
        }

        public HandicapCalculationResult HandicapsForResults(IEnumerable<result> results, int week0Score, bool isRookie)
        {
            LinkedList<ScoreResult> copiedScores = new LinkedList<ScoreResult>(results.Select(x => this.scoreResultFactory.CreateScoreResult(x)));

            int numberOfWeekZeroesToAdd = 0;

            // nasty... look at maybe cleaning up
            if (copiedScores.Count == 4)
            {
                numberOfWeekZeroesToAdd = 1;
            }
            else if (copiedScores.Count < 4)
            {
                if (!isRookie)
                {
                    numberOfWeekZeroesToAdd = 4 - copiedScores.Count;
                }
                else
                {
                    numberOfWeekZeroesToAdd = 1;
                }
            }

            for (int i = 0; i < numberOfWeekZeroesToAdd; i++)
            {
                copiedScores.AddLast(this.scoreResultFactory.CreateWeek0Score(week0Score));
            }

            if (copiedScores.Count >= 5)
            {
                var lastFiveScores = copiedScores.Skip(copiedScores.Count - 5);

                int max = 0,
                    handicapSum = 0,
                    weekWithMax = 0;

                LinkedList<int> weeksUsed = new LinkedList<int>();

                foreach (var score in lastFiveScores)
                {
                    var handicapSplit = score.ScoreOverPar;

                    if (handicapSplit > max)
                    {
                        max = handicapSplit;
                        weekWithMax = score.Week;
                    }

                    weeksUsed.AddLast(score.Week);
                    handicapSum += handicapSplit;
                }

                weeksUsed.Remove(weekWithMax);

                return new HandicapCalculationResult { Handicap = CalcHandicapFromScores(handicapSum - max, 4), WeeksUsed = weeksUsed };
            }
            else
            {
                LinkedList<int> weeksUsed = new LinkedList<int>();

                int sum = 0;

                foreach (var score in copiedScores)
                {
                    weeksUsed.AddLast(score.Week);
                    sum += score.ScoreOverPar;
                }

                return new HandicapCalculationResult { Handicap = CalcHandicapFromScores(sum, copiedScores.Count), WeeksUsed = weeksUsed };
            }
        }

        private static int CalcHandicapFromScores(int scoreTotal, int scoreCount)
        {
            double averageScoreAbovePar = ((double)scoreTotal / (double)scoreCount);
            double remainder = averageScoreAbovePar - (scoreTotal / scoreCount);

            return Math.Min((int)(averageScoreAbovePar + (remainder >= .5 ? 1 : 0)), 20);
        }

    }
}