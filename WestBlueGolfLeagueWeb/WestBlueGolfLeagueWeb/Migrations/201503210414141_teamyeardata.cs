namespace WestBlueGolfLeagueWeb.Models
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class teamyeardata : DbMigration
    {
        public override void Up()
        {
            //CreateTable(
            //    "teamyeardata",
            //    c => new
            //        {
            //            id = c.Int(nullable: false, identity: true),
            //            teamId = c.Int(nullable: false),
            //            yearId = c.Int(nullable: false),
            //        })
            //    .PrimaryKey(t => t.id)
            //    .ForeignKey("year", t => t.yearId)
            //    .ForeignKey("team", t => t.teamId, cascadeDelete: true)
            //    .Index(t => t.teamId)
            //    .Index(t => t.yearId);
            
        }
        
        public override void Down()
        {
            //DropForeignKey("westbluegolf.teamyeardata", "teamId", "westbluegolf.team");
            //DropForeignKey("westbluegolf.teamyeardata", "yearId", "westbluegolf.year");
            //DropIndex("teamyeardata", new[] { "yearId" });
            //DropIndex("teamyeardata", new[] { "teamId" });
            //DropTable("teamyeardata");
        }
    }
}
