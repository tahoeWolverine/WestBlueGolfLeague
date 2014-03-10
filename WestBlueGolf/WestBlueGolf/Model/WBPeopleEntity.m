#import "WBPeopleEntity.h"
#import "WBCoreDataManager.h"

@interface WBPeopleEntity ()
@end

@implementation WBPeopleEntity

+ (WBPeopleEntity *)baseCreatePeopleWithName:(NSString *)name entityName:(NSString *)entName {
	WBPeopleEntity *newPeople = [NSEntityDescription insertNewObjectForEntityForName:entName inManagedObjectContext:[self managedObjectContext]];
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
