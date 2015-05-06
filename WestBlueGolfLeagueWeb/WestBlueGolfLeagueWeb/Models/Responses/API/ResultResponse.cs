using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Responses.API
{
    public class ResultResponse
    {
        internal static ResultResponse From(Entities.result r)
        {
            return new ResultResponse
            {
                Id = r.id,
                TId = r.teamId,
                P = r.points,
                S = r.score,
                PH = r.priorHandicap,
                PId = r.playerId
            };
        }

        /// <summary>
        /// Player ID
        /// </summary>
        public int? PId { get; set; }

        /// <summary>
        /// Prior handicap
        /// </summary>
        public int? PH { get; set; }

        /// <summary>
        /// Score
        /// </summary>
        public int? S { get; set; }

        public int? P { get; set; }

        public int TId { get; set; }

        public int Id { get; set; }
    }
}