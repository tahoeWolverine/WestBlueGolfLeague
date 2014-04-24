using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    class FluentMySqlInsert
    {
        private const string DB_NAME = "westbluegolf";

        private string tableName;

        private StringBuilder sb;

        public FluentMySqlInsert WithValues(params object[] vals)
        {
            sb.Append(" VALUES (");

            int index = 0;

            foreach (object obj in vals)
            {
                var type = obj.GetType();

                if (type == typeof(string))
                {
                    sb.Append("'");
                    sb.Append(this.GetSafeStr((string)obj));
                    sb.Append("'");
                }
                else if (type == typeof(int))
                {
                    sb.Append(Convert.ToString((int)obj));
                }
                else if (type == typeof(bool))
                {
                    sb.Append((bool)obj ? "1" : "0");
                }
                else if (type == typeof(bool?))
                {
                    var b = (bool?)obj;
                    sb.Append(!b.HasValue ? "NULL" : b.HasValue && b.Value ? "1" : "0");
                }
                else if (type == typeof(DateTime))
                {
                    var date = (DateTime)obj;
                    sb
                        .Append("'")
                        .Append(date.ToString("yyyy-MM-dd"))
                        .Append("'");
                }
                else
                {
                    throw new ArgumentException("Unknown type of '" + obj.GetType().AssemblyQualifiedName + "'");
                }

                if (index < vals.Length - 1)
                {
                    sb.Append(",");
                }

                index++;
            }

            sb.Append(");");
            return this;
        }

        public FluentMySqlInsert(string tableName)
        {
            this.tableName = tableName;
            sb = new StringBuilder();

            sb.Append(this.GetInsertIntoPrefix(tableName));
        }

        public FluentMySqlInsert WithColumns(params string[] colNames)
        {
            sb.Append(" (");

            sb.Append(string.Join(",", colNames));

            sb.Append(")");

            return this;
        }

        public override string ToString()
        {
            return sb.ToString();
        }

        private string GetInsertIntoPrefix(string tableName)
        {
            return "INSERT INTO `" + DB_NAME + "`.`" + tableName + "`";
        }

        private string GetSafeStr(string rawStr)
        {
            return rawStr.Replace("'", "''");
        }
    }
}
