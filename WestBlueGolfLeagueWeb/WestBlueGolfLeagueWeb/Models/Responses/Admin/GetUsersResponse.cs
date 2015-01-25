using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Responses.Admin
{
    public class GetUsersResponse
    {
        public IEnumerable<UserResponse> AllUsers { get; set; }
        public IEnumerable<RoleResponse> AllRoles { get; set; }
    }
}