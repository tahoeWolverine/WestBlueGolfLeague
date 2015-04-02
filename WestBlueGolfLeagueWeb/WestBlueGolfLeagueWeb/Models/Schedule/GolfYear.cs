using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Schedule
{
    public class GolfYear
    {
        private List<pairing> pairings;
        private int numberOfWeeks;
        private DateTimeOffset dateToStart;
        private List<team> teams;
        private IEnumerable<course> courses;

        public GolfYear(List<team> teams, DateTimeOffset dateToStart, int numberOfWeeks, List<pairing> pairings, IEnumerable<course> courses)
        {
            this.teams = teams;
            this.dateToStart = dateToStart;
            this.numberOfWeeks = numberOfWeeks;
            this.pairings = pairings;
            this.courses = courses;

            this.CreateTeamYearData();

            this.CreateSchedule();
        }

        public List<week> CreatedWeeks { get; private set; }
        public List<teammatchup> CreatedMatchups { get; private set; }
        public List<teamyeardata> CreatedTeamYearDatas { get; private set; }
        public year CreatedYear { get; private set; }

        private void CreateTeamYearData()
        {
            // first, create the year
            // TODO: remove hardcoded 2015.
            this.CreatedYear = new year { value = 2015, isComplete = false };
            this.CreatedTeamYearDatas = new List<teamyeardata>(this.teams.Count);

            // create team year datas.
            foreach (team t in this.teams)
            {
                var tyd = new teamyeardata { team = t, year = this.CreatedYear };

                t.teamyeardata.Add(tyd);
                this.CreatedTeamYearDatas.Add(tyd);
            }
        }

        // Creates a schedule given the inputs
        // Still TODO:
        // - associating courses with weeks
        // - evenly distrubuting start times (match order/start time)
        // - 
        private void CreateSchedule()
        {
            team anchorTeam = teams.First();

            List<team> restOfTeams = teams.Skip(1).ToList();
            LinkedList<teammatchup> createdMatchups = new LinkedList<teammatchup>();
            LinkedList<week> createdWeeks = new LinkedList<week>();

            int pairingIndex = 0;

            // This does a round robin algorithm in place on the teams.  It assumes
            // an even number of teams.  Is uses the first team as the "anchor" of the algorithm.
            for (int i = 0, j = 0; j < numberOfWeeks; 
                i = (i - 1 < 0 ? restOfTeams.Count - 1 : i - 1), 
                j++,
                dateToStart = dateToStart.AddDays(7), 
                pairingIndex++)
            {
                // Note that weeks are 1 based
                // TODO: courses
                week currentWeek = new week { seasonIndex = j + 1, date = dateToStart.DateTime, pairing = pairings[pairingIndex % pairings.Count], course = courses.First() };
                createdWeeks.AddLast(currentWeek);

                // create the anchor matchup // TODO: fix the match order param.
                createdMatchups.AddLast(this.CreateTeamMatchup(anchorTeam, restOfTeams[i], currentWeek, 0));

                for (int k = 0; k < restOfTeams.Count / 2; k++)
                {
                    int team1Index = i + 1 + k;
                    if (team1Index > restOfTeams.Count - 1) team1Index = team1Index % restOfTeams.Count;

                    int team2Index = i - 1 - k;
                    if (team2Index < 0) team2Index = restOfTeams.Count + team2Index;

                    // TODO: fix the match order param.
                    createdMatchups.AddLast(this.CreateTeamMatchup(restOfTeams[team1Index], restOfTeams[team2Index], currentWeek, k + 1));
                }
            }

            this.CreatedMatchups = createdMatchups.ToList();
            this.CreatedWeeks = createdWeeks.ToList();

            // TODO: assign tee times somehow
        }

        private teammatchup CreateTeamMatchup(team team1, team team2, week week, int matchOrder)
        {
            var tm = new teammatchup { week = week, matchOrder = matchOrder, matchComplete = false };
            tm.teams.Add(team1);
            tm.teams.Add(team2);

            return tm;
        }

        public async Task PersistScheduleAsync(WestBlue db)
        {
            db.years.Add(this.CreatedYear);
            db.teamyeardatas.AddRange(this.CreatedTeamYearDatas);

            db.teammatchups.AddRange(this.CreatedMatchups);
            db.weeks.AddRange(this.CreatedWeeks);

            await db.SaveChangesAsync();
        }
    }
}