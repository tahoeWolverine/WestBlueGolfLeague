using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Entities
{
    [Table("westbluegolf.teamyeardata")]
    public class teamyeardata
    {
        public int id { get; set; }

        public int teamId { get; set; }

        public int yearId { get; set; }

        public virtual year year { get; set; }

        public virtual team team { get; set; }
    }
}