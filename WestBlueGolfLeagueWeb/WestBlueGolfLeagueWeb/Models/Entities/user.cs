namespace WestBlueGolfLeagueWeb.Models.Entities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("westbluegolf.user")]
    public partial class user
    {
        [DatabaseGenerated(DatabaseGeneratedOption.None)]
        public int id { get; set; }

        [Required]
        [StringLength(100)]
        public string username { get; set; }

        [Required]
        [StringLength(200)]
        public string passwordHash { get; set; }

        [Required]
        [StringLength(45)]
        public string salt { get; set; }

        public DateTime dateAdded { get; set; }

        [StringLength(120)]
        public string email { get; set; }
    }
}
