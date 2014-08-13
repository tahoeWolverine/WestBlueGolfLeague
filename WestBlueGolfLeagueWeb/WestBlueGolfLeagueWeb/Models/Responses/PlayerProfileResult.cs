using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class PlayerProfileResult
    {
        public PlayerProfileResult(player p, result r)
        {
            this.PriorHandicapForOpponent = r.matchup.results.First(x => x.playerId != p.id).priorHandicap;
            this.PriorHandicapForPlayer = r.matchup.results.First(x => x.playerId == p.id).priorHandicap;
            this.WeekIndex = r.matchup.teammatchup.week.seasonIndex;
            this.OpponentName = r.matchup.results.First(x => x.playerId != p.id).player.name;
            this.WeekDate = r.matchup.teammatchup.week.date;
        }

        public string OpponentName { get; set; }
        public int WeekIndex { get; set; }
        public int PriorHandicapForPlayer { get; set; }
        public int PriorHandicapForOpponent { get; set; }


        public DateTime WeekDate { get; set; }
    }
}