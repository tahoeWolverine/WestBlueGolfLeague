using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses.Schedule
{
    public class CourseResponse
    {
        public static CourseResponse From(course c)
        {
            return new CourseResponse 
            {
                Par = c.par,
                Name = c.name,
                Id = c.id,
            };
        }

        public int Id { get; set; }

        public string Name { get; set; }

        public int Par { get; set; }
    }
}