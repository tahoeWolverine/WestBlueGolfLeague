using System;
using System.Collections.Generic;
using System.Linq;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Schedule
{
    public class GolfYear
    {
        private List<pairing> pairings;
        private int numberOfWeeks;
        private List<DateTimeOffset> selectedDates;
        private List<team> teams;
        private List<course> courses;

        public GolfYear(IEnumerable<team> teams, List<DateTimeOffset> selectedDates, List<pairing> pairings, IEnumerable<course> courses)
        {
            this.teams = teams.ToList();
            this.selectedDates = selectedDates.OrderBy(x => x).ToList();
            this.numberOfWeeks = selectedDates.Count;
            this.pairings = pairings;
            this.courses = courses.ToList();

            this.CreateTeamYearData();

            // super hack to allow league subs and dummy no show team to be carried over, but not part of the schedule.
            this.teams = this.teams.Where(x => !string.Equals(x.teamName, "league subs", StringComparison.OrdinalIgnoreCase) && x.id != 1)
				.OrderBy(x => x.teamName).ToList();

            this.CreateSchedule();
        }

        public List<week> CreatedWeeks { get; private set; }
        public List<teammatchup> CreatedMatchups { get; private set; }
        public List<teamyeardata> CreatedTeamYearDatas { get; private set; }
        public year CreatedYear { get; private set; }

        private void CreateTeamYearData()
        {
            // first, create the year
            // TODO: remove hardcoded 2017.
            this.CreatedYear = new year { value = 2018, isComplete = false };
            this.CreatedTeamYearDatas = new List<teamyeardata>(this.teams.Count);

            // create team year datas.
            foreach (team t in this.teams)
            {
                var tyd = new teamyeardata { team = t, year = this.CreatedYear };

                //t.teamyeardata.Add(tyd);
                this.CreatedTeamYearDatas.Add(tyd);
            }
        }

        // Creates a schedule given the inputs
        private void CreateSchedule()
        {
            team anchorTeam = teams.First();

            List<team> restOfTeams = teams.Skip(1).ToList();
            LinkedList<teammatchup> createdMatchups = new LinkedList<teammatchup>();
            LinkedList<week> createdWeeks = new LinkedList<week>();

            int pairingIndex = 0;

            // This does a round robin algorithm in place on the teams.  It assumes
            // an even number of teams.  Is uses the first team as the "anchor" of the algorithm.
            for (int i = 0, j = 0; j < this.numberOfWeeks; 
                i = (i - 1 < 0 ? restOfTeams.Count - 1 : i - 1), 
                j++,
                pairingIndex++)
            {
                // Note that weeks are 1 based
                week currentWeek = new week { seasonIndex = j + 1, date = this.selectedDates[j].DateTime, pairing = pairings[pairingIndex % pairings.Count], course = courses[j % courses.Count] };
                createdWeeks.AddLast(currentWeek);

                // create anchor matchup.
                createdMatchups.AddLast(this.CreateTeamMatchup(anchorTeam, restOfTeams[i], currentWeek, 0));

                for (int k = 0; k < restOfTeams.Count / 2; k++)
                {
                    int team1Index = i + 1 + k;
                    if (team1Index > restOfTeams.Count - 1) team1Index = team1Index % restOfTeams.Count;

                    int team2Index = i - 1 - k;
                    if (team2Index < 0) team2Index = restOfTeams.Count + team2Index;

                    createdMatchups.AddLast(this.CreateTeamMatchup(restOfTeams[team1Index], restOfTeams[team2Index], currentWeek, k + 1));
                }
            }

            this.CreatedMatchups = createdMatchups.ToList();
            this.CreatedWeeks = createdWeeks.ToList();

            this.AssignTeeTimes2();
        }

        private teammatchup CreateTeamMatchup(team team1, team team2, week week, int matchOrder)
        {
            var tm = new teammatchup { week = week, matchOrder = matchOrder, matchComplete = false };
            tm.teams.Add(team1);
            tm.teams.Add(team2);

            return tm;
        }

        /// <summary>
        /// This assumes we've already build the "schedule".
        /// </summary>
        private void AssignTeeTimes()
        {
            int[] teeTimes = new int[4];

            for (int i = 0; i < teeTimes.Length; i++)
            {
                teeTimes[i] = i;
            }

            int anchorIndex = 1; // deemed to be the most "fair".

            var groupedMatches = this.CreatedMatchups.GroupBy(x => x.week.seasonIndex).OrderBy(x => x.Key);
            
            foreach (var grouping in groupedMatches)
            {
                var sortedMatchUps = grouping.OrderBy(x => x.matchOrder).ToList();

                for (int j = 0; j < sortedMatchUps.Count; j++)
                {
                    sortedMatchUps[j].matchOrder = teeTimes[j];
                }

                this.RotateTeeTimes(teeTimes, anchorIndex);
            }
        }

		/// <summary>
		/// This assumes we've already built the "schedule".
		/// </summary>
		private void AssignTeeTimes2()
		{
			int numOfTeeTimes = this.teams.Count / 2;

			int[] teeTimes = new int[4];

			for (int i = 0; i < teeTimes.Length; i++)
			{
				teeTimes[i] = i;
			}

			int anchorIndex = 1; // deemed to be the most "fair".

			var groupedMatches = this.CreatedMatchups.GroupBy(x => x.week.seasonIndex).OrderBy(x => x.Key).ToList();

			for (int i = 0; i < this.teams.Count - 1 && i < groupedMatches.Count; i++)
			{
				var sortedMatchUps = groupedMatches[i].OrderBy(x => x.matchOrder).ToList();

				for (int j = 0; j < sortedMatchUps.Count; j++)
				{
					sortedMatchUps[j].matchOrder = teeTimes[j];
				}

				this.RotateTeeTimes(teeTimes, anchorIndex);
			}

			for (int i = this.teams.Count - 1; i < groupedMatches.Count; i++)
			{
				var sortedMatchups = groupedMatches[i].OrderBy(x => x.matchOrder).ToList();
				// TODO: not sure if the original matchups will be in the correct order anymore.
				var originalMatchups = groupedMatches[i - (this.teams.Count - 1)].ToList();

				for (int j = 0; j < sortedMatchups.Count(); j++)
				{
					sortedMatchups[j].matchOrder = (numOfTeeTimes - 1) - originalMatchups[j].matchOrder;
				}
			}
		}

        /// <summary>
        /// Performs the tee time rotation, which tries to evenly distribute the season's tee times across
        /// the season.
        /// </summary>
        /// <param name="teeTimes"></param>
        /// <param name="anchorIndex"></param>
        private void RotateTeeTimes(int[] teeTimes, int anchorIndex)
        {
            Dictionary<int, int> indexMapping = new Dictionary<int, int>();

            for (int i = 0; i < teeTimes.Length; i++)
            {
                int newIndex = 0;

                if (i == anchorIndex) { newIndex = anchorIndex; }
                else if ((i + 1) % teeTimes.Length == anchorIndex) { newIndex = (anchorIndex + 1) % teeTimes.Length; }
                else { newIndex = (i + 1) % teeTimes.Length; }

                indexMapping[teeTimes[i]] = newIndex;
            }

            foreach (var kvp in indexMapping)
            {
                teeTimes[kvp.Value] = kvp.Key;
            }
        }

        public void PersistSchedule(WestBlue db)
        {
            db.years.Add(this.CreatedYear);
            db.teamyeardatas.AddRange(this.CreatedTeamYearDatas);

            db.teammatchups.AddRange(this.CreatedMatchups);
            db.weeks.AddRange(this.CreatedWeeks);
        }
    }
}