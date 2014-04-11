using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport.Entities
{
    public class LeaderBoard
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public bool IsPlayerBoard { get; set; }
        public int Priority { get; set; }
        public string Key { get; set; }
    }
}
