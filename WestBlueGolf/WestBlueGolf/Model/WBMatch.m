#import "WBMatch.h"
#import "WBCoreDataManager.h"
#import "WBTeamMatchup.h"

@interface WBMatch ()

@end

@implementation WBMatch

+ (WBMatch *)createMatchForTeamMatchup:(WBTeamMatchup *)teamMatchup
							   player1:(WBPlayer *)player1
							   player2:(WBPlayer *)player2 {
	WBMatch *newMatch = [NSEntityDescription insertNewObjectForEntityForName:@"WBMatch" inManagedObjectContext:[[self class] managedObjectContext]];
	[newMatch addPlayersObject:player1];
	[newMatch addPlayersObject:player2];
	
	[teamMatchup addMatchesObject:newMatch];
	
	[[WBCoreDataManager sharedManager] saveContext];
	return newMatch;
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

@end
