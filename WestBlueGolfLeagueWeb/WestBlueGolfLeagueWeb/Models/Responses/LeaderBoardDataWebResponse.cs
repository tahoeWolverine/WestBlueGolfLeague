using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class LeaderBoardDataWebResponse
    {
        public LeaderBoardDataWebResponse(leaderboarddata boardData)
        {
            this.Value = boardData.value;
            this.Rank = boardData.rank;
            this.EntityId = boardData.isPlayer ? boardData.player.id : boardData.team.id;
            this.EntityName = boardData.isPlayer ? boardData.player.name : boardData.team.teamName;
            this.FormattedValue = boardData.formattedValue;
        }

        public string EntityName { get; set; }

        public int EntityId { get; set; }

        public int Rank { get; set; }

        public double Value { get; set; }

        public string FormattedValue { get; set; }
    }
}