using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;

namespace WestBlueGolfLeagueWeb.Models.Entities
{
    public static class WestBlueExtensions
    {
        public static IEnumerable<player> GetPlayersForYear(this WestBlue westBlue, int year = 0, bool includeInvalidPlayers = false)
        {
            if (year == 0)
            {
                year = DateTimeOffset.Now.Year;
            }

            return westBlue.playeryeardatas
                        .Include(p => p.player)
                        .AsNoTracking()
                        .Where(x => x.year.value == year)
                        .Select(x => x.player)
                        .Where(x => includeInvalidPlayers ? true : x.validPlayer)
                        .ToList();
        }
    }
}