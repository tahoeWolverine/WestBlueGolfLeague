#import "WBCaptain.h"
#import "WBCoreDataManager.h"
#import "WBTeam.h"

@interface WBCaptain ()

@end

@implementation WBCaptain

+ (WBCaptain *)createCaptainWithName:(NSString *)name
					 currentHandicap:(NSInteger)currentHandicap
							  onTeam:(WBTeam *)currentTeam {
	WBCaptain *newCaptain = [NSEntityDescription insertNewObjectForEntityForName:@"WBCaptain" inManagedObjectContext:[[self class] managedObjectContext]];
	newCaptain.name = name;
	newCaptain.currentHandicapValue = currentHandicap;

	[currentTeam addPlayersObject:newCaptain];
	
	[[WBCoreDataManager sharedManager] saveContext];
	return newCaptain;
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

@end
