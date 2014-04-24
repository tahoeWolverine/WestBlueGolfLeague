using AccessExport.Entities;
using System;
using System.Collections.Generic;
using System.Data.Odbc;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Should;
using Should.Fluent;

namespace AccessExport
{
    class Program
    {
        static void Main(string[] args)
        {
            var dmb = new DataModelBuilder();

            var dataModel = dmb.CreateDataModel();

            var mysqlGenerator = new MySqlGenerator();

            var dataModelInserts = mysqlGenerator.Generate(dataModel);

            Console.WriteLine();
            Console.WriteLine();

            Console.WriteLine(dataModelInserts);

            //Console.WriteLine(BitConverter.ToString(Hasher.Hash("xxxxxxxx", "839202910", 5000)).Replace("-", ""));
        }
    }
}
