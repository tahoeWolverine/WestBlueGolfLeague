namespace AccessExport.DataEntities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("westbluegolf.course")]
    public partial class course
    {
        public course()
        {
            weeks = new HashSet<week>();
        }

        public int id { get; set; }

        [Required]
        [StringLength(120)]
        public string name { get; set; }

        public int par { get; set; }

        [StringLength(80)]
        public string street { get; set; }

        [StringLength(45)]
        public string state { get; set; }

        [StringLength(12)]
        public string zip { get; set; }

        public virtual ICollection<week> weeks { get; set; }
    }
}
