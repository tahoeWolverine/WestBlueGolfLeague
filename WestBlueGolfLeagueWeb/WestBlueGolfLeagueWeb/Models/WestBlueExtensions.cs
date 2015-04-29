using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;
using System.Threading.Tasks;

namespace WestBlueGolfLeagueWeb.Models.Entities
{
    public static class WestBlueExtensions
    {
        public static IEnumerable<Tuple<player, team>> GetPlayersWithTeamsForYear(this WestBlue westBlue, int year, bool includeInvalidPlayers = false)
        {
            return westBlue.playeryeardatas
                        .Include(p => p.player)
                        .Include(p => p.team)
                        .AsNoTracking()
                        .Where(x => x.year.value == year)
                        .ToList()
                        .Where(x => includeInvalidPlayers || x.player.validPlayer)
                        .Select(x => Tuple.Create(x.player, x.team));
        }

        public static IEnumerable<team> GetTeamsForYear(this WestBlue westBlue, int year)
        {
            return westBlue.teams
                        .AsNoTracking()
                        .Where(x => x.validTeam == true && x.teamyeardata.Any(y => y.year.value == year))
                        .ToList();
        }

        public static async Task<IEnumerable<week>> GetWeeksWithMatchUpsForYearAsync(this WestBlue westBlue, int year)
        {
            var weeks = await westBlue.weeks
                .Include(x => x.teammatchups)
                .Include("teammatchups.teams")
                .Include(x => x.pairing)
                .Include(x => x.course)
                .Where(x => x.year.value == year)
                .OrderBy(x => x.date).AsNoTracking().ToListAsync();

            return weeks;
        }

        public static IEnumerable<leaderboarddata> GetCurrentTeamRankingForYear(this WestBlue westBlue, int year)
        {
            return westBlue.leaderboarddatas.Include(x => x.leaderboard).Where(x => x.year.value == year).ToList().OrderBy(x => x.rank);
        }

        public static int? PointsFor(this teammatchup tm, team team)
        {
            return tm.matches.Select(x => x.results.First(r => r.teamId == team.id)).Sum(x => x.points);
        }

        public static bool WasWin(this result r)
        {
            return r.points > 12;
        }

        public static bool WasLoss(this result r)
        {
            return r.points < 12;
        }

        public static result OpponentResult(this result r)
        {
            return r.match.results.First(x => x.id != r.id);
        }

        public static int? ScoreDifference(this result r)
        {
            return r.score - r.match.teammatchup.week.course.par;
        }

        public static int? NetScoreDifference(this result r)
        {
            return r.ScoreDifference() - r.priorHandicap;
        }


    }
}