using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses.Player
{
    public class PlayerYearDataResponse
    {
        public static PlayerYearDataResponse From(playeryeardata pyd)
        {
            return new PlayerYearDataResponse
            {
                IsR = pyd.isRookie,
                Id = pyd.id,
                SH = pyd.startingHandicap,
                FH = pyd.finishingHandicap,
                TId = pyd.teamId
            };
        }

        /// <summary>
        /// Is rookie?
        /// </summary>
        public bool IsR { get; set; }

        public int Id { get; set; }

        /// <summary>
        /// Starting handicap
        /// </summary>
        public int SH { get; set; }

        /// <summary>
        /// Finishing handicap
        /// </summary>
        public int FH { get; set; }

        /// <summary>
        /// Team id
        /// </summary>
        public int TId { get; set; }
    }
}