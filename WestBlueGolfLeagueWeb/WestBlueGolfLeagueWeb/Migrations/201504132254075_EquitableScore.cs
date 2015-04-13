namespace WestBlueGolfLeagueWeb.Models
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class EquitableScore : DbMigration
    {
        public override void Up()
        {
            AddColumn("result", "scoreVariant", c => c.Int(nullable: true));
        }
        
        public override void Down()
        {
            DropColumn("result", "scoreVariant");
        }
    }
}
