using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using System;
using Microsoft.AspNet.Identity.Owin;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using WestBlueGolfLeagueWeb.Models.Admin;
using WestBlueGolfLeagueWeb.Models.Responses.Admin;

namespace WestBlueGolfLeagueWeb.Controllers.Admin
{
    [Authorize(Roles = AdminRole.Admin.Name)]
    public class UsersController : WestBlueDbApiController
    {
        private ApplicationUserManager userManager;
        private ApplicationRoleManager roleManager;

        public ApplicationRoleManager RoleManager
        {
            get
            {
                return roleManager ?? this.Request.GetOwinContext().Get<ApplicationRoleManager>();
                //
            }
            private set
            {
                roleManager = value;
            }
        }

        public ApplicationUserManager UserManager
        {
            get
            {
                return userManager ?? this.Request.GetOwinContext().GetUserManager<ApplicationUserManager>();
                //HttpContext.Current.GetOwinContext() 
            }
            private set
            {
                userManager = value;
            }
        }

        [HttpGet]
        public async Task<IHttpActionResult> AllUsers()
        {
            var users = await this.IdentityDb.Users.ToListAsync();

            var usersWithRole = await this.IdentityDb.Set<IdentityUserRole>()
                .Join(this.IdentityDb.Users, ur => ur.UserId, user => user.Id, (ur, user) => new { userRole = ur, user })
                .Join(this.IdentityDb.Roles, result => result.userRole.RoleId, role => role.Id, (result, role) => new { result, role })
                .Select(r => new { user = r.result.user, role = r.role })
                .ToListAsync();

            var allRoles = await this.IdentityDb.Roles.ToListAsync();

            var userResponses = usersWithRole.Select(x => new UserResponse(x.user, x.role, string.Equals(x.user.Id, this.User.Identity.GetUserId(), StringComparison.OrdinalIgnoreCase)));

            return Ok(new GetUsersResponse { AllRoles = allRoles.Select(x => new RoleResponse { Id = x.Id, Name = x.Name }), AllUsers = userResponses });
        }

        [HttpPut]
        public async Task<IHttpActionResult> UpdateUser(string id, UserResponse user)
        {
            if (string.Equals(id, this.User.Identity.GetUserId(), StringComparison.OrdinalIgnoreCase))
            {
                return BadRequest("Currently authenticated user is not allowed to modify themselves.");
            }

            var userToUpdate = await this.IdentityDb.Users.SingleOrDefaultAsync(x => x.Id == id);

            if (userToUpdate == null)
            {
                return NotFound();
            }

            var allRolesForUser = await this.UserManager.GetRolesAsync(userToUpdate.Id);
            await this.UserManager.RemoveFromRolesAsync(userToUpdate.Id, allRolesForUser.ToArray());

            this.UserManager.AddToRole(userToUpdate.Id, user.RoleName);

            return StatusCode(HttpStatusCode.NoContent);
        }

        public async Task<IHttpActionResult> DeleteUser(string id)
        {
            var userToDelete = await this.IdentityDb.Users.SingleOrDefaultAsync(x => x.Id == id);

            if (userToDelete != null)
            {
                this.IdentityDb.Users.Remove(userToDelete);
                await this.IdentityDb.SaveChangesAsync();
                return StatusCode(HttpStatusCode.NoContent);
            }

            return NotFound();
        }
    }
}