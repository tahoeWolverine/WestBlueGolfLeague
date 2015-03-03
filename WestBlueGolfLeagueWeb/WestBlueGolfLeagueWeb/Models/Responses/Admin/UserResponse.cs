using Microsoft.AspNet.Identity.EntityFramework;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WestBlueGolfLeagueWeb.Models.Responses.Admin
{
    public class UserResponse
    {
        public UserResponse(ApplicationUser user, IdentityRole role, bool isSelf)
        {
            this.RoleName = role.Name;
            this.UserName = user.UserName;
            this.Id = user.Id;
            this.IsSelf = isSelf;
        }

        public UserResponse() { }

        public string Id { get; set; }

        public string UserName { get; set; }

        public string RoleName { get; set; }

        public bool IsSelf { get; set; }
    }
}