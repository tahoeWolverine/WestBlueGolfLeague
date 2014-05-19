using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class YearResponse
    {
        public static YearResponse From(year y)
        {
            return new YearResponse
            {
                Id = y.id,
                IsComplete = y.isComplete,
                Value = y.value
            };
        }

        public int Id { get; set; }

        public bool IsComplete { get; set; }

        public int Value { get; set; }
    }
}