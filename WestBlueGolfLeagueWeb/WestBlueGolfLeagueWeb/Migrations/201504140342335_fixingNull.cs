namespace WestBlueGolfLeagueWeb.Models
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class fixingNull : DbMigration
    {
        public override void Up()
        {
            AlterColumn("result", "scoreVariant", c => c.Int());
        }
        
        public override void Down()
        {
            AlterColumn("result", "scoreVariant", c => c.Int(nullable: false));
        }
    }
}
