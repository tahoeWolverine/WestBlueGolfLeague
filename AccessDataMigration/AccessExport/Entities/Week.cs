using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    public class Week
    {
        public DateTime Date { get; set; }
        public int Id { get; set; }
        public Course Course { get; set; }
        public int SeasonIndex { get; set; }
        public Year Year { get; set; }
        public bool IsBadData { get; set; }
        public bool IsPlayoff { get; set; }
        public int PairingId { get; set; }
    }
}
