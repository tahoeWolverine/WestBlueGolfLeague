using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class TeamResponse
    {
        public static TeamResponse From(team team) 
        {
            return new TeamResponse()
            {
                Id = team.id,
                Name = team.teamName,
                Valid = team.validTeam
            };
        }

        public TeamResponse()
        {

        }

        public bool Valid { get; set; }

        public string Name { get; set; }

        public int Id { get; set; }
    }
}