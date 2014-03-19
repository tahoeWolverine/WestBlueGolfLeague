using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.ModelConfiguration.Conventions;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models
{
    public class WestBlueGolfDbContext : DbContext
    {
        public WestBlueGolfDbContext() : base("WestBlueGolf")
        {

        }

        public DbSet<Player> Players { get; set; }

        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            modelBuilder.Conventions.Remove<PluralizingTableNameConvention>();
        }
    }
}