namespace WestBlueGolfLeagueWeb.Models
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class updateColumn : DbMigration
    {
        public override void Up()
        {
            AlterColumn("notes", "date", c => c.DateTime(nullable: false, precision: 0));
        }
        
        public override void Down()
        {
            AlterColumn("notes", "date", c => c.DateTime(nullable: false, storeType: "date"));
        }
    }
}
