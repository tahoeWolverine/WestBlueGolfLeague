using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    class Team
    {
        private List<Result> allResults = new List<Result>();
        private Dictionary<int, Player> allPlayers = new Dictionary<int, Player>();

        public string Name { get; set; }
        public int Id { get; set; }

        public bool ValidTeam { get; set; }

        public ICollection<Result> AllResults { get { return this.allResults; } }
        public ICollection<Player> AllPlayers { get { return this.allPlayers.Values; } }


        public void AddResult(Result result)
        {
            this.allResults.Add(result);
        }

        public void AddPlayer(Player player)
        {
            this.allPlayers.Add(player.Id, player);
        }

        public void RemovePlayer(Player player)
        {
            this.allPlayers.Remove(player.Id);
        }

        public IEnumerable<Result> AllResultsForYear(Year year, Week week = null)
        {
            var seasonIndex = week == null ? 50 : week.SeasonIndex;

            return this.allResults.Where(x => x.Year.Value == year.Value && x.Matchup.TeamMatchup.Week.SeasonIndex < seasonIndex);
        }

        public double AverageHandicapForYear(Year year)
        {
            var allPlayersForYear = this.AllPlayersForYear(year);

            int totalHandicap = 0;

            foreach (var player in allPlayersForYear) { totalHandicap += player.CurrentHandicap; }

            return (double)totalHandicap / (double)allPlayersForYear.Count();
        }

        public IEnumerable<Player> AllPlayersForYear(Year year)
        {
            var allPlayersForYear = this.allPlayers.Values.Where(x => x.YearDatas.Any(y => y.Year.Value == year.Value)).ToList();

            return allPlayersForYear;
        }

        public int TotalPointsForYear(Year year)
        {
            var allResults = this.AllResultsForYear(year);

            int total = 0;

            foreach (var result in allResults)
            {
                total += result.Points;
            }

            return total;
        }

        public double AverageOpponentScoreForYear(Year year)
        {
            var results = this.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0;

            double totalScore = 0;
            double opponentCount = 0;

            foreach (var result in results)
            {
                int val = result.GetOpponentResult().ScoreDifference;

                if (val < 60)
                {
                    totalScore += val;
                    opponentCount++;
                }
            }

            return totalScore / opponentCount;
        }

        internal double AverageOpponentNetScoreForYear(Year year)
        {
            var allResults = this.AllResultsForYear(year);
            if (allResults == null || allResults.Count() == 0) return 0;

            double totalScore = 0;
            double opponentCount = 0;

            foreach (var result in allResults)
            {
                int val = result.GetOpponentResult().NetScoreDifference;

                if (val < 60)
                {
                    totalScore += val;
                    opponentCount++;
                }
            }

            return totalScore / opponentCount;

        }

        public int ImprovedInYear(Year year)
        {
            int totalImproved = 0;

            var allPlayers = this.AllPlayersForYear(year);

            foreach (var p in allPlayers) totalImproved += p.ImprovedInYear(year);

            return totalImproved;
        }

        public double RecordRatioForYear(Year year)
        {
            var record = this.RecordForYear(year);

            double totalWins = (double)record[0] + ((double)record[1] / 2.0);
            int totalWeeks = record[0] + record[1] + record[2];

            return totalWins / (double)totalWeeks;
        }

        public int[] RecordForYear(Year year)
        {
            var allResults = this.AllResultsForYear(year);
            int wins = 0, losses = 0, ties = 0;

            int[] pointsForWeek = Enumerable.Repeat(0, 30).ToArray();

            foreach (var result in allResults)
            {
                int seasonIndex = result.Matchup.TeamMatchup.Week.SeasonIndex;

                pointsForWeek[seasonIndex] = pointsForWeek[seasonIndex] + result.Points;
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

        internal double AverageScoreForYear(Year year)
        {
            var results = this.AllResultsForYear(year);
            if (results == null || results.Count() == 0)
            {
                return 0.0;
            }

            double totalScore = 0;
            double roundCount = 0;
            int value = 0;
            foreach (var result in results)
            {
                value = result.ScoreDifference;

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

        internal double AverageNetScoreForYear(Year year)
        {
            var results = this.AllResultsForYear(year);
            if (results == null || results.Count() == 0)
            {
                return 0.0;
            }
            double totalScore = 0;
            int roundCount = 0;
            int value = 0;
            foreach (var result in results)
            {
                value = result.ScoreDifference;
                if (value < 60)
                {
                    totalScore += value;
                    roundCount++;
                }
            }

            if (roundCount == 0) return 0.0;

            return totalScore / roundCount;
        }

        internal double IndividualRecordRatioForYear(Year year)
        {
            var record = this.IndividualRecordForYear(year);

            double totalWins = record[0] + (record[2] / 2.0);
            double totalWeeks = record[0] + record[1] + record[2];

            if (totalWeeks == 0) return 0;

            return totalWins / totalWeeks;
        }

        public double[] IndividualRecordForYear(Year year)
        {
            var results = this.AllResultsForYear(year);
            int wins = 0, losses = 0, ties = 0;

            foreach (var result in results)
            {
                if (result.WasWin)
                {
                    wins++;
                }
                else if (result.WasLoss)
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

        internal int MostPointsInWeekForYear(Year year)
        {
            var results = this.AllResultsForYear(year);

            return results.Select(x => x.Points).Max();
        }

        internal double AverageMarginOfVictoryForYear(Year year)
        {
            var results = this.AllResultsForYear(year);
            if (results == null || results.Count() == 0)
            {
                return 0.0;
            }

            double totalMargin = 0;
            int roundCount = 0;
            int playerValue = 0, oppValue = 0;
            foreach (var result in results)
            {
                playerValue = result.ScoreDifference;
                oppValue = result.GetOpponentResult().ScoreDifference;
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

        internal double AverageMarginOfNetVictoryForYear(Year year)
        {
            var results = this.AllResultsForYear(year);
            if (results == null || results.Count() == 0)
            {
                return 0.0;
            }

            double totalMargin = 0;
            int roundCount = 0;
            int playerValue = 0, oppValue = 0;
            foreach (var result in results)
            {
                playerValue = result.NetScoreDifference;
                oppValue = result.GetOpponentResult().NetScoreDifference;
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

