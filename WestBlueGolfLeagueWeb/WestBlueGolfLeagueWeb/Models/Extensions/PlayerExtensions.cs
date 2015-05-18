using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Extensions
{
    public static class PlayerExtensions
    {
        public static IEnumerable<result> AllResultsForYear(this player player, year year)
        {
            return player.results.Where(x => x.year.id == year.id);
        }

        public static double ImprovedInYear(this player player, year year)
        {
            // There should always be a year data for the year passed in.
            //var ydForYear = this.yearData.First(yd => yd.year.Value == year.Value);
            //int starting = ydForYear.StartingHandicap;

            //int ending = year.NewestYear ? this.CurrentHandicap : ydForYear.FinishingHandicap;

            //return ending - starting;
            return 0;
        }

        // TODO: take in to account unfinished results.
        public static double LowRoundForYear(this player player, year year)
        {
            var bestScore = player.AllResultsForYear(year).OrderBy(x => x.score).FirstOrDefault();

            if (bestScore == null)
            {
                return 99;
            }

            // TODO: take in to account unfinished results.
            return bestScore.score.Value;
        }

        public static double LowNetForYear(this player player, year year)
        {
            var results = player.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 10;

            int lowNet = 100;
            foreach (var result in results)
            {
                int netScoreDifference = result.NetScoreDifference().Value;
                if (netScoreDifference < lowNet)
                {
                    lowNet = netScoreDifference;
                }
            }

            return lowNet;
        }

        public static double FinishingHandicapInYear(this player player, year year)
        {
            //// Should only be called with a valid year... will blow up otherwise.
            //var yd = player.yearData.First(x => x.year.Value == year.Value);

            //return yd.FinishingHandicap;
            return 0;
        }

        // TODO: take in to account unfinished results.
        public static double AveragePointsInYear(this player player, year year)
        {
            var results = player.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

            int totalPoints = 0;
            foreach (var result in results)
            {
                totalPoints += result.points.Value;
            }

            return (double)totalPoints / (double)results.Count();
        }

        public static double RecordRatioForYear(this player player, year year)
        {
            //var record = player.RecordForYear(year);
            //double totalWins = record[0] + ((double)record[2] / 2);
            //int totalMatches = record[0] + record[1] + record[2];

            //return totalMatches == 0 ? 0.0 : totalWins / (double)totalMatches;
            return 0;
        }

        public static int[] RecordForYear(this player player, year year)
        {
            //var results = player.AllResultsForYear(year);

            //int wins = 0, losses = 0, ties = 0;

            //foreach (var result in results)
            //{
            //    if (result.WasWin) wins++;
            //    else if (result.WasLoss) losses++;
            //    else ties++;
            //}

            //return new int[] { wins, losses, ties };
            return new int[] { 0, 0, 0 };
        }

        // TODO: take in to account unfinished results.
        public static double AverageOpponentScoreForYear(this player player, year year)
        {
            var results = player.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

            double totalOpponentScore = 0;
            int opponentCount = 0;
            int value = 0;
            foreach (var result in results)
            {
                value = result.OpponentResult().score.Value;
                if (value < 89)
                {
                    totalOpponentScore += value;
                    opponentCount++;
                }
            }

            if (opponentCount == 0)
            {
                return 0.0;
            }

            return (double)totalOpponentScore / (double)opponentCount;
        }

        public static double AverageOpponentNetScoreForYear(this player player, year year)
        {
            //var results = player.AllResultsForYear(year);

            //if (results == null || results.Count() == 0) return 0.0;

            //double totalOpponentScore = 0;
            //int opponentCount = 0;
            //int value = 0;
            //foreach (var result in results)
            //{
            //    value = result.GetOpponentResult().NetScoreDifference;
            //    if (value < 60)
            //    {
            //        totalOpponentScore += value;
            //        opponentCount++;
            //    }
            //}

            //if (opponentCount == 0)
            //{
            //    return 0.0;
            //}

            //return (double)totalOpponentScore / (double)opponentCount;
            return 0;
        }

        // TODO: take in to account unfinished results.
        public static double AverageScoreForYear(this player player, year year)
        {
            var results = player.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

            double totalRoundScore = 0;
            int roundCount = 0;
            foreach (var result in results)
            {
                totalRoundScore += result.score.Value;
                roundCount++;
            }

            if (roundCount == 0)
            {
                return 0.0;
            }

            return totalRoundScore / (double)roundCount;
        }

        // TODO: take in to account unfinished results.
        public static double AverageNetScoreForYear(this player player, year year)
        {
            var results = player.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

            double totalRoundScore = 0;
            int roundCount = 0;
            foreach (var result in results)
            {
                totalRoundScore += result.NetScoreDifference().Value;
                roundCount++;
            }

            return (double)totalRoundScore / (double)roundCount;
        }

        // TODO: take in to account unfinished results.
        public static double MostPointsInMatchForYear(this player player, year year)
        {
            var results = player.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

            int mostPoints = 0;
            foreach (var result in results)
            {
                if (result.points > mostPoints)
                {
                    mostPoints = result.points.Value;
                }
            }

            return mostPoints;
        }

        // TODO: take in to account unfinished results.
        public static double TotalPointsForYear(this player player, year year)
        {
            var results = player.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

            int totalPoints = 0;
            foreach (var result in results)
            {
                totalPoints += result.points.Value;
            }

            return totalPoints;
        }

        // TODO: take in to account unfinished results.
        public static double AverageMarginOfVictoryForYear(this player player, year year)
        {
            var results = player.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

            double totalMargin = 0;
            int roundCount = 0;
            int playerValue = 0, oppValue = 0;
            foreach (var result in results)
            {
                playerValue = result.ScoreDifference().Value;
                oppValue = result.OpponentResult().ScoreDifference().Value;
                if (oppValue < 60)
                {
                    totalMargin += oppValue - playerValue;
                    roundCount++;
                }
            }

            if (roundCount == 0)
            {
                return 0.0;
            }

            return totalMargin / roundCount;
        }

        // TODO: take in to account unfinished results.
        public static double AverageMarginOfNetVictoryForYear(this player player, year year)
        {
            var results = player.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

            double totalMargin = 0;
            int roundCount = 0;
            int playerValue = 0, oppValue = 0;
            foreach (var result in results)
            {
                playerValue = result.NetScoreDifference().Value;
                oppValue = result.OpponentResult().NetScoreDifference().Value;
                if (oppValue < 60)
                {
                    totalMargin += oppValue - playerValue;
                    roundCount++;
                }
            }

            if (roundCount == 0)
            {
                return 0.0;
            }

            return totalMargin / roundCount;
        }

        public static double TotalRoundsForYear(this player player, year year)
        {
            //var record = player.RecordForYear(year);

            //return record[0] + record[1] + record[2];
            return 0;
        }
    }
}