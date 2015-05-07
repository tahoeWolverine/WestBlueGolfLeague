using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Responses.Player
{
    public class PlayerProfileData
    {
        public string PlayerName { get; set; }
        public string Handicap { get; set; }
        public string LowScore { get; set; }
        public string AveragePoints { get; set; }
        public string LowNet { get; set; }
        public string Improved { get; set; }
        public IEnumerable<PlayerProfileResult> ResultsForYear { get; set; }
        public IEnumerable<PlayerProfileResult> CompleteResultsForYear { get; set; }
        public IEnumerable<PlayerProfileResult> IncompleteResultsForYear { get; set; }
        public int[] RecordForYear
        {
            get
            {
                var results = this.CompleteResultsForYear;

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

        public string RecordString
        {
            get
            {
                int[] record = this.RecordForYear;
                string ties = record.Length > 2 && record[2] > 0 ? "-" + record[2] : "";
                return record[0] + "-" + record[1] + ties;
            }
        }
    }
}