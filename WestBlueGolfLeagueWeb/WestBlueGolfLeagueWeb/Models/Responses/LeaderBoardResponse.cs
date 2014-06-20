using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class LeaderBoardResponse
    {
        public LeaderBoardResponse(leaderboard leaderboard)
        {
            this.Id = leaderboard.id;
            this.Name = leaderboard.name;
            this.Key = leaderboard.key;
            this.IsPlayerBoard = leaderboard.isPlayerBoard;
            this.Priority = leaderboard.priority;

            if (leaderboard.leaderboarddatas != null)
            {
                this.LeaderBoardDatas = leaderboard.leaderboarddatas.Select(x => LeaderBoardDataResponse.From(x));
            }
        }

        public LeaderBoardResponse() { }

        public bool IsPlayerBoard { get; set; }

        public string Key { get; set; }

        public string Name { get; set; }

        public int Id { get; set; }

        public int Priority { get; set; }

        public IEnumerable<LeaderBoardDataResponse> LeaderBoardDatas { get; set; }
    }
}