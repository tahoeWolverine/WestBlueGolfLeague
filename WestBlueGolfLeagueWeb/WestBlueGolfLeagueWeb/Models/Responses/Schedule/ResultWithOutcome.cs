using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Extensions;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses.Schedule
{
    public class ResultWithOutcome : ResultWebResponse
    {
        public ResultWithOutcome(result result) : base(result)
        {
            this.WasWin = result.WasWin();
            this.IsComplete = result.IsComplete();
            this.ScoreDiff = result.ScoreDifference();
        }

        public bool WasWin { get; set; }

        public bool IsComplete { get; set; }

        public int? ScoreDiff { get; set; }
    }
}