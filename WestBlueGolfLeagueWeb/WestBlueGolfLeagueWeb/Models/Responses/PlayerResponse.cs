using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class PlayerResponse
    {
        public static PlayerResponse From(playeryeardata p)
        {
            return new PlayerResponse 
            {
                Id = p.player.id,
                Name = p.player.name,
                CH = p.player.currentHandicap,
                // p.favorite // I don't know what this value is for...
                VP = p.player.validPlayer,
                TId = p.player.teamId,
                YD = PlayerYearDataResponse.From(p)
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
        /// Team ID
        /// </summary>
        public int TId { get; set; }

        /// <summary>
        /// Year data for year requested.
        /// </summary>
        public PlayerYearDataResponse YD { get; set; }
    }
}