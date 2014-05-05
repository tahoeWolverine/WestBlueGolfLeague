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

using MySql.Data;
using MySql.Data.MySqlClient;
using System.Configuration;


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

            /*var connectionString = ConfigurationManager.ConnectionStrings["westBlueConnection"].ConnectionString;
            using (MySqlConnection conn = new MySqlConnection(connectionString)) 
            {
                conn.Open();

                MySqlTransaction transaction = null;
                try
                {
                    transaction = conn.BeginTransaction();

                    using (var command = conn.CreateCommand())
                    {
                        command.CommandText = "SELECT * FROM player";
                        command.Transaction = transaction;
                        using (var datareader = command.ExecuteReader())
                        {
                            while (datareader.Read())
                            {
                                var name = datareader.GetString("name");
                                Console.WriteLine(name);
                            }
                        }
                    }

                    transaction.Commit();
                }
                catch (Exception e)
                {
                    if (transaction != null)
                    {
                        transaction.Rollback();
                    }
                }
            }*/

            //Console.WriteLine(BitConverter.ToString(Hasher.Hash("xxxxxxxx", "839202910", 5000)).Replace("-", ""));
        }
    }
}
