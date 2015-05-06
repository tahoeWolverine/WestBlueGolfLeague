using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses.Player
{
    public class PlayerResponse
    {
        public static PlayerResponse From(playeryeardata p)
        {
            var pr = From(p.player);

            pr.YD = PlayerYearDataResponse.From(p);

            return pr;
        }

        public static PlayerResponse From(player p)
        {
            return new PlayerResponse
            {
                Id = p.id,
                Name = p.name,
                CH = p.currentHandicap,
                VP = p.validPlayer,
            };
        }

        public int Id { get; set; }

        public string Name { get; set; }

        /// <summary>
        /// Current handicap
        /// </summary>
        public int CH { get; set; }

        /// <summary>
        /// Valid player
        /// </summary>
        public bool VP { get; set; }

        /// <summary>
        /// Year data for year requested.
        /// </summary>
        public PlayerYearDataResponse YD { get; set; }
    }
}