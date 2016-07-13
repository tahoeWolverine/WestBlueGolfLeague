using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.MappedEntities
{
    public class FlattenedResult
    {
        public int Id { get; set; }

        public bool ParentMatchComplete { get; set; }

        public int MatchId { get; set; }

        public int WeekId { get; set; }

        public int MatchOrder { get; set; }

        public int TeamMatchupId { get; set; }

        public int? Score { get; set; }

        public int? Points { get; set; }

        public int? ScoreVariant { get; set; }

        public string PlayerName { get; set; }

        public int? PriorHandicap { get; set; }
    }
}