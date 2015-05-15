using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    public class LeaderBoardExecutor
    {
        private WestBlue db;

        public LeaderBoardExecutor(WestBlue westBlue)
        {
            this.db = westBlue;
        }

        public void ExecuteLeaderBoards()
        {
            // for each board, get board from prefetched map
            // if board doesn't already exist, create it!
            // for each player/team, get leaderboard data for board
            // create it if it doesn't exist
            // do calculation, set value, save

            // For each multi value board, create it if it doesn't exist
            // get leaderboard datas
            // execute query/code
            
            // save changessss
        }

        //private 
    }
}