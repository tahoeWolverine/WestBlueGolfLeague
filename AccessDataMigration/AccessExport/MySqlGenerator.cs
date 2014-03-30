using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    class MySqlGenerator
    {
        public string Generate(DataModel dataModel)
        {
            StringBuilder sb = new StringBuilder();

            // Create teams first
            var teamInserts = dataModel.Teams.Select(t => this.GetTeamInsert(t));
            sb.Append(string.Join("\n", teamInserts));

            sb.Append("\n\n\n");

            // playerssss
            var players = dataModel.Players.Select(p => this.GetPlayerInsert(p));
            sb.Append(string.Join("\n", players));

            sb.Append("\n\n\n");

            return sb.ToString();
        }

        private string GetTeamInsert(Team team)
        {
            return
                new FluentMySqlInsert("team")
                .WithColumns("id", "teamName", "validTeam")
                .WithValues(team.Id, team.Name, team.ValidTeam)
                .ToString();
        }

        private string GetPlayerInsert(Player player)
        {
            return
                new FluentMySqlInsert("player")
                .WithColumns("id", "name", "currentHandicap", "favorite", "teamId", "validPlayer")
                .WithValues(player.Id, player.Name, player.CurrentHandicap, false, player.Team.Id, player.ValidPlayer)
                .ToString();
        }
    }
}
