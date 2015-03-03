namespace WestBlueGolfLeagueWeb.Models
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class addNotes : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "notes",
                c => new
                    {
                        id = c.Int(nullable: false, identity: true),
                        text = c.String(nullable: false, unicode: false),
                        date = c.DateTime(nullable: false, storeType: "date"),
                    })
                .PrimaryKey(t => t.id);
        }
        
        public override void Down()
        {
            DropTable("notes");
        }
    }
}
