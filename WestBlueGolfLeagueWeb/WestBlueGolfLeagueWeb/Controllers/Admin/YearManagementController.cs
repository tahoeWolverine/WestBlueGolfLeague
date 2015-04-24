using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http;
using WestBlueGolfLeagueWeb.Models.Admin;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Responses;
using WestBlueGolfLeagueWeb.Models.Schedule;

namespace WestBlueGolfLeagueWeb.Controllers.Admin
{
    [Authorize(Roles = AdminRole.Admin.Name)]
    public class YearManagementController : WestBlueDbApiController
    {
        public YearManagementController()
            : base(true)
        {

        }

        public async Task<IHttpActionResult> AddPlayer(AddPlayerRequest addPlayerRequest)
        {
            int currentYear = this.CurrentYear;

            var yearTask = this.Db.years.Where(x => x.value == currentYear).FirstOrDefaultAsync();
            var teamTask = this.Db.teams.Where(x => x.id == addPlayerRequest.TeamId).FirstOrDefaultAsync();

            var playerTask = this.Db.players.Where(x => string.Equals(x.name, addPlayerRequest.PlayerName, StringComparison.OrdinalIgnoreCase)).FirstOrDefaultAsync();

            await Task.WhenAll(yearTask, teamTask, playerTask);

            if (playerTask.Result != null)
            {
                return InternalServerError(new ArgumentException("Can't add a player with the same name."));
            }

            if (teamTask == null)
            {
                return InternalServerError(new ArgumentException("Team with specified id does not exist."));
            }

            var newPlayer = new player { validPlayer = true, name = addPlayerRequest.PlayerName, currentHandicap = addPlayerRequest.Handicap };

            var newPyd = new playeryeardata
                                {
                                    isRookie = true,
                                    year = yearTask.Result,
                                    team = teamTask.Result,
                                    player = newPlayer,
                                    week0Score = addPlayerRequest.Handicap + 36,
                                    startingHandicap = addPlayerRequest.Handicap,
                                    finishingHandicap = addPlayerRequest.Handicap
                                };

            this.Db.playeryeardatas.Add(newPyd);

            await this.Db.SaveChangesAsync();

            return Ok();
        }

        [HttpGet]
        public async Task<IHttpActionResult> YearWizardInfo()
        {
            int currYear = this.CurrentYear;

            var teams = await this.Db.teamyeardatas.Include(x => x.team).Include(x => x.year).Where(x => x.year.value >= currYear - 2).ToListAsync();

            var sortedUniqueTeams = teams.Where(x => x.team.validTeam).OrderByDescending(x => x.year.value).GroupBy(x => x.team.id).Select(x => x.First()).Select(x => x.team);

            return Ok(new { teams = sortedUniqueTeams.Select(x => TeamResponse.From(x)) });
        }

        [HttpPost]
        public async Task<IHttpActionResult> SaveYear(CreateYearRequest request)
        {
            IEnumerable<team> createdTeams = new LinkedList<team>();

            // create new teams (if needed)
            if (request.TeamsToCreate != null && request.TeamsToCreate.Count > 0)
            {
                createdTeams = request.TeamsToCreate.Select(x => new team { validTeam = true, teamName = x });
            }

            try
            {
                // get teams
                var selectedTeams = this.Db.teams.Where(x => request.TeamIds.Contains(x.id)).ToListAsync();

                // get possible pairings
                var pairings = this.Db.pairings.ToListAsync();

                // Get courses to rotate.
                List<string> courseNames = new List<string> { "Silver Front", "Silver Back", "Gold Front", "Gold Back" };
                var courses = this.Db.courses.Where(x => courseNames.Contains(x.name)).OrderBy(x => x.id).ToListAsync();

                await Task.WhenAll(selectedTeams, pairings, courses);

                var allTeams = selectedTeams.Result.Concat(createdTeams);

                // create schedule (weeks, team match ups, etc).
                GolfYear golfYear = new GolfYear(allTeams, request.SelectedDates, pairings.Result, courses.Result);

                golfYear.PersistSchedule(this.Db);

                var newPlayers = await this.SaveRoster(request.Roster, allTeams, golfYear.CreatedYear);

                // only save once
                await this.Db.SaveChangesAsync();
            }
            catch (Exception e)
            {
                return this.InternalServerError(e);
            }

            return Ok();
        }

        // TODO: maybe move this in to golf year stuff?  This is nastyyyy
        private async Task<IEnumerable<string>> SaveRoster(string roster, IEnumerable<team> teams, year yearToSave)
        {
            if (string.IsNullOrEmpty(roster))
            {
                return new LinkedList<string>();
            }

            using (RosterReader rosterReader = new RosterReader(new MemoryStream(Encoding.UTF8.GetBytes(roster))))
            {
                var rosters = rosterReader.GetRoster(teams);

                // This fetches all players from the previous two years, as they may be in the league again this year.
                RosterInitializer rosterInitializer =
                    new RosterInitializer(rosters, await this.Db.players.Where(x => x.playeryeardatas.Any(y => y.year.value > yearToSave.value - 3)).ToListAsync(), yearToSave);

                rosterInitializer.PersistRosters(this.Db);

                return rosterInitializer.NewPlayers;
            }
        }

        [HttpPost]
        public async Task<IHttpActionResult> DeleteYear()
        {
            int yearToDelete = this.CurrentYear;

            var teamMatchupsToRemove =
                await this.Db.teammatchups.Include(x => x.teams).Where(x => x.week.year.value == yearToDelete).ToListAsync();

            foreach (var tm in teamMatchupsToRemove)
            {
                foreach (var team in tm.teams)
                {
                    team.teammatchups.Remove(tm);
                }
            }

            // fetch all teams toat will be "orphaned" by the delete (any teams that are new to the year being deleted).
            var teamsToDelete = await this.Db.teams.Where(x => x.teamyeardata.Any(y => y.year.value == yearToDelete) && x.teamyeardata.Count() == 1 && x.validTeam).ToListAsync();

            this.Db.teamyeardatas.RemoveRange(await this.Db.teamyeardatas.Where(x => x.year.value == yearToDelete).ToListAsync());

            // Delete teams that will be "orphaned" by this delete.
            this.Db.teams.RemoveRange(teamsToDelete);
            this.Db.teammatchups.RemoveRange(teamMatchupsToRemove);
            this.Db.weeks.RemoveRange(await this.Db.weeks.Where(x => x.year.value == yearToDelete).ToListAsync());
            this.Db.years.RemoveRange(await this.Db.years.Where(x => x.value == yearToDelete).ToListAsync());

            await this.Db.SaveChangesAsync();

            return StatusCode(HttpStatusCode.NoContent);
        }
    }
}