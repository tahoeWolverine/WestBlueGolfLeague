namespace WestBlueGolfLeagueWeb.Models.Entities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("westbluegolf.teammatchup")]
    public partial class teammatchup
    {
        public teammatchup()
        {
            matchups = new HashSet<match>();
            teams = new HashSet<team>();
        }

        public int id { get; set; }

        [StringLength(75)]
        public string playoffType { get; set; }

        public int weekId { get; set; }

        public bool matchComplete { get; set; }

        public int? startTimeId { get; set; }

        public int? matchId { get; set; }

        public int? pairingId { get; set; }

        public virtual ICollection<match> matchups { get; set; }

        public virtual pairing pairing { get; set; }

        public virtual starttime starttime { get; set; }

        public virtual week week { get; set; }

        public virtual ICollection<team> teams { get; set; }
    }
}
