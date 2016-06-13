using AutoMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.App_Start
{
    public class MapperConfig
    {
        public static void ConfigureMapper()
        {
            IMapperConfiguration mapperConfig;

            new MapperConfiguration(cfg => mapperConfig = cfg);
        }
    }
}