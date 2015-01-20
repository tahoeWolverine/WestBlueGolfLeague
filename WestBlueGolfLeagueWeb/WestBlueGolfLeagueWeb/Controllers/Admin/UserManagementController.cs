using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using WestBlueGolfLeagueWeb.Models.Admin;
using System.Net;

namespace WestBlueGolfLeagueWeb.Controllers.Admin
{
    [Authorize(Roles = AdminRole.Admin.Name)]
    public class UserManagementController : WestBlueDbApiController
    {
        // GET: UserManagement
        public async Task<IHttpActionResult> AllUsers()
        {
            var users = await this.IdentityDb.Users.ToListAsync();

            return Ok(users);
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