using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Web.Http.Description;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class matchupsController : ApiController
    {
        private WestBlue db = new WestBlue();

        // GET: api/matchups
        public IQueryable<matchup> Getmatchups()
        {
            return db.matchups;
        }

        // GET: api/matchups/5
        [ResponseType(typeof(matchup))]
        public IHttpActionResult Getmatchup(int id)
        {
            matchup matchup = db.matchups.Find(id);
            if (matchup == null)
            {
                return NotFound();
            }

            return Ok(matchup);
        }

        //// PUT: api/matchups/5
        //[ResponseType(typeof(void))]
        //public IHttpActionResult Putmatchup(int id, matchup matchup)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        return BadRequest(ModelState);
        //    }

        //    if (id != matchup.id)
        //    {
        //        return BadRequest();
        //    }

        //    db.Entry(matchup).State = EntityState.Modified;

        //    try
        //    {
        //        db.SaveChanges();
        //    }
        //    catch (DbUpdateConcurrencyException)
        //    {
        //        if (!matchupExists(id))
        //        {
        //            return NotFound();
        //        }
        //        else
        //        {
        //            throw;
        //        }
        //    }

        //    return StatusCode(HttpStatusCode.NoContent);
        //}

        //// POST: api/matchups
        //[ResponseType(typeof(matchup))]
        //public IHttpActionResult Postmatchup(matchup matchup)
        //{
        //    if (!ModelState.IsValid)
        //    {
        //        return BadRequest(ModelState);
        //    }

        //    db.matchups.Add(matchup);
        //    db.SaveChanges();

        //    return CreatedAtRoute("DefaultApi", new { id = matchup.id }, matchup);
        //}

        //// DELETE: api/matchups/5
        //[ResponseType(typeof(matchup))]
        //public IHttpActionResult Deletematchup(int id)
        //{
        //    matchup matchup = db.matchups.Find(id);
        //    if (matchup == null)
        //    {
        //        return NotFound();
        //    }

        //    db.matchups.Remove(matchup);
        //    db.SaveChanges();

        //    return Ok(matchup);
        //}

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        private bool matchupExists(int id)
        {
            return db.matchups.Count(e => e.id == id) > 0;
        }
    }
}