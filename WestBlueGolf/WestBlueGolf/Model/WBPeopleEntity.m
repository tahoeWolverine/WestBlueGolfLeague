#import "WBPeopleEntity.h"
#import "WBCoreDataManager.h"

@interface WBPeopleEntity ()
@end

@implementation WBPeopleEntity

+ (WBPeopleEntity *)baseCreatePeopleWithName:(NSString *)name entityName:(NSString *)entName {
	WBPeopleEntity *newPeople = [NSEntityDescription insertNewObjectForEntityForName:entName inManagedObjectContext:[self context]];
	newPeople.name = name;
	return newPeople;
}

@end
