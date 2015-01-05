using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;

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
                        .Where(x => includeInvalidPlayers ? true : x.player.validPlayer)
                        .Select(x => Tuple.Create(x.player, x.team));
        }

        public static IEnumerable<leaderboarddata> GetCurrentTeamRankingForYear(this WestBlue westBlue, int year)
        {
            return westBlue.leaderboarddatas.Include(x => x.leaderboard).Where(x => x.year.value == year).ToList().OrderBy(x => x.rank);
        }

        public static int PointsFor(this teammatchup tm, team team)
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

        public static int ScoreDifference(this result r)
        {
            return r.score - r.match.teammatchup.week.course.par;
        }

        public static int NetScoreDifference(this result r)
        {
            return r.ScoreDifference() - r.priorHandicap;
        }
    }
}