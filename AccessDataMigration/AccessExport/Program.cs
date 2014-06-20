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
            #region temp handicap code
            /*{
                ScoreResult week0Score = new ScoreResult(47, 36, 0);
                bool isRookie = true;
                List<ScoreResult> scores = new List<ScoreResult> { new ScoreResult(53, 37, 2), new ScoreResult(49, 36, 5), new ScoreResult(47, 37, 6), new ScoreResult(45, 36, 15) };
                DoHandicapForPlayer("Mike Tierney", 2013, week0Score, isRookie, scores);
            }

            {
                ScoreResult week0Score = new ScoreResult(56, 36, 0);
                bool isRookie = true;
                List<ScoreResult> scores = new List<ScoreResult> { new ScoreResult(77, 36, 1), new ScoreResult(76, 37, 2) };
                DoHandicapForPlayer("Ted Gonyeau", 2014, week0Score, isRookie, scores);
            }


            {
                // iver fundaun
                ScoreResult week0Score = new ScoreResult(43, 36, 0);
                bool isRookie = false;
                List<ScoreResult> scores = new List<ScoreResult>();
                DoHandicapForPlayer("Iver Fundaun", 2014, week0Score, isRookie, scores);
            }

            // scott hanson
            {
                ScoreResult week0Score = new ScoreResult(39, 36, 0);
                bool isRookie = false;
                List<ScoreResult> scores = new List<ScoreResult> { new ScoreResult(40, 36, 1), new ScoreResult(41, 37, 2) };
                DoHandicapForPlayer("scott hanson", 2014, week0Score, isRookie, scores);
            }*/
            #endregion

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


        // TODO: BEGIN TEMP HANDICAP CODE WHICH IS BEING TESTED
        private class ScoreResult
        {
            public ScoreResult(int score, int par, int week)
            {
                this.Score = score;
                this.Par = par;
                this.Week = week;
            }

            public int Score { get; set; }
            public int Par { get; set; }
            public int Week { get; set; }
        }

        private static int CalcHandicapFromScores(int scoreTotal, int scoreCount)
        {
            double averageScoreAbovePar = ((double)scoreTotal / (double)scoreCount);
            double remainder = averageScoreAbovePar - (scoreTotal / scoreCount);

            return Math.Min((int)(averageScoreAbovePar + (remainder >= .5 ? 1 : 0)), 20);
        }


        private static void DoHandicapForPlayer(string playerName, int year, ScoreResult week0Score, bool isRookie, IEnumerable<ScoreResult> scores)
        {
            Console.WriteLine(playerName + " " + year);

            LinkedList<ScoreResult> copiedScores = new LinkedList<ScoreResult>(scores);

            int numberOfWeekZeroesToAdd = 1;

            if (!isRookie)
            {
                numberOfWeekZeroesToAdd = copiedScores.Count == 4 ? 1 : 4 - copiedScores.Count;
            }

            for (int i = 0; i < numberOfWeekZeroesToAdd; i++)
            {
                copiedScores.AddLast(new ScoreResult(week0Score.Score, 36, 0));
            }

            if (copiedScores.Count >= 5)
            {
                var lastFiveScores = copiedScores.Skip(copiedScores.Count - 5);

                int max = 0,
                    handicapSum = 0,
                    weekWithMax = 0;

                LinkedList<int> weeksUsed = new LinkedList<int>();

                foreach (var score in lastFiveScores)
                {
                    var handicapSplit = Math.Min(score.Score - score.Par, 20);

                    if (handicapSplit > max)
                    {
                        max = handicapSplit;
                        weekWithMax = score.Week;
                    }

                    weeksUsed.AddLast(score.Week);
                    handicapSum += handicapSplit;
                }

                weeksUsed.Remove(weekWithMax);

                Console.WriteLine(string.Join(",", weeksUsed));
                Console.WriteLine(CalcHandicapFromScores(handicapSum - max, 4));
            }
            else
            {
                LinkedList<int> weeksUsed = new LinkedList<int>();

                int sum = 0;

                foreach (var score in copiedScores)
                {
                    weeksUsed.AddLast(score.Week);
                    sum += Math.Min(score.Score - score.Par, 20);
                }

                Console.WriteLine(string.Join(",", weeksUsed));
                Console.WriteLine(CalcHandicapFromScores(sum, copiedScores.Count));
            }
        }
    }
}
