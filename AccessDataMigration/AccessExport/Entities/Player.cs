using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    class Player
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
                if (this.team != null) this.team.RemovePlayer(this);

                value.AddPlayer(this); this.team = value;
            }
        }
        public string Name { get; set; }
        public int CurrentHandicap { get; set; }
        public bool ValidPlayer { get; set; }

        public IEnumerable<YearData> YearDatas { get { return this.yearData; } }

        internal void AddYearData(YearData yearData)
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

        internal int ImprovedInYear(Year year)
        {
            // There should always be a year data for the year passed in.
            var ydForYear = this.yearData.First(yd => yd.Year.Value == year.Value);
            int starting = ydForYear.StartingHandicap;

            int ending = year.NewestYear ? this.CurrentHandicap : ydForYear.FinishingHandicap;

            return ending - starting;
        }

        internal double LowRoundForYear(Year year)
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

        internal double FinishingHandicapInYear(Year year)
        {
            // Should only be called with a valid year... will blow up otherwise.
            var yd = this.yearData.First(x => x.Year.Value == year.Value);

            return yd.FinishingHandicap;
        }

        internal double AveragePointsInYear(Year year)
        {
            var results = this.AllResultsForYear(year);

            if (results == null || results.Count() == 0) return 0.0;

            int totalPoints = 0;
		    foreach (var result in results) {
			    totalPoints += result.Points;
		    }

		    return (double)totalPoints / (double)results.Count();
        }
    }
}
