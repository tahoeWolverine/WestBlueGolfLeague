using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport.Entities
{
    public class DataMigration
    {
        public Year Year { get; set; }
        public string Notes { get; set; }
        public DateTime DataMigrationDate { get; set; }
        public int Id { get; set; }
    }
}
