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
using WestBlueGolfLeagueWeb.Models.Admin;
using WestBlueGolfLeagueWeb.Models.Responses.Admin;
using System.Web.Http;
using WestBlueGolfLeagueWeb.Models;
using System.Text;

namespace WestBlueGolfLeagueWeb.Controllers.Admin
{
    [Authorize(Roles = AdminRole.Admin.Name)]
    public class UserController : WestBlueDbApiController
    {
        public ApplicationRoleManager RoleManager
        {
            get
            {
                return this.Request.GetOwinContext().Get<ApplicationRoleManager>();
            }
            
        }

        public ApplicationUserManager UserManager
        {
            get
            {
                return this.Request.GetOwinContext().GetUserManager<ApplicationUserManager>(); 
                //HttpContext.Current.GetOwinContext() 
            }
        }

        [HttpGet]
        public async Task<IHttpActionResult> AllUsers()
        {
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
        public async Task<IHttpActionResult> UpdateUser(string id, AddUpdateUserRequest user)
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

            if (!string.IsNullOrEmpty(user.RoleName))
            {
                var allRolesForUser = await this.UserManager.GetRolesAsync(userToUpdate.Id);
                await this.UserManager.RemoveFromRolesAsync(userToUpdate.Id, allRolesForUser.ToArray());

                this.UserManager.AddToRole(userToUpdate.Id, user.RoleName);
            }

            return StatusCode(HttpStatusCode.NoContent);
        }

        [HttpPost]
        public async Task<IHttpActionResult> AddUser(AddUpdateUserRequest user)
        {
            if (ModelState.IsValid)
            {
                var userToCreate = new ApplicationUser { UserName = user.UserName, Email = user.Email };
                var result = await UserManager.CreateAsync(userToCreate, user.Password);

                if (result.Succeeded)
                {
                    await this.UserManager.AddToRoleAsync(userToCreate.Id, user.RoleName);
                    var role = await this.RoleManager.FindByNameAsync(user.RoleName);
                    return Ok(new UserResponse(userToCreate, role, string.Equals(userToCreate.Id, this.User.Identity.GetUserId(), StringComparison.OrdinalIgnoreCase)));
                }
                else
                {
                    return BadRequest();
                }

                //result.Errors
                //AddErrors(result);
            }

            return StatusCode(HttpStatusCode.InternalServerError);
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

        [HttpGet]
        public async Task<IHttpActionResult> UserNameAvailable(string username)
        {
            var decodedUserName = Encoding.UTF8.GetString(Convert.FromBase64String(username));

            var userByUsername = await this.IdentityDb.Users.SingleOrDefaultAsync(x => x.UserName == decodedUserName);

            if (userByUsername == null)
            {
                return Ok();
            }

            return StatusCode(HttpStatusCode.Conflict);
        }
    }
}