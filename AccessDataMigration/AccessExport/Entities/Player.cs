using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    public class Player
    {
        private Team team;

        private List<YearData> yearData = new List<YearData>();

        private List<Result> allResults = new List<Result>();

        private int id;

        public Player(int id)
        {
            this.id = id;
        }

        public int Id { get { return this.id; } }

        public Team Team
        {
            get { return this.team; }
            set
            {
                if (this.team != null)
                {
                    if (value.Id != this.team.Id) 
                    {
                        // TODO: Anything special to do with switched teams??
                        //Console.WriteLine("Switched team: " + this.Name);
                    }

                    this.team.RemovePlayer(this);
                }

                value.AddPlayer(this); this.team = value;
            }
        }
        public string Name { get; set; }
        public int CurrentHandicap { get; set; }
        public bool ValidPlayer { get; set; }

        public IEnumerable<YearData> YearDatas { get { return this.yearData; } }

        public void AddYearData(YearData yearData)
        {
            this.yearData.Add(yearData);
        }

        public void AddResult(Result result)
        {
            this.allResults.Add(result);
        }

        public IEnumerable<Result> AllResults { get { return this.allResults; } }

        public IEnumerable<Result> AllResultsForYear(Year year)
        {
            return this.allResults.Where(x => x.Year.Value == year.Value);
        }

        public int ImprovedInYear(Year year)
        {
            // There should always be a year data for the year passed in.
            var ydForYear = this.yearData.First(yd => yd.Year.Value == year.Value);
            int starting = ydForYear.StartingHandicap;

            int ending = year.NewestYear ? this.CurrentHandicap : ydForYear.FinishingHandicap;

            return ending - starting;
        }

        public double LowRoundForYear(Year year)
        {
            var bestScore = this.AllResultsForYear(year).OrderBy(x => x.Score).FirstOrDefault();

            if (bestScore == null)
            {
                return 99;
            }

            return bestScore.Score;
        }

        public double LowNetForYear(Year year)
        {
            var results = this.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 10;

            int lowNet = 100;
            foreach (var result in results)
            {
                int netScoreDifference = result.NetScoreDifference;
                if (netScoreDifference < lowNet)
                {
                    lowNet = netScoreDifference;
                }
            }

            return lowNet;
        }

        public double FinishingHandicapInYear(Year year)
        {
            // Should only be called with a valid year... will blow up otherwise.
            var yd = this.yearData.First(x => x.Year.Value == year.Value);

            return yd.FinishingHandicap;
        }

        public double AveragePointsInYear(Year year)
        {
            var results = this.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

            int totalPoints = 0;
            foreach (var result in results)
            {
                totalPoints += result.Points;
            }

            return (double)totalPoints / (double)results.Count();
        }

        public double RecordRatioForYear(Year year)
        {
            var record = this.RecordForYear(year);
            double totalWins = record[0] + ((double)record[2] / 2);
            int totalMatches = record[0] + record[1] + record[2];

            return totalMatches == 0 ? 0.0 : totalWins / (double)totalMatches;
        }

        public int[] RecordForYear(Year year)
        {
            var results = this.AllResultsForYear(year);

            int wins = 0, losses = 0, ties = 0;

            foreach (var result in results)
            {
                if (result.WasWin) wins++;
                else if (result.WasLoss) losses++;
                else ties++;
            }

            return new int[] { wins, losses, ties };
        }


        public double AverageOpponentScoreForYear(Year year)
        {
            var results = this.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

            double totalOpponentScore = 0;
            int opponentCount = 0;
            int value = 0;
            foreach (var result in results)
            {
                value = result.GetOpponentResult().ScoreDifference;
                if (value < 60)
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

        public double AverageOpponentNetScoreForYear(Year year)
        {
            var results = this.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

            double totalOpponentScore = 0;
            int opponentCount = 0;
            int value = 0;
            foreach (var result in results)
            {
                value = result.GetOpponentResult().NetScoreDifference;
                if (value < 60)
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

        public double AverageScoreForYear(Year year)
        {
            var results = this.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

            double totalRoundScore = 0;
            int roundCount = 0;
            foreach (var result in results)
            {
                totalRoundScore += result.ScoreDifference;
                roundCount++;
            }

            if (roundCount == 0)
            {
                return 0.0;
            }

            return totalRoundScore / (double)roundCount;
        }

        public double AverageNetScoreForYear(Year year)
        {
            var results = this.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

            double totalRoundScore = 0;
            int roundCount = 0;
            foreach (var result in results)
            {
                totalRoundScore += result.NetScoreDifference;
                roundCount++;
            }

            return (double)totalRoundScore / (double)roundCount;
        }

        public double MostPointsInMatchForYear(Year year)
        {
            var results = this.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

            int mostPoints = 0;
            foreach (var result in results)
            {
                if (result.Points > mostPoints)
                {
                    mostPoints = result.Points;
                }
            }

            return mostPoints;
        }


        public double TotalPointsForYear(Year year)
        {
            var results = this.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

            int totalPoints = 0;
            foreach (var result in results)
            {
                totalPoints += result.Points;
            }

            return totalPoints;
        }

        public double AverageMarginOfVictoryForYear(Year year)
        {
            var results = this.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

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

        public double AverageMarginOfNetVictoryForYear(Year year)
        {
            var results = this.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

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

        public double TotalRoundsForYear(Year year)
        {
            var record = this.RecordForYear(year);

            return record[0] + record[1] + record[2];
        }
    }
}
