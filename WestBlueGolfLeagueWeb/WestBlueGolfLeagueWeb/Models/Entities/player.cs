namespace WestBlueGolfLeagueWeb.Models.Entities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("westbluegolf.player")]
    public partial class player
    {
        public player()
        {
            leaderboarddatas = new HashSet<leaderboarddata>();
            playeryeardatas = new HashSet<playeryeardata>();
            results = new HashSet<result>();
            matchups = new HashSet<matchup>();
        }

        public int id { get; set; }

        [Required]
        [StringLength(120)]
        public string name { get; set; }

        public int currentHandicap { get; set; }

        public bool favorite { get; set; }

        public int teamId { get; set; }

        public bool validPlayer { get; set; }

        public DateTime? modifiedDate { get; set; }

        public virtual ICollection<leaderboarddata> leaderboarddatas { get; set; }

        public virtual team team { get; set; }

        public virtual ICollection<playeryeardata> playeryeardatas { get; set; }

        public virtual ICollection<result> results { get; set; }

        public virtual ICollection<matchup> matchups { get; set; }
    }
}
