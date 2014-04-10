using AccessExport.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    public class DataModel
    {
        public ICollection<Player> Players { get; set; }
        public ICollection<Team> Teams { get; set; }
        public ICollection<TeamMatchup> TeamMatchup { get; set; }
        public ICollection<Year> Years { get; set; }
        public ICollection<YearData> YearDatas { get; set; }
        public ICollection<Course> Courses { get; set; }
        public ICollection<Result> Results { get; set; }
        public ICollection<MatchUp> MatchUp { get; set; }
        public ICollection<Week> Weeks { get; set; }
        public ICollection<LeaderBoardData> LeaderBoardDatas { get; set; }
        public ICollection<LeaderBoard> LeaderBoards { get; set; }
    }
}
