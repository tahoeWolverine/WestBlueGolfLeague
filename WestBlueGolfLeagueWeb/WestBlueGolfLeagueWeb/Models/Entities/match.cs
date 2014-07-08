namespace WestBlueGolfLeagueWeb.Models.Entities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("westbluegolf.match")]
    public partial class match
    {
        public match()
        {
            results = new HashSet<result>();
            players = new HashSet<player>();
        }

        public int id { get; set; }

        public int teamMatchupId { get; set; }

        public virtual teammatchup teammatchup { get; set; }

        public virtual ICollection<result> results { get; set; }

        public virtual ICollection<player> players { get; set; }
    }
}
