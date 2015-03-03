using System;
using System.Collections.Generic;
using System.Data.Entity.Migrations;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models
{
    public class WestBlueConfiguration : DbMigrationsConfiguration<WestBlue>
    {
        public WestBlueConfiguration()
		{
			AutomaticMigrationsEnabled = false;

			// add this
			SetSqlGenerator("MySql.Data.MySqlClient", new MySql.Data.Entity.MySqlMigrationSqlGenerator());
		}

        protected override void Seed(WestBlue context)
        {
            base.Seed(context);
        }
    }
}