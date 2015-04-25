namespace WestBlueGolfLeagueWeb.Models
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class matchOrderOnMatch : DbMigration
    {
        public override void Up()
        {
            AddColumn("match", "matchOrder", c => c.Int());
        }
        
        public override void Down()
        {
            DropColumn("match", "matchOrder");
        }
    }
}
