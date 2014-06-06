namespace AccessExport.DataEntities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("westbluegolf.year")]
    public partial class year
    {
        public year()
        {
            datamigrations = new HashSet<datamigration>();
            leaderboarddatas = new HashSet<leaderboarddata>();
            playeryeardatas = new HashSet<playeryeardata>();
            results = new HashSet<result>();
            weeks = new HashSet<week>();
        }

        public int id { get; set; }

        public int value { get; set; }

        public bool isComplete { get; set; }

        public virtual ICollection<datamigration> datamigrations { get; set; }

        public virtual ICollection<leaderboarddata> leaderboarddatas { get; set; }

        public virtual ICollection<playeryeardata> playeryeardatas { get; set; }

        public virtual ICollection<result> results { get; set; }

        public virtual ICollection<week> weeks { get; set; }
    }
}
