#import "WBMatch.h"
#import "WBCoreDataManager.h"
#import "WBPlayer.h"
#import "WBResult.h"
#import "WBTeamMatchup.h"

@interface WBMatch ()

@end

@implementation WBMatch

+ (WBMatch *)createMatchForTeamMatchup:(WBTeamMatchup *)teamMatchup
							   player1:(WBPlayer *)player1
							   player2:(WBPlayer *)player2
								   moc:(NSManagedObjectContext *)moc {
	WBMatch *newMatch = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];

	// When matches only have one player (vs XX No Show XX), it should be ok to only have 1 on match
	if (player1) {
		[newMatch addPlayersObject:player1];
	}
	
	if (player2) {
		[newMatch addPlayersObject:player2];
	}
	
	[teamMatchup addMatchesObject:newMatch];
	return newMatch;
}

- (NSInteger)pairing {
	WBTeamMatchup *matchup = self.teamMatchup;
	NSInteger pairing = 1;
	for (WBMatch *match in matchup.matches) {
		if (match == self) {
			continue;
		}
		
		if ([self greaterPairingThanMatch:match]) {
			pairing++;
		}
	}
	return pairing;
}

- (BOOL)greaterPairingThanMatch:(WBMatch *)match {
	for (WBResult *result in self.results) {
		WBTeam *team = result.team;
		WBResult *otherMatchResult = [match resultForTeam:team];
		if (result.priorHandicapValue > otherMatchResult.priorHandicapValue) {
			return YES;
		}
	}
	return NO;
}

- (WBResult *)resultForTeam:(WBTeam *)team {
	return [self.results.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"team = %@", team]][0];
}

- (NSArray *)displayStrings {
	WBTeam *team1 = self.teamMatchup.teams.allObjects[0];
	WBTeam *team2 = self.teamMatchup.teams.allObjects[1];
	NSInteger team1Points = [self.teamMatchup totalPointsForTeam:team1];
	NSInteger team2Points = [self.teamMatchup totalPointsForTeam:team2];
	WBTeam *winner = (team1Points > team2Points) ? team1 : team2;
	WBTeam *loser = team1 == winner ? team2 : team1;
	
	WBResult *winnerResult = [self.results.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"team = %@", winner]][0];
	WBResult *loserResult = [self.results.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"team = %@", loser]][0];
	NSString *player1Name = [winnerResult.player shortName];
	NSString *player2Name = [loserResult.player shortName];
	NSString *player1Score = [NSString stringWithFormat:@"%@", winnerResult.score];
	NSString *player2Score = [NSString stringWithFormat:@"%@", loserResult.score];
	NSString *matchPoints = [NSString stringWithFormat:@"%@/%@", winnerResult.points, loserResult.points];
	return @[player1Name, player1Score, player2Name, player2Score, matchPoints];
}

@end
