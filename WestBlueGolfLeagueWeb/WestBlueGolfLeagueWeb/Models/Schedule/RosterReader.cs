using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Schedule
{
	public class RosterReader : IDisposable
	{
		private StreamReader fileReader;

		public RosterReader(Stream stream)
		{
			this.fileReader = new StreamReader(stream, Encoding.UTF8);
		}

		public IEnumerable<TeamRoster> GetRoster(IEnumerable<team> teamsToLookFor)
		{
			List<TeamRoster> results = new List<TeamRoster>();
			string line;
			bool lastLineNewLine = false;
			bool firstLine = true;
			TeamRoster currentResult = null;

			var teamLookup = teamsToLookFor.ToDictionary(x => x.teamName);

			while ((line = this.fileReader.ReadLine()) != null)
			{
				string trimmedLine = line.Trim();

				if (string.IsNullOrEmpty(trimmedLine))
				{
					lastLineNewLine = true;
					firstLine = false;
					continue;
				}

				if (lastLineNewLine || firstLine)
				{
					team currentTeam;
					if (!teamLookup.TryGetValue(trimmedLine, out currentTeam))
					{
						throw new Exception("Illegal roster format! Could not find team name of " + trimmedLine +
						                    " in list of selected teams.");
					}

					currentResult = new TeamRoster(currentTeam);
					results.Add(currentResult);
				}
				else
				{
					// should be a player here.  Create player.
					currentResult.AddPlayer(trimmedLine);
				}

				firstLine = false;
				lastLineNewLine = false;
			}

            // Hack to carry over dummy team without having to do it in the UI.
            if (teamsToLookFor.Any(x => x.id == 1))
            {
                var dummyTeamRoster = new TeamRoster(teamsToLookFor.First(x => x.id == 1));
                dummyTeamRoster.AddPlayer("No Show");
                dummyTeamRoster.AddPlayer("Non-League Sub");

                results.Add(dummyTeamRoster);
            }

			return results;
		}  

		public void Dispose()
		{
			this.fileReader.Dispose();
		}
	}
}