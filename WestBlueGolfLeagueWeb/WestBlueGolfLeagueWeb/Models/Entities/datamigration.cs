namespace WestBlueGolfLeagueWeb.Models.Entities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("westbluegolf.datamigration")]
    public partial class datamigration
    {
        public int id { get; set; }

        public DateTime dataMigrationDate { get; set; }

        [StringLength(200)]
        public string notes { get; set; }

        public int yearId { get; set; }

        public virtual year year { get; set; }
    }
}
