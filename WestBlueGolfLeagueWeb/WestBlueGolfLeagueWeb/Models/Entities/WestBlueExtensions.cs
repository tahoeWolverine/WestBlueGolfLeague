using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;

namespace WestBlueGolfLeagueWeb.Models.Entities
{
    public static class WestBlueExtensions
    {
        public static IEnumerable<Tuple<player, team>> GetPlayersWithTeamsForYear(this WestBlue westBlue, int year = 0, bool includeInvalidPlayers = false)
        {
            if (year == 0)
            {
                year = DateTimeOffset.Now.Year;
            }

            return westBlue.playeryeardatas
                        .Include(p => p.player)
                        .Include(p => p.team)
                        .AsNoTracking()
                        .Where(x => x.year.value == year)
                        .ToList()
                        .Where(x => includeInvalidPlayers ? true : x.player.validPlayer)
                        .Select(x => Tuple.Create(x.player, x.team));
        }

    }
}