#import "WBMatch.h"
#import "WBCoreDataManager.h"
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

@end
