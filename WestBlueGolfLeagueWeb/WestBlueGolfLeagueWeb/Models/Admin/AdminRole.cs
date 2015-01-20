using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Admin
{
    // These roles must match the actual roles in the DB.
    public static class AdminRole
    {

        public static class Admin
        {
            public const string Name = "admin";
        }


        public static class TeamCaptain
        {
            public const string Name = "captain";
        }
    }
}