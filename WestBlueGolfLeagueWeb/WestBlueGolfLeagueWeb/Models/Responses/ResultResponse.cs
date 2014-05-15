using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class ResultResponse
    {
        internal static ResultResponse From(Entities.result r)
        {
            return new ResultResponse
            {
                Id = r.id,
                TeamId = r.teamId,
                Points = r.points,
                Score = r.score,
                PH = r.priorHandicap,
                PId = r.playerId
            };
        }

        public int PId { get; set; }

        public int PH { get; set; }

        public int Score { get; set; }

        public int Points { get; set; }

        public int TeamId { get; set; }

        public int Id { get; set; }
    }
}