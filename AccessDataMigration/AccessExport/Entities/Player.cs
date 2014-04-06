using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    class Player
    {
        private Team team;

        private List<YearData> yearData = new List<YearData>();

        private int id;

        public Player(int id)
        {
            this.id = id;
        }

        public int Id { get { return this.id; } }

        public Team Team 
        { 
            get { return this.team; } 
            set 
            {
                if (this.team != null) this.team.RemovePlayer(this);

                value.AddPlayer(this); this.team = value; 
            } 
        }
        public string Name { get; set; }
        public int CurrentHandicap { get; set; }
        public bool ValidPlayer { get; set; }

        public IEnumerable<YearData> YearDatas { get { return this.yearData; } }

        internal void AddYearData(YearData yearData)
        {
            this.yearData.Add(yearData);
        }

        internal int ImprovedInYear(Year year)
        {
            // There should always be a year data for the year passed in.
            var ydForYear = this.yearData.First(yd => yd.Year.Value == year.Value);
            int starting = ydForYear.StartingHandicap;

            int ending = year.NewestYear ? this.CurrentHandicap : ydForYear.FinishingHandicap;

            return ending - starting;
        }
    }
}
