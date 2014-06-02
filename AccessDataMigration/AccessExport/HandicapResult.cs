using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    public class HandicapResult
    {
        public int Handicap { get; set; }
        public IEnumerable<int> WeeksUsed { get; set; }
    }
}
