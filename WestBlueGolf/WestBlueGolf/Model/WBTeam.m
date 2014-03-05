#import "WBTeam.h"
#import "WBCoreDataManager.h"

@interface WBTeam ()

@end

@implementation WBTeam

+ (WBTeam *)createTeamWithName:(NSString *)name id:(NSInteger)teamId {
	WBTeam *newTeam = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] managedObjectContext]];
	newTeam.name = name;
	newTeam.teamIdValue = teamId;
	
	[WBCoreDataManager saveContext];
	return newTeam;
}

- (void)deleteTeam {
	[[[self class] managedObjectContext] deleteObject:self];
}

+ (WBTeam *)teamWithId:(NSInteger)teamId {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"teamId = %@", [NSNumber numberWithInteger:teamId]];
	NSArray *teams = [[WBCoreDataManager class] findWithPredicate:predicate forEntity:[[self class] entityName]];
	return [teams lastObject];
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

@end
