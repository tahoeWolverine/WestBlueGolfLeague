using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models;

namespace WestBlueGolfLeagueWeb.Models
{
    using Microsoft.AspNet.Identity.EntityFramework;
    using MySql.Data.Entity;
    using System.Data.Entity;
    using System.Data.Entity.Core.Metadata.Edm;
    using System.Data.Entity.Infrastructure;
    using System.Data.Entity.ModelConfiguration.Conventions;

    // A custom convention.
    class FirstCharLowerCaseConvention : IStoreModelConvention<EdmProperty>
    {
        public void Apply(EdmProperty property, DbModel model)
        {
            property.Name = property.Name.Substring(0, 1).ToLower()
                          + property.Name.Substring(1);
        }
    }

    [DbConfigurationType(typeof(MySqlEFConfiguration))]
    public class IdentityContext : IdentityDbContext<ApplicationUser>
    {
        /// <summary>
        /// To use this constructor you have to have a connection string 
        /// name "MyConnection" in your configuration
        /// </summary>
        public IdentityContext() : this("WestBlue") { }

        /// <summary>
        /// Construct a db context
        /// </summary>
        /// <param name="connStringName">Connection to use for the database</param>
        public IdentityContext(string connStringName) : base(connStringName) { }

        /// <summary>
        /// Some database fixup / model constraints
        /// </summary>
        /// <param name="modelBuilder"></param>
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Conventions.Add(new FirstCharLowerCaseConvention());

            const string SchemaName = "";

            #region Fix asp.net identity 2.0 tables under MySQL
            // Explanations: primary keys can easily get too long for MySQL's 
            // (InnoDB's) stupid 767 bytes limit.
            // With the two following lines we rewrite the generation to keep
            // those columns "short" enough
            modelBuilder.Entity<IdentityRole>()
                .ToTable("roles", SchemaName)
                .Property(c => c.Name)
                .HasMaxLength(128)
                .IsRequired();

            modelBuilder.Entity<IdentityUserRole>().ToTable("userroles", SchemaName);

            modelBuilder.Entity<IdentityUserClaim>().ToTable("userclaims", SchemaName);

            modelBuilder.Entity<IdentityUserLogin>().ToTable("userlogins", SchemaName);

            // We have to declare the table name here, otherwise IdentityUser 
            // will be created
            modelBuilder.Entity<ApplicationUser>()
                .ToTable("users", SchemaName)
                .Property(c => c.UserName)
                .HasMaxLength(128)
                .IsRequired();
            #endregion
        }

        public static IdentityContext Create()
        {
            return new IdentityContext();
        }
    }
}