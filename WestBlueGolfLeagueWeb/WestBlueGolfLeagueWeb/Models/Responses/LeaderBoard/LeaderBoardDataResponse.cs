using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses.LeaderBoard
{
    public class LeaderBoardDataResponse
    {
        public static LeaderBoardDataResponse From(leaderboarddata lbd)
        {
            /*
            player
            
            win/loss ratio needs 3 decimal
            best net score needs +/-
            season improvement needs +/-
            avg. opp. net score needs +/-
            avg. net score needs +/-
            avg. margin of victory needs +/-
            avg. margin of net victory needs +/-


            team

            win/loss ratio needs 3 decimal
            season improvement needs +/-
            */

            return new LeaderBoardDataResponse
            {
                Id = lbd.id,
                IsP = lbd.isPlayer,
                LbId = lbd.leaderBoardId,
                PId = lbd.playerId,
                V = lbd.value,
                TId = lbd.teamId,
                R = lbd.rank,
                Det = lbd.detail,
                FV = lbd.formattedValue
            };
        }

        public int Id { get; set; }

        /// <summary>
        /// Is player?
        /// </summary>
        public bool IsP { get; set; }

        /// <summary>
        /// Leaderboard ID
        /// </summary>
        public int LbId { get; set; }

        /// <summary>
        /// Player id
        /// </summary>
        public int? PId { get; set; }

        /// <summary>
        /// Team ID
        /// </summary>
        public int? TId { get; set; }

        /// <summary>
        /// Rank
        /// </summary>
        public int R { get; set; }

        /// <summary>
        /// Details
        /// </summary>
        public string Det { get; set; }

        /// <summary>
        /// Value
        /// </summary>
        public double V { get; set; }

        /// <summary>
        /// Formatted value (eg. "+1")
        /// </summary>
        public string FV { get; set; }
    }
}