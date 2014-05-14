namespace WestBlueGolfLeagueWeb.Models.Entities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("westbluegolf.leaderboard")]
    public partial class leaderboard
    {
        public leaderboard()
        {
            leaderboarddatas = new HashSet<leaderboarddata>();
        }

        public int id { get; set; }

        [Required]
        [StringLength(100)]
        public string name { get; set; }

        public bool isPlayerBoard { get; set; }

        public int priority { get; set; }

        [Required]
        [StringLength(50)]
        public string key { get; set; }

        public virtual ICollection<leaderboarddata> leaderboarddatas { get; set; }
    }
}
