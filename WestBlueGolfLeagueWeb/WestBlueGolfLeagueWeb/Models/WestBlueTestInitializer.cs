using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models
{
    public class WestBlueTestInitializer : System.Data.Entity.DropCreateDatabaseIfModelChanges<WestBlueGolfDbContext>
    {
        protected override void Seed(WestBlueGolfDbContext context)
        {
            var players = new List<Player> 
            {
                new Player {PlayerName = "Frodo Baggins", Status = "NEW", Week0Score = 10},
                new Player {PlayerName = "Boromir", Status = "NEW", Week0Score = 12},
                new Player {PlayerName = "Aragorn", Status = "NEW", Week0Score = 13},
                new Player {PlayerName = "Samwise Gamgee", Status = "NEW", Week0Score = 11},
            };

            players.ForEach(p => context.Players.Add(p));
            context.SaveChanges();
        }
    }
}