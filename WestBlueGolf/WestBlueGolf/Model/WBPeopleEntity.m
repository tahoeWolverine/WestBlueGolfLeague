#import "WBPeopleEntity.h"
#import "WBCoreDataManager.h"

#define LEAGUE_AVERAGE_NAME @"=League Average="

@interface WBPeopleEntity ()
@end

@implementation WBPeopleEntity

+ (WBPeopleEntity *)createPeopleWithName:(NSString *)name {
	id entity = [self createEntity];
	WBPeopleEntity *newPeople = (WBPeopleEntity *)entity;
	newPeople.name = name;
	return newPeople;
}

+ (WBPeopleEntity *)leagueAverage {
	WBPeopleEntity *avg = (WBPeopleEntity *)[self findFirstRecordWithPredicate:[NSPredicate predicateWithFormat:@"name = %@", LEAGUE_AVERAGE_NAME] sortedBy:nil];
	if (!avg) {
		avg = [WBPeopleEntity createPeopleWithName:LEAGUE_AVERAGE_NAME];
	}
	return avg;
}

- (BOOL)isLeagueAverage {
	return [self.name isEqualToString:LEAGUE_AVERAGE_NAME];
}

@end
