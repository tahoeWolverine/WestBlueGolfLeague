#import "WBTeam.h"
#import "WBCoreDataManager.h"

@interface WBTeam ()

@end

@implementation WBTeam

+ (WBTeam *)createTeamWithName:(NSString *)name {
	WBTeam *newTeam = [NSEntityDescription insertNewObjectForEntityForName:@"WBTeam" inManagedObjectContext:[[self class] managedObjectContext]];
	newTeam.name = name;
	
	[[WBCoreDataManager sharedManager] saveContext];
	return newTeam;
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

- (WBCaptain *)captain {
	for (id player in self.players) {
		if ([player isKindOfClass:[WBCaptain class]]) {
			return player;
		}
	}
	
	return nil;
}

@end
