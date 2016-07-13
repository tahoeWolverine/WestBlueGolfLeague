using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Repositories;

namespace WestBlueGolfLeagueWeb.Services
{
    public class ResultService
    {
        private WestBlue db;
        private ResultsRepository resultsRepository;

        public ResultService()
        {
            this.db = new WestBlue();
            this.resultsRepository = new ResultsRepository(this.db);
        }

        public void GetResultsForYear(int year)
        {

        }
    }
}