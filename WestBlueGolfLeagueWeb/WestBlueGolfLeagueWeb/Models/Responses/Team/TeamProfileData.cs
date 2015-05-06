using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Responses.Team
{
    public class TeamProfileData
    {
        public string TeamName { get; set; }
        public string AvgHandicap { get; set; }
        //public string LowScore { get; set; }
        public string TotalPoints { get; set; }
        //public string LowNet { get; set; }
        public string Improved { get; set; }
        public string WinLossRatio { get; set; }
        public string TotalWins { get; set; }
        public IEnumerable<TeamProfileResult> ResultsForYear { get; set; }
        public IEnumerable<TeamProfileResult> TeamMatchupsForYear { get; set; }

        public int[] IndividualRecordForYear
        {
            get
            {
                var results = this.ResultsForYear;

                int wins = 0, losses = 0, ties = 0;

                foreach (var result in results)
                {
                    if (result.WasWin) wins++;
                    else if (result.WasLoss) losses++;
                    else ties++;
                }

                return new int[] { wins, losses, ties };
            }
        }

        public string IndividualRecordString
        {
            get
            {
                int[] record = this.IndividualRecordForYear;
                string ties = record.Length > 2 && record[2] > 0 ? "-" + record[2] : "";
                return record[0] + "-" + record[1] + ties;
            }
        }
        public int[] WeekRecordForYear
        {
            get
            {
                var allResults = this.TeamMatchupsForYear;
                int wins = 0, losses = 0, ties = 0;

                int[] pointsForWeek = Enumerable.Repeat(0, 30).ToArray();

                foreach (var result in allResults)
                {
                    int seasonIndex = result.WeekIndex;

                    pointsForWeek[seasonIndex] = pointsForWeek[seasonIndex] + (int)result.Points;
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
        }

        public string WeekRecordString
        {
            get
            {
                int[] record = this.WeekRecordForYear;
                string ties = record.Length > 2 && record[2] > 0 ? "-" + record[2] : "";
                return record[0] + "-" + record[1] + ties;
            }
        }
    }
}