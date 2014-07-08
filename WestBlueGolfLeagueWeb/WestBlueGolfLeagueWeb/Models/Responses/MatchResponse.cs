using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class MatchResponse
    {
        internal static MatchResponse From(Entities.match x)
        {
            return new MatchResponse
            {
                Id = x.id,
                Results = x.results.Select(r => ResultResponse.From(r)).ToList()
            };
        }

        public List<ResultResponse> Results { get; set; }

        public int Id { get; set; }
    }
}