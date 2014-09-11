namespace WestBlueGolfLeagueWeb.Models.Entities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("westbluegolf.leaderboarddata")]
    public partial class leaderboarddata
    {
        public int id { get; set; }

        public int rank { get; set; }

        public double value { get; set; }

        public int leaderBoardId { get; set; }

        public int yearId { get; set; }

        public bool isPlayer { get; set; }

        public int? teamId { get; set; }

        public int? playerId { get; set; }

        [StringLength(100)]
        public string detail { get; set; }

        [Required]
        [StringLength(45)]
        public string formattedValue { get; set; }

        public virtual leaderboard leaderboard { get; set; }

        public virtual year year { get; set; }

        public virtual player player { get; set; }

        public virtual team team { get; set; }
    }
}
