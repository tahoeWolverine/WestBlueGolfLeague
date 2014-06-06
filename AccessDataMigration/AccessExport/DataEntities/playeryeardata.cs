namespace AccessExport.DataEntities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("westbluegolf.playeryeardata")]
    public partial class playeryeardata
    {
        public int id { get; set; }

        public bool isRookie { get; set; }

        public int startingHandicap { get; set; }

        public int finishingHandicap { get; set; }

        public int playerId { get; set; }

        public int yearId { get; set; }

        public int teamId { get; set; }

        public int week0Score { get; set; }

        public virtual player player { get; set; }

        public virtual year year { get; set; }

        public virtual team team { get; set; }
    }
}
