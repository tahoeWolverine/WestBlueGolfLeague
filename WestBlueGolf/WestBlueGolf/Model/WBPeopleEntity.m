#import "WBPeopleEntity.h"
#import "WBCoreDataManager.h"

@interface WBPeopleEntity ()
@end

@implementation WBPeopleEntity

+ (WBPeopleEntity *)baseCreatePeopleWithName:(NSString *)name {
	WBPeopleEntity *newPeople = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] managedObjectContext]];
	newPeople.name = name;
	return newPeople;
}

- (void)deletePlayer {
	[[[self class] managedObjectContext] deleteObject:self];
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

@end
