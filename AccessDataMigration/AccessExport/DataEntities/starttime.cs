namespace AccessExport.DataEntities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("westbluegolf.starttime")]
    public partial class starttime
    {
        public starttime()
        {
            teammatchups = new HashSet<teammatchup>();
        }

        public int id { get; set; }

        [Required]
        [StringLength(45)]
        public string time { get; set; }

        [Column("startTime")]
        public DateTime startTime1 { get; set; }

        public virtual ICollection<teammatchup> teammatchups { get; set; }
    }
}
