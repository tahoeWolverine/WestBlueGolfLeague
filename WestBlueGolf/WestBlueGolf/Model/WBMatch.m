#import "WBMatch.h"
#import "WBCoreDataManager.h"
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

@end
