using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    class Player
    {
        public int Id { get; set; }
        public Team Team { get; set; }
        public string Name { get; set; }
        public int CurrentHandicap { get; set; }
        public bool ValidPlayer { get; set; }
    }
}
