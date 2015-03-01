using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Entities
{
    [Table("westbluegolf.notes")]
    public class note
    {
        public int id { get; set; }

        [Required]
        public string text { get; set; }

        [Column(TypeName = "datetime")]
        public DateTime date { get; set; }
    }
}