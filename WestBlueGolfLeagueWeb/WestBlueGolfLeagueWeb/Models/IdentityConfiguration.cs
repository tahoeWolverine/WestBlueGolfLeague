using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Data.Entity.Migrations;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models
{
    public class IdentityConfiguration : DbMigrationsConfiguration<IdentityContext>
	{
        public IdentityConfiguration()
		{
			AutomaticMigrationsEnabled = false;

			// add this
			SetSqlGenerator("MySql.Data.MySqlClient", new MySql.Data.Entity.MySqlMigrationSqlGenerator());
		}

		protected override void Seed(IdentityContext context)
		{
			base.Seed(context);

            //IdentityRole adminRole = null;
            //IdentityRole captainRole = null;

            //var roleManager = new RoleManager<IdentityRole>(new RoleStore<IdentityRole>(context));

            //{
            //    adminRole = context.Roles.Where(x => x.Name == "admin").FirstOrDefault();

            //    if (adminRole == null) {
            //        roleManager.Create(new IdentityRole("admin"));
            //        context.SaveChanges();
            //    }
            //}

            //{
            //    captainRole = context.Roles.Where(x => x.Name == "captain").FirstOrDefault();

            //    if (captainRole == null) {
            //        roleManager.Create(new IdentityRole("captain"));
            //        context.SaveChanges();
            //    }
            //}

            //var userManager = new UserManager<ApplicationUser>(new UserStore<ApplicationUser>(context));
            
            //if (context.Users.Where(x => x.UserName == "admin").ToList().Count == 0)
            //{
            //    //PasswordHasher ph = new PasswordHasher();
            //    var user = new ApplicationUser { UserName = "polaris878@gmail.com", LockoutEnabled = true, SecurityStamp = Guid.NewGuid().ToString(), Email = "polaris878@gmail.com", EmailConfirmed = true };
            //    userManager.Create(user, "admin");

            //    context.SaveChanges();
            //}
            //else
            //{
            //    var admin = userManager.FindByEmail("polaris878@gmail.com");
            //    userManager.AddToRole(admin.Id, "admin");
            //    context.SaveChanges();
            //}

            //if (context.Users.Where(x => x.UserName == "testCaptain").ToList().Count == 0)
            //{
            //    PasswordHasher ph = new PasswordHasher();
            //    var user = new ApplicationUser { UserName = "digitalzebrasoftware@gmail.com", LockoutEnabled = true, SecurityStamp = Guid.NewGuid().ToString(), Email = "digitalzebrasoftware@gmail.com", EmailConfirmed = true };
            //    userManager.Create(user, "testCaptain");
            //    userManager.AddToRole(user.Id, "captain");
            //    context.SaveChanges();
            //}
		}

		/* ... */
	}
}