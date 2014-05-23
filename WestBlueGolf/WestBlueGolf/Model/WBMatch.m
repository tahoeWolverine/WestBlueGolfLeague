#import "WBMatch.h"
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
	NSArray *matches = [self.teamMatchup orderedMatches];
	NSInteger index = [matches indexOfObject:self];
	return index + 1;
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
	NSArray *filteredResults = [self.results.allObjects filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"team = %@", team]];
	return filteredResults && filteredResults.count > 0 ? filteredResults[0] : nil;
}

- (NSArray *)displayStrings {
	WBTeam *team1 = self.teamMatchup.teams.allObjects[0];
	WBTeam *team2 = self.teamMatchup.teams.allObjects[1];
	NSInteger team1Points = [self.teamMatchup totalPointsForTeam:team1];
	NSInteger team2Points = [self.teamMatchup totalPointsForTeam:team2];
	WBTeam *winner = (team1Points > team2Points) ? team1 : team2;
	WBTeam *loser = team1 == winner ? team2 : team1;
	
	WBResult *winnerResult = [self resultForTeam:winner];
	WBResult *loserResult = [self resultForTeam:loser];
	NSString *player1Name = winnerResult ? [winnerResult.player shortName] : @"No Player";
	NSString *player2Name = loserResult ? [loserResult.player shortName] : @"No Player";
	NSString *player1Score = winnerResult ? [NSString stringWithFormat:@"%@", winnerResult.score] : @"-";
	NSString *player2Score = loserResult ? [NSString stringWithFormat:@"%@", loserResult.score] : @"-";
	NSString *matchPoints = winnerResult && loserResult ? [NSString stringWithFormat:@"%@/%@", winnerResult.points, loserResult.points] : @"0";
	return @[player1Name, player1Score, player2Name, player2Score, matchPoints];
}

@end
