using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web.Http;
using System.Net.Http;
using Microsoft.AspNet.Identity.Owin;
using WestBlueGolfLeagueWeb.Models.Admin;
using WestBlueGolfLeagueWeb.Models.Entities;
using System.Net;
using Newtonsoft.Json.Linq;

namespace WestBlueGolfLeagueWeb.Controllers.Admin
{
    [Authorize(Roles = AdminRole.Admin.Name)]
    public class NoteController : WestBlueDbApiController
    {
        public NoteController() : base(true) { }

        [HttpPost]
        public async Task<IHttpActionResult> AddNote(JObject requestObj)
        {
            string text = requestObj["text"].ToObject<string>();

            this.Db.notes.Add(new note() { text = text, date = DateTime.UtcNow });
            int result = await this.Db.SaveChangesAsync();

            if (result != 1)
            {
                return InternalServerError();
            }

            return StatusCode(HttpStatusCode.NoContent);
        }
    }
}