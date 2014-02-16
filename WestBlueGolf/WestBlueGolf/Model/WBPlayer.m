#import "WBPlayer.h"
#import "WBCoreDataManager.h"
#import "WBTeam.h"

@interface WBPlayer ()

@end

@implementation WBPlayer

+ (WBPlayer *)createPlayerWithName:(NSString *)name
				   currentHandicap:(NSInteger)currentHandicap
							onTeam:(WBTeam *)currentTeam {
	WBPlayer *newPlayer = [NSEntityDescription insertNewObjectForEntityForName:@"WBPlayer" inManagedObjectContext:[[self class] managedObjectContext]];
	newPlayer.name = name;
	newPlayer.currentHandicapValue = currentHandicap;
	
	[currentTeam addPlayersObject:newPlayer];
	
	[[WBCoreDataManager sharedManager] saveContext];
	return newPlayer;
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

@end
