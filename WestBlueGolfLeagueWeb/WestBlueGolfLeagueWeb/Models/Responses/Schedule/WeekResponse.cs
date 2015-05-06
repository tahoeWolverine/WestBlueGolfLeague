using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses.Schedule
{
    public class WeekResponse
    {
        public WeekResponse (week w)
        {
            Date = w.date;
            CourseId = w.courseId;
            YearId = w.yearId;
            SeasonIndex = w.seasonIndex;
            BadData = w.isBadData;
            PairingId = w.pairingId;
            IsPlayoff = w.isPlayoff;
            Id = w.id;
        }

        public DateTime Date { get; set; }

        public int CourseId { get; set; }

        public int YearId { get; set; }

        public int SeasonIndex { get; set; }

        public bool BadData { get; set; }

        public int Id { get; set; }

        public int PairingId { get; set; }

        public bool IsPlayoff { get; set; }
    }
}