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
using System.Net;


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
            try
            {
                string ftpHost = string.Empty;
                string ftpUsername = string.Empty;
                string ftpPassword = string.Empty;

                if (args.Length < 3)
                {
                    Console.WriteLine("** WARNING **");
                    Console.WriteLine("** Using defaults. Required vals were not passed in **");
                    Console.WriteLine();
                }
                else
                {
                    ftpHost = args[0];
                    ftpUsername = args[1];
                    ftpPassword = args[2];
                }

                DoExport(ftpHost, new NetworkCredential(ftpUsername, ftpPassword));
            }
            catch (Exception e)
            {
                Console.WriteLine(e.ToString());
            }

            //Console.WriteLine(BitConverter.ToString(Hasher.Hash("xxxxxxxx", "839202910", 5000)).Replace("-", ""));
        }

        private static void DoExport(string ftpHost, NetworkCredential ftpCreds)
        {
            bool dataPopulateMode = true;
            DataModel dataModel = null;
            string destinationDir = "databases";

            if (!string.IsNullOrEmpty(ftpHost))
            {
                FtpUtil.DownloadFtpDirectory(ftpCreds, ftpHost, "access_db", destinationDir, (fileName) =>
                {
                    if (fileName.Contains("14"))
                    {
                        return true;
                    }

                    if (!File.Exists(destinationDir + "/" + fileName))
                    {
                        return true;
                    }

                    return false;
                });
            }

            TimedTask("-- Building data model from access dbs --", () =>
            {
                var dmb = new DataModelBuilder();

                string databaseDir = @"..\..\..\..\Actual Data\access_db";

                if (!string.IsNullOrEmpty(ftpHost))
                {
                    databaseDir = destinationDir;
                }

                dataModel = dmb.CreateDataModel(databaseDir, AppDomain.CurrentDomain.BaseDirectory + "file.dsn");
            });

            //
            // Begin MySql specific stuff
            //
            var dataModelInserts = new StringBuilder();

            var mysqlGenerator = new MySqlGenerator();

            TimedTask("-- Generating mysql inserts --", () =>
            {
                mysqlGenerator.Generate(dataModel, (sql) => dataModelInserts.AppendLine(sql));
            });

            // if we aren't populating data, stream the sql to stdout for debugging
            if (!dataPopulateMode)
            {
                Console.WriteLine(dataModelInserts.ToString());
                return;
            }

            var connectionString = ConfigurationManager.ConnectionStrings["westBlueConnection"].ConnectionString;

            TimedTask("-- setting prerequisite conditions for mysql --", () =>
            {
                mysqlGenerator.DoPrereq(connectionString);
            });

            TimedTask("-- doing inserts --", () =>
            {
                mysqlGenerator.DoInsert(connectionString, dataModel);
            });
        }
    }
}
