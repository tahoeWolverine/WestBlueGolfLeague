using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Extensions
{
    public static class TeamExtensions
    {
        public static IEnumerable<result> AllResultsForYear(this team team, year year, week week = null)
        {
            var seasonIndex = week == null ? 50 : week.seasonIndex;

            return team.results.Where(x => x.year.value == year.value && x.match.teammatchup.week.seasonIndex < seasonIndex && x.IsComplete());
        }

        public static double AverageHandicapForYear(this team team, year year)
        {
            // Get all results for year
            var resultsForYear = team.AllResultsForYear(year);

            // Get all players for these results
            var playersWhichPlayedForYear = resultsForYear.Select(x => x.player).Where(x => x.validPlayer).GroupBy(x => x.id).Select(x => x.First());

            // get year data for all players
            List<playeryeardata> yds = new List<playeryeardata>();

            foreach (var player in playersWhichPlayedForYear)
            {
                var yd = player.playeryeardatas.FirstOrDefault(y => y.year.id == year.id);

                if (yd == null) { continue; }

                yds.Add(yd);
            }

            var handicapSum = yds.Sum(x => x.finishingHandicap);

            if (playersWhichPlayedForYear.Count() == 0) return 0.0;

            return (double)handicapSum / (double)playersWhichPlayedForYear.Count();
        }

        public static IEnumerable<player> AllPlayersForYear(this team team, year year)
        {
            var allPlayersForYear = team.playeryeardatas.Where(x => x.year.id == year.id).ToList();

            return allPlayersForYear.Where(x => x.player.validPlayer).Select(x => x.player);
        }

        public static int TotalPointsForYear(this team team, year year)
        {
            var allResults = team.AllResultsForYear(year);

            int total = 0;

            foreach (var result in allResults)
            {
                total += result.points.Value;
            }

            return total;
        }

        public static double AverageOpponentScoreForYear(this team team, year year)
        {
            var results = team.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0;

            double totalScore = 0;
            double opponentCount = 0;

            foreach (var result in results)
            {
                int val = result.OpponentResult().ScoreDifference().Value;

                if (val < 60)
                {
                    totalScore += val;
                    opponentCount++;
                }
            }

            if (opponentCount == 0)
            {
                return 0.0;
            }

            return totalScore / opponentCount;
        }

        public static double AverageOpponentNetScoreForYear(this team team, year year)
        {
            var allResults = team.AllResultsForYear(year);
            if (allResults == null || allResults.Count() == 0) return 0;

            double totalScore = 0;
            double opponentCount = 0;

            foreach (var result in allResults)
            {
                int val = result.OpponentResult().NetScoreDifference().Value;

                if (val < 60)
                {
                    totalScore += val;
                    opponentCount++;
                }
            }

            if (opponentCount == 0)
            {
                return 0.0;
            }

            return totalScore / opponentCount;
        }

        public static int ImprovedInYear(this team team, year year)
        {
            int totalImproved = 0;

            var allPlayers = team.AllPlayersForYear(year);

            foreach (var p in allPlayers) totalImproved += (int)p.ImprovedInYear(year);

            return totalImproved;
        }

        public static double RecordRatioForYear(this team team, year year)
        {
            var record = team.RecordForYear(year);

            double totalWins = (double)record[0] + ((double)record[2] / 2.0);
            int totalWeeks = record[0] + record[1] + record[2];

            if (totalWeeks == 0)
            {
                return 0.0;
            }

            return totalWins / (double)totalWeeks;
        }

        public static int[] RecordForYear(this team team, year year)
        {
            var allResults = team.AllResultsForYear(year);
            int wins = 0, losses = 0, ties = 0;

            int[] pointsForWeek = Enumerable.Repeat(0, 30).ToArray();

            foreach (var result in allResults)
            {
                int seasonIndex = result.match.teammatchup.week.seasonIndex;

                pointsForWeek[seasonIndex] = pointsForWeek[seasonIndex] + result.points.Value;
            }

            foreach (int p in pointsForWeek)
            {
                if (p == 0)
                {
                    continue;
                }

                if (p > 48) wins++;
                else if (p == 48) ties++;
                else if (p < 48) losses++;
            }

            return new int[] { wins, losses, ties };
        }

        internal static double AverageScoreForYear(this team team, year year)
        {
            var results = team.AllResultsForYear(year);
            if (results == null || results.Count() == 0)
            {
                return 0.0;
            }

            double totalScore = 0;
            double roundCount = 0;
            int value = 0;
            foreach (var result in results)
            {
                value = result.ScoreDifference().Value;

                if (value < 60)
                {
                    totalScore += value;
                    roundCount++;
                }
            }

            if (roundCount == 0.0 || totalScore == 0.0)
            {
                return 63.0;
            }

            return totalScore / roundCount;
        }

        internal static double AverageNetScoreForYear(this team team, year year)
        {
            var results = team.AllResultsForYear(year);
            if (results == null || results.Count() == 0)
            {
                return 0.0;
            }
            double totalScore = 0;
            int roundCount = 0;
            int value = 0;
            foreach (var result in results)
            {
                value = result.NetScoreDifference().Value;
                if (value < 60)
                {
                    totalScore += value;
                    roundCount++;
                }
            }

            if (roundCount == 0) return 0.0;

            return totalScore / roundCount;
        }

        internal static double IndividualRecordRatioForYear(this team team, year year)
        {
            var record = team.IndividualRecordForYear(year);

            double totalWins = record[0] + ((double)record[2] / 2.0);
            double totalWeeks = record[0] + record[1] + record[2];

            if (totalWeeks == 0) return 0;

            return totalWins / totalWeeks;
        }

        public static double[] IndividualRecordForYear(this team team, year year)
        {
            var results = team.AllResultsForYear(year);
            int wins = 0, losses = 0, ties = 0;

            foreach (var result in results)
            {
                if (result.WasWin())
                {
                    wins++;
                }
                else if (result.WasLoss())
                {
                    losses++;
                }
                else
                {
                    ties++;
                }
            }

            return new double[] { wins, losses, ties };
        }

        internal static int MostPointsInWeekForYear(this team team, year year)
        {
            var results = team.AllResultsForYear(year);

            // group results by week
            var groupedResults = results.GroupBy(x => x.match.teammatchup.week.seasonIndex, x => x, (key, elements) => new { WeekId = key, Results = elements });

            int max = 0;
            foreach (var r in groupedResults)
            {
                int total = r.Results.Select(x => x.points.Value).Sum();

                if (total >= max) max = total;
            }

            return max;
        }

        internal static double AverageMarginOfVictoryForYear(this team team, year year)
        {
            var results = team.AllResultsForYear(year);
            if (results == null || results.Count() == 0)
            {
                return 0.0;
            }

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

        internal static double AverageMarginOfNetVictoryForYear(this team team, year year)
        {
            var results = team.AllResultsForYear(year);
            if (results == null || results.Count() == 0)
            {
                return 0.0;
            }

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
    }
}