using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Services
{
    public class ScheduleCreator
    {
        // Creates a schedule given the inputs
        // Still TODO:
        // - associating courses with weeks
        // - evenly distrubiting start times (match order/start time)
        // - 
        public void CreateSchedule(List<team> teams, DateTimeOffset dateToStart, int numberOfWeeks, List<pairing> pairings)
        {
            team anchorTeam = teams.First();

            List<team> restOfTeams = teams.Skip(1).ToList();
            LinkedList<teammatchup> createdMatchups = new LinkedList<teammatchup>();
            LinkedList<week> createdWeeks = new LinkedList<week>();

            int pairingIndex = 0;

            // This does a round robin algorithm in place on the teams.  It assumes
            // an even number of teams.
            for (int i = 0, j = 0; j < numberOfWeeks; 
                i = (i - 1 < 0 ? restOfTeams.Count : i - 1), 
                j++, 
                dateToStart.AddDays(7), 
                pairingIndex++)
            {
                // Note that weeks are 1 based
                // TODO: courses
                week currentWeek = new week { seasonIndex = j + 1, date = dateToStart.DateTime, pairing = pairings[pairingIndex % pairings.Count] };
                createdWeeks.AddLast(currentWeek);

                // create the anchor matchup // TODO: fix the match order param.
                createdMatchups.AddLast(this.CreateTeamMatchup(anchorTeam, restOfTeams[i], currentWeek, 0));

                for (int k = 0; i < restOfTeams.Count / 2; k++)
                {
                    int team1Index = i + 1 + k;
                    if (team1Index > restOfTeams.Count - 1) team1Index = team1Index % restOfTeams.Count;

                    int team2Index = i - 1 - k;
                    if (team2Index < 0) team2Index = restOfTeams.Count + team2Index;

                    // TODO: fix the match order param.
                    createdMatchups.AddLast(this.CreateTeamMatchup(restOfTeams[team1Index], restOfTeams[team2Index], currentWeek, k));
                }
            }

            // TODO: assign tee times somehow
        }

        public teammatchup CreateTeamMatchup(team team1, team team2, week week, int matchOrder)
        {
            var tm = new teammatchup { week = week, matchOrder = matchOrder, matchComplete = false };
            tm.teams.Add(team1);
            tm.teams.Add(team2);

            return tm;
        }
    }
}