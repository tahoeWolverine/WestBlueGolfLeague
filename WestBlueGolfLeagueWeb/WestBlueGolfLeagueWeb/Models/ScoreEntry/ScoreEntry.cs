using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Responses.Admin;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    /// <summary>
    /// The job of this class is to get our web entity back in to a teamMatchup as well
    /// as do validation.
    /// </summary>
    public class ScoreEntry
    {
        private TeamMatchupWithMatches teamMatchupWithMatches;
        private week week;

        public ScoreEntry(TeamMatchupWithMatches teamMatchupWithMatches, week week)
        {
            this.teamMatchupWithMatches = teamMatchupWithMatches;
            this.week = week;

            this.Errors = new List<string>();

            this.Validate();
        }

        private void Validate()
        {
            // Don't do any validation if there are no matches or proposed matches to validate!
            if (this.teamMatchupWithMatches.Matches == null || this.teamMatchupWithMatches.Matches.Count() == 0)
            {
                this.IsValid = true;
                return;
            }

            IEnumerable<ScoreEntryValidators.ScoreValidator> scoreValidators = 
                new List<ScoreEntryValidators.ScoreValidator> 
                { 
                    ScoreEntryValidators.DuplicatePlayerValidator,
                    ScoreEntryValidators.VerifyTotalPoints,
                    ScoreEntryValidators.VerifyMatchComplete,
                    ScoreEntryValidators.CheckEquitableScores,
                };

            var scoreEntryInfo = new ScoreEntryInfo { TeamMatchupWithMatches = this.teamMatchupWithMatches, Week = this.week };

            foreach (var sv in scoreValidators)
            {
                var validatorErrors = sv(scoreEntryInfo);

                if (validatorErrors != null)
                {
                    this.Errors.AddRange(validatorErrors);
                }
            }

            this.IsValid = this.Errors.Count == 0;
        }

        public void SaveScores()
        {

        }

        public List<string> Errors { get; private set; }
        public bool IsValid { get; private set; }
    }
}