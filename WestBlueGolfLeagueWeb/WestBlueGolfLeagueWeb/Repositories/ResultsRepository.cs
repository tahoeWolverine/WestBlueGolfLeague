using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.MappedEntities;

namespace WestBlueGolfLeagueWeb.Repositories
{
    public class ResultsRepository
    {
        private WestBlue db;

        public ResultsRepository(WestBlue db)
        {
            this.db = db;
        }

        public async Task<IEnumerable<FlattenedResult>> GetResultsForYear(int year)
        {
            string query = @"select 
                            tm.id as teamMatchupId,
	                        tm.matchComplete,
	                        tm.weekId,
	                        tm.playoffType,
	                        matches.resultId as id,
	                        matches.*
                        from
                            teammatchup tm
                                inner
                        join

                        (select
                        m.id as matchId,
		                        m.matchOrder,
		                        m.teamMatchupId,
		                        r.score,
		                        r.points,
		                        r.teamId,
		                        r.playerId,
		                        r.id as resultId,
		                        r.priorHandicap,
		                        r.scoreVariant,
		                        p.name
                            from
                                `match` m
                            left outer join result r ON m.id = r.matchId

                            inner join player p ON r.playerId = p.id
                        ) matches ON matches.teamMatchupId = tm.id
                                inner join
                            (select
                                w.id as joinedWeekId
                            FROM
                                week w
                            inner join `year` y ON y.id = w.yearId
                            WHERE
                                y.value = @year) yy ON yy.joinedWeekId = tm.weekId; ";

            return await this.db.Database.SqlQuery<FlattenedResult>(query, new SqlParameter("@year", year)).ToListAsync();
        }
    }
}