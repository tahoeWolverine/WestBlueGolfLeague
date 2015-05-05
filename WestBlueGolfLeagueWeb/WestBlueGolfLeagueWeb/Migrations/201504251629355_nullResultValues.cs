namespace WestBlueGolfLeagueWeb.Models
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class nullResultValues : DbMigration
    {
        public override void Up()
        {
            AlterColumn("result", "priorHandicap", c => c.Int());
            AlterColumn("result", "score", c => c.Int());
            AlterColumn("result", "points", c => c.Int());
        }
        
        public override void Down()
        {
            AlterColumn("result", "points", c => c.Int(nullable: false));
            AlterColumn("result", "score", c => c.Int(nullable: false));
            AlterColumn("result", "priorHandicap", c => c.Int(nullable: false));
        }
    }
}
