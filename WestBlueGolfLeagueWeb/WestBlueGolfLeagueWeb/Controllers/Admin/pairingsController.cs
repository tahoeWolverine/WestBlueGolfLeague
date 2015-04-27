using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Controllers.Admin
{
    public class pairingsController : ApiController
    {
        private WestBlue db = new WestBlue();

        // GET: api/pairings
        public IQueryable<pairing> Getpairings()
        {
            return db.pairings;
        }

        // GET: api/pairings/5
        [ResponseType(typeof(pairing))]
        public async Task<IHttpActionResult> Getpairing(int id)
        {
            pairing pairing = await db.pairings.FindAsync(id);
            if (pairing == null)
            {
                return NotFound();
            }

            return Ok(pairing);
        }

        // PUT: api/pairings/5
        [ResponseType(typeof(void))]
        public async Task<IHttpActionResult> Putpairing(int id, pairing pairing)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            if (id != pairing.id)
            {
                return BadRequest();
            }

            db.Entry(pairing).State = EntityState.Modified;

            try
            {
                await db.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!pairingExists(id))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return StatusCode(HttpStatusCode.NoContent);
        }

        // POST: api/pairings
        [ResponseType(typeof(pairing))]
        public async Task<IHttpActionResult> Postpairing(pairing pairing)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            db.pairings.Add(pairing);
            await db.SaveChangesAsync();

            return CreatedAtRoute("DefaultApi", new { id = pairing.id }, pairing);
        }

        // DELETE: api/pairings/5
        [ResponseType(typeof(pairing))]
        public async Task<IHttpActionResult> Deletepairing(int id)
        {
            pairing pairing = await db.pairings.FindAsync(id);
            if (pairing == null)
            {
                return NotFound();
            }

            db.pairings.Remove(pairing);
            await db.SaveChangesAsync();

            return Ok(pairing);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool pairingExists(int id)
        {
            return db.pairings.Count(e => e.id == id) > 0;
        }
    }
}