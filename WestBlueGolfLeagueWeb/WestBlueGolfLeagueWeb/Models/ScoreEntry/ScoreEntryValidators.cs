using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Responses;
using WestBlueGolfLeagueWeb.Models.Responses.Admin;
using WestBlueGolfLeagueWeb.Models.Responses.Schedule;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    public static class ScoreEntryValidators
    {
        public delegate IEnumerable<string> ScoreValidator(ScoreEntryInfo scoreEntryInfo);

        private static bool TryAddToSet(HashSet<int> set, int playerId)
        {
            if (playerId < 3) { return true; }

            if (set.Contains(playerId))
            {
                return false;
            }

            set.Add(playerId);
            return true;
        }

        public static IEnumerable<string> DuplicatePlayerValidator(ScoreEntryInfo scoreEntryInfo)
        {
            HashSet<int> playerIdsForTeam1 = new HashSet<int>();
            HashSet<int> playerIdsForTeam2 = new HashSet<int>();

            string errorMessage = "A player can only play once per team matchup. Verify that each player is only playing once.";

            foreach (var match in scoreEntryInfo.TeamMatchupWithMatches.Matches)
            {
                int team1PlayerId = match.Result1 == null || !match.Result1.PlayerId.HasValue ? -1 : match.Result1.PlayerId.Value;
                int team2PlayerId = match.Result2 == null || !match.Result2.PlayerId.HasValue ? -1 : match.Result2.PlayerId.Value;

                // players 1 and 2 are special no show players.
                bool error = !TryAddToSet(playerIdsForTeam1, team1PlayerId) || !TryAddToSet(playerIdsForTeam2, team2PlayerId);

                if (error)
                {
                    return new List<string> { errorMessage };
                }
            }

            return new LinkedList<string>();
        }

        public static IEnumerable<string> CheckEquitableScores(ScoreEntryInfo scoreEntryInfo)
        {
            foreach (var match in scoreEntryInfo.TeamMatchupWithMatches.Matches)
            {
                bool error = !VerifyEquitableScore(match.Result1) || !VerifyEquitableScore(match.Result2);

                if (error) { return new List<string> { "Equitable scores must be less than or equal to scores." }; }
            }

            return new string[0];
        }

        private static bool VerifyEquitableScore(ResultWebResponse result)
        {
            if (result == null) { return true; }

            if (result.EquitableScore.HasValue)
            {
                return result.EquitableScore.Value <= result.Score;
            }

            // escore is allowed to be null.
            return true;
        }

        private static bool ResultContainScores(ResultWebResponse result)
        {
            if (result == null) { return false; }
            if (result.Score != null || result.Points != null || result.EquitableScore != null) { return true; }
            return false;
        }

        /// <summary>
        /// Note that years > 2014 MUST have escore populated given current rules.
        /// prior years don't care about escore.
        /// </summary>
        private static bool IsMatchValid(MatchWebResponse match, int year)
        {
            if (match.Result1 == null && match.Result2 == null)
            {
                return true;
            }

            if (!ResultContainScores(match.Result1) && !ResultContainScores(match.Result2))
            {
                return true;
            }

            if ((ResultContainScores(match.Result1) && !ResultContainScores(match.Result2)) ||
                !ResultContainScores(match.Result1) && ResultContainScores(match.Result2))
            {
                return false;
            }

            int?[] valsToCheck = new int?[] 
                                { 
                                    match.Result1.Score, match.Result1.Points, year < 2015 ? 0 : match.Result1.EquitableScore, 
                                    match.Result2.Score, match.Result2.Points, year < 2015 ? 0 : match.Result2.EquitableScore 
                                };

            bool nullEncounterd = false;
            bool nonNullEncountered = false;

            foreach (int? val in valsToCheck)
            {
                if (val != null)
                {
                    nonNullEncountered = true;
                }
                else
                {
                    nullEncounterd = true;
                }
            }

            return !(nonNullEncountered && nullEncounterd);
        }

        public static IEnumerable<string> VerifyMatchComplete(ScoreEntryInfo scoreEntryInfo)
        {
            foreach (var match in scoreEntryInfo.TeamMatchupWithMatches.Matches)
            {
                if (!IsMatchValid(match, scoreEntryInfo.Week.year.value))
                {
                    return new string[] { "Must have valid score, points, and equitable score for all players in a match." };
                }
            }

            return new string[0];
        }

        public static IEnumerable<string> VerifyTotalPoints(ScoreEntryInfo scoreEntryInfo)
        {
            bool greaterThan24Error = false;
            bool mustBe24Error = false;

            foreach (var match in scoreEntryInfo.TeamMatchupWithMatches.Matches)
            {
                if (!IsMatchValid(match, scoreEntryInfo.Week.year.value)) 
                {
                    // other validators will take care of messaging.
                    continue;
                }

                // don't try to add points if the results don't contain scores.
                if (!(ResultContainScores(match.Result1) && ResultContainScores(match.Result2))) 
                {
                    continue;
                }

                if (match.Result1.Points + match.Result2.Points > 24)
                {
                    greaterThan24Error = true;
                }

                bool canBeLessThan24 = false;

                if (match.Result1.PlayerId < 3 || match.Result2.PlayerId < 3)
                {
                    canBeLessThan24 = true;
                }

                if (match.Result1.Points + match.Result2.Points < 24 && !canBeLessThan24)
                {
                    mustBe24Error = true;
                }
            }

            List<string> errors = new List<string>(2);

            if (mustBe24Error)
            {
                errors.Add("When neither player is a sub/no show, total points for a match must equal 24.");
            }

            if (greaterThan24Error)
            {
                errors.Add("Total points in a match can not be greater than 24.");
            }

            return errors;
        }
    }
}