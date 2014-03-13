#import "_WBPeopleEntity.h"

@interface WBPeopleEntity : _WBPeopleEntity {}

+ (WBPeopleEntity *)createPeopleWithName:(NSString *)name;

+ (WBPeopleEntity *)leagueAverage;
- (BOOL)isLeagueAverage;

+ (WBPeopleEntity *)peopleEntityWithName:(NSString *)name;

- (NSString *)shortName;
- (NSString *)firstName;

@end
