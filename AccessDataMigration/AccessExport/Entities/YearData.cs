using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    public class YearData
    {
        public int Id { get; set; }
        public Year Year { get; set; }
        public int StartingHandicap { get; set; }
        public int FinishingHandicap { get; set; }
        public bool Rookie { get; set; }
        public Player Player { get; set; }

        public Team Team { get; set; }
    }
}
