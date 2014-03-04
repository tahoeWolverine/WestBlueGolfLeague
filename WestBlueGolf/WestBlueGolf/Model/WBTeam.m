#import "WBTeam.h"
#import "WBCoreDataManager.h"

@interface WBTeam ()

@end

@implementation WBTeam

+ (WBTeam *)createTeamWithName:(NSString *)name {
	WBTeam *newTeam = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] managedObjectContext]];
	newTeam.name = name;
	
	[WBCoreDataManager saveContext];
	return newTeam;
}

- (void)deleteTeam {
	[[[self class] managedObjectContext] deleteObject:self];
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
