using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class ResultWebResponse
    {
        public ResultWebResponse(result result1)
        {
            this.PlayerId = result1.playerId;
            this.PriorHandicap = result1.priorHandicap;
            this.Score = result1.score;
            this.Points = result1.points;
            this.EquitableScore = result1.scoreVariant;
            this.Id = result1.id;
            this.TeamId = result1.teamId;
        }

        public ResultWebResponse()
        {

        }

        public int TeamId { get; set; }

        public int Id { get; set; }

        public int? EquitableScore { get; set; }

        public int? Points { get; set; }

        public int? Score { get; set; }

        public int? PriorHandicap { get; set; }

        public int? PlayerId { get; set; }
    }
}