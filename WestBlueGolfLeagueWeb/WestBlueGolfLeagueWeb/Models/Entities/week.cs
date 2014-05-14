namespace WestBlueGolfLeagueWeb.Models.Entities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("westbluegolf.week")]
    public partial class week
    {
        public week()
        {
            teammatchups = new HashSet<teammatchup>();
        }

        public int id { get; set; }

        [Column(TypeName = "date")]
        public DateTime date { get; set; }

        public int courseId { get; set; }

        public int yearId { get; set; }

        public bool isBadData { get; set; }

        public int seasonIndex { get; set; }

        public virtual course course { get; set; }

        public virtual ICollection<teammatchup> teammatchups { get; set; }

        public virtual year year { get; set; }
    }
}
