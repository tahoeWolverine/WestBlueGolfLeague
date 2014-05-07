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
using System.IO;
using System.Threading;


namespace AccessExport
{
    class Program
    {
        public static void TimedTask(string msg, Action stuffToDo)
        {
            Stopwatch sw = new Stopwatch();
            Console.WriteLine(msg);
            sw.Start();
            stuffToDo();
            sw.Stop();
            Console.WriteLine(sw.ElapsedMilliseconds + "ms");
        }

        static void Main(string[] args)
        {

            if (args.Length < 3)
            {
                Console.WriteLine("** WARNING **");
                Console.WriteLine("** Using defaults as required vals were not passed in **");
                Console.WriteLine();
            }

            DoExport();                

            //Console.WriteLine(BitConverter.ToString(Hasher.Hash("xxxxxxxx", "839202910", 5000)).Replace("-", ""));
        }

        private static void DoExport()
        {
            bool dataPopulateMode = true;
            DataModel dataModel = null;

            TimedTask("-- Building data model from access dbs --", () =>
            {
                var dmb = new DataModelBuilder();

                dataModel = dmb.CreateDataModel();
            });

            //
            // Begin MySql specific stuff
            //
            string dataModelInserts = string.Empty;

            TimedTask("-- Generating mysql inserts --", () =>
            {
                var mysqlGenerator = new MySqlGenerator();

                dataModelInserts = mysqlGenerator.Generate(dataModel);
            });

            // if we aren't populating data, stream the sql to stdout for debugging
            if (!dataPopulateMode)
            {
                Console.WriteLine(dataModelInserts);
                return;
            }

            var connectionString = ConfigurationManager.ConnectionStrings["westBlueConnection"].ConnectionString;

            TimedTask("-- setting prerequisite conditions for mysql --", () =>
            {
                using (MySqlConnection conn = new MySqlConnection(connectionString))
                {
                    conn.Open();

                    // We need to set the packet size for mysql to accept our large inserts.
                    using (var command = conn.CreateCommand())
                    {
                        command.CommandText = "SET GLOBAL max_allowed_packet = 28777216;";
                        command.ExecuteNonQuery();
                    }
                }
            });

            using (MySqlConnection conn = new MySqlConnection(connectionString))
            {
                conn.Open();

                MySqlTransaction transaction = null;
                try
                {
                    transaction = conn.BeginTransaction();

                    var inserts = dataModelInserts;
                    var deletes = File.ReadAllText("scripts/deletes.txt");

                    TimedTask("-- deleting current data --", () =>
                    {
                        using (var command = conn.CreateCommand())
                        {
                            command.CommandText = deletes;
                            command.Transaction = transaction;
                            command.ExecuteNonQuery();
                        }
                    });

                    TimedTask("-- inserting new data --", () =>
                    {
                        using (var command = conn.CreateCommand())
                        {
                            command.Transaction = transaction;
                            command.CommandText = inserts;
                            command.ExecuteNonQuery();
                        }
                    });

                    transaction.Commit();
                }
                catch (Exception)
                {
                    if (transaction != null)
                    {
                        transaction.Rollback();
                    }

                    throw;
                }
            }
        }
    }
}
