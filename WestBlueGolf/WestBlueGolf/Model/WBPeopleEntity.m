#import "WBPeopleEntity.h"
#import "WBCoreDataManager.h"

@interface WBPeopleEntity ()
@end

@implementation WBPeopleEntity

+ (WBPeopleEntity *)createPeopleWithName:(NSString *)name {
	id entity = [self createEntity];
	WBPeopleEntity *newPeople = (WBPeopleEntity *)entity;
	newPeople.name = name;
	return newPeople;
}

@end
