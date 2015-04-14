namespace WestBlueGolfLeagueWeb.Models.Entities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("westbluegolf.result")]
    public partial class result
    {
        public int id { get; set; }

        public int priorHandicap { get; set; }

        public int score { get; set; }

		public int? scoreVariant { get; set; }

        public int points { get; set; }

        public int teamId { get; set; }

        public int playerId { get; set; }

        public int matchId { get; set; }

        public int yearId { get; set; }

        public virtual match match { get; set; }

        public virtual player player { get; set; }

        public virtual team team { get; set; }

        public virtual year year { get; set; }
    }
}
