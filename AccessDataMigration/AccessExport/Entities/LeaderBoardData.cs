using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport.Entities
{
    class LeaderBoardData
    {
        public int Id { get; set; }
        public int Rank { get; set; }
        // TODO: Would we ever want to stick something other than an int in here?
        public double Value { get; set; }
        public bool IsPlayer { get; set; }
        public Team Team { get; set; }
        public Player Player { get; set; }
        public LeaderBoard LeaderBoard { get; set; }
    }
}
