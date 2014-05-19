using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class WeekResponse
    {
        public static WeekResponse From(week w)
        {
            return new WeekResponse
            {
                Date = w.date,
                CourseId = w.courseId,
                YearId = w.yearId,
                SeasonIndex = w.seasonIndex,
                BadData = w.isBadData,
                Id = w.id,
            };
        }

        public DateTime Date { get; set; }

        public int CourseId { get; set; }

        public int YearId { get; set; }

        public int SeasonIndex { get; set; }

        public bool BadData { get; set; }

        public int Id { get; set; }
    }
}