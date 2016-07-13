select 
    /*tm.id as teamMatchupId*/
	tm.id,
	tm.matchComplete,
	tm.weekId,
	tm.playoffType,
	matches.*
from
    teammatchup tm
        inner join
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
		r.scoreVariant
    from
        `match` m
    left outer join result r ON m.id = r.matchId) matches ON matches.teamMatchupId = tm.id
        inner join
    (select 
        w.id as joinedWeekId
    FROM
        week w
    inner join `year` y ON y.id = w.yearId
    WHERE
        y.value = 2016) yy ON yy.joinedWeekId = tm.weekId;
		

/*With players:	*/	
select 
	tm.id as teamMatchupId,
	tm.matchComplete,
	tm.weekId,
	tm.playoffType,
	matches.resultId as id,
	matches.*
from
    teammatchup tm
        inner join
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
        y.value = 2016) yy ON yy.joinedWeekId = tm.weekId;