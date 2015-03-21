using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport.Entities
{
    public class TeamYearData
    {
        public int Id { get; set; }
        public Year Year { get; set; }
        public int TeamId { get; set; }
    }
}
