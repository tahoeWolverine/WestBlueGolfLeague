using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    public class Result
    {
        public int Score { get; set; }
        public int Points { get; set; }
        public MatchUp Matchup { get; set; }
        public int Id { get; set; }
        public Player Player { get; set; }
        public int PriorHandicap { get; set; }
        public Year Year { get; set; }

        public Result GetOpponentResult()
        {
            return this.Matchup.Result1.Id == this.Id ? this.Matchup.Result1 : this.Matchup.Result2;
        }

        public int ScoreDifference { get { return this.Score - this.Matchup.TeamMatchup.Week.Course.Par; } }
        public int NetScoreDifference { get { return this.ScoreDifference - this.PriorHandicap; } }
        public bool WasWin { get { return this.Points > 12; } }
        public bool WasLoss { get { return this.Points < 12; } }
    }
}
