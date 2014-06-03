namespace AccessExport.DataEntities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("westbluegolf.team")]
    public partial class team
    {
        public team()
        {
            leaderboarddatas = new HashSet<leaderboarddata>();
            playeryeardatas = new HashSet<playeryeardata>();
            results = new HashSet<result>();
            teammatchups = new HashSet<teammatchup>();
        }

        public int id { get; set; }

        [Required]
        [StringLength(120)]
        public string teamName { get; set; }

        public bool validTeam { get; set; }

        public DateTime? modifiedDate { get; set; }

        public virtual ICollection<leaderboarddata> leaderboarddatas { get; set; }

        public virtual ICollection<playeryeardata> playeryeardatas { get; set; }

        public virtual ICollection<result> results { get; set; }

        public virtual ICollection<teammatchup> teammatchups { get; set; }
    }
}
