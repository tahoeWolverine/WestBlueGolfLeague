using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    public class TeamMatchup
    {
        public int Id { get; set; }
        public Team Team1 { get; set; }
        public Team Team2 { get; set; }
        public bool MatchComplete { get; set; }
        public Week Week { get; set; }
        public int MatchId { get; set; }
    }
}
