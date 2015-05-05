using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
	public class PlayerWebResponse
	{
		public PlayerWebResponse()
		{
		}

		public PlayerWebResponse(player player)
		{
			this.Name = player.name;
			this.CurrentHandicap = player.currentHandicap;
			this.Id = player.id;
		}

		public string Name { get; set; }

		public int CurrentHandicap { get; set; }

		public int Id { get; set; }
	}
}