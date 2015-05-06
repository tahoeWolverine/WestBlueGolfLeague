using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Responses.Admin;
using WestBlueGolfLeagueWeb.Models.Responses;
using System.Threading.Tasks;
using WestBlueGolfLeagueWeb.Models.Responses.Schedule;

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

            // TODO: need two new validators still
            // 1. need a validator that makes sure a player hasn't already played this week in another matchup
            // 2. need to validate that a requested player is even in the requested year.
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

        private bool ShouldCreateResult(ResultWebResponse clientResult)
        {
            return clientResult != null && clientResult.PlayerId.HasValue && clientResult.PlayerId != 0;
        }

        private result CreateNewResult(match parentMatch, int teamId, ResultWebResponse clientResult, year year, int priorHandicap)
        {
            return new result 
            { 
                match = parentMatch, 
                score = clientResult.Score, 
                points = clientResult.Points, 
                scoreVariant = clientResult.EquitableScore, 
                priorHandicap = priorHandicap,
                teamId = teamId, 
                year = year, 
                playerId = clientResult.PlayerId.Value 
            };
        }

        private async Task<IDictionary<int, player>> GetPlayersLookup(WestBlue db)
        {
            var allPlayerIds = new LinkedList<int>();

            foreach (var m in this.teamMatchupWithMatches.Matches)
            {
                if (m.Result1 != null && m.Result1.PlayerId.HasValue) 
                {
                    allPlayerIds.AddLast(m.Result1.PlayerId.Value);
                }

                if (m.Result2 != null && m.Result2.PlayerId.HasValue)
                {
                    allPlayerIds.AddLast(m.Result2.PlayerId.Value);
                }
            }

            var allRequiredPlayers = await db.players.Where(x => allPlayerIds.Contains(x.id)).ToListAsync();

            return allRequiredPlayers.ToDictionary(x => x.id, x => x);
        }

        private bool IsEmptyClientMatch(MatchWebResponse clientMatch)
        {
            return clientMatch == null || (clientMatch.Result1 == null && clientMatch.Result2 == null);
        }

        private void DeletePreviousData(WestBlue db, teammatchup teamMatchup)
        {
            var resultsToDelete = new List<result>();

            foreach (var m in teamMatchup.matches)
            {
                resultsToDelete.AddRange(m.results);
            }

            db.results.RemoveRange(resultsToDelete);
            db.matches.RemoveRange(teamMatchup.matches);
        }

        public async Task<teammatchup> SaveScoresAsync(WestBlue db)
        {
            // if for some reason there are no matches, we don't gotta do nothin.
            if (this.teamMatchupWithMatches.Matches == null || this.teamMatchupWithMatches.Matches.Count() == 0) 
            {
                return null;
            }

            var teamMatchup = await db.teammatchups.Include(x => x.matches).Include("matches.results").FirstOrDefaultAsync(x => x.id == this.teamMatchupWithMatches.Id);

            if (teamMatchup == null) { throw new ArgumentException("Requested team matchup does not exist."); }

            // delete any matches currently attached to the teammatchup.
            this.DeletePreviousData(db, teamMatchup);

            var playersLookup = await GetPlayersLookup(db);

            var matchList = this.teamMatchupWithMatches.Matches.ToList();

            for (int i = 0; i < matchList.Count; i++)
            {
                var clientMatch = matchList[i];

                if (IsEmptyClientMatch(clientMatch)) { continue; }

                var newMatch = new match { matchOrder = i, teamMatchupId = teamMatchup.id };

                if (ShouldCreateResult(clientMatch.Result1)) 
                {
                    var player = playersLookup[clientMatch.Result1.PlayerId.Value];

                    // TODO: Fix prior handicap calculation. Setting it to 0 here.  It is updated in leaderboard caclculation currently.
                    newMatch.results.Add(this.CreateNewResult(newMatch, this.teamMatchupWithMatches.Team1.Id, clientMatch.Result1, this.week.year, player.currentHandicap));
                    newMatch.players.Add(player);
                }

                if (ShouldCreateResult(clientMatch.Result2)) 
                {
                    var player = playersLookup[clientMatch.Result2.PlayerId.Value];

                    // TODO: Fix prior handicap calculation. Setting it to 0 here.  It is updated in leaderboard caclculation currently.
                    newMatch.results.Add(this.CreateNewResult(newMatch, this.teamMatchupWithMatches.Team2.Id, clientMatch.Result2, this.week.year, player.currentHandicap));
                    newMatch.players.Add(player);
                }

                teamMatchup.matches.Add(newMatch);
            }

            if (teamMatchup.matches.All(x => x.IsComplete()))
            {
                teamMatchup.matchComplete = true;
            }

            await db.SaveChangesAsync();

            return teamMatchup;
        }

        public List<string> Errors { get; private set; }
        public bool IsValid { get; private set; }
    }
}