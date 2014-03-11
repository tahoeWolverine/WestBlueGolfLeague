#import "_WBPeopleEntity.h"

@interface WBPeopleEntity : _WBPeopleEntity {}

+ (WBPeopleEntity *)createPeopleWithName:(NSString *)name;

+ (WBPeopleEntity *)leagueAverage;

- (BOOL)isLeagueAverage;

@end
