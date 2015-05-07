namespace WestBlueGolfLeagueWeb.Models.Entities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;
    using System.Linq;

    [Table("westbluegolf.teammatchup")]
    public partial class teammatchup
    {
        private static readonly string[] TeeTimes = new string[] { "3:44 (3:52)", "4:00 (4:08)", "4:16 (4:24)", "4:32 (4:40)", "4:48 (4:56)", "n/a" };

        public teammatchup()
        {
            matches = new HashSet<match>();
            teams = new HashSet<team>();
        }

        public int id { get; set; }

        [StringLength(75)]
        public string playoffType { get; set; }

        public int weekId { get; set; }

        public bool matchComplete { get; set; }

        public int? startTimeId { get; set; }

        public int? matchId { get; set; }

        // should really be called matchupOrder :\
        public int? matchOrder { get; set; }

        [StringLength(45)]
        public string matchupType { get; set; }

        public virtual ICollection<match> matches { get; set; }

        public virtual starttime starttime { get; set; }

        public virtual week week { get; set; }

        public virtual ICollection<team> teams { get; set; }

        private int? pointsForTeam(int teamIndex)
        {
            if (this.teams.Count < teamIndex + 1)
            {
                return 0;
            }

            int? points = 0;
            var t = this.teams.ElementAt(teamIndex);
            foreach (match m in this.matches)
            {
                foreach (result r in m.results)
                {
                    if (r.team.id == t.id)
                    {
                        points += r.points;
                    }
                }
            }
            return points;
        }

        public string teeTimeText()
        {
            return this.matchOrder == null ? "n/a" : TeeTimes[this.matchOrder.Value];
        }

        public bool team1Won()
        {
            return this.pointsForTeam(0) > 48;
        }

        public bool team2Won()
        {
            return this.pointsForTeam(1) > 48;
        }
    }
}
