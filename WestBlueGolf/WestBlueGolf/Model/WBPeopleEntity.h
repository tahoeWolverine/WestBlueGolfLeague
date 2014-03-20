#import "_WBPeopleEntity.h"

@interface WBPeopleEntity : _WBPeopleEntity {}

+ (WBPeopleEntity *)createPeopleWithName:(NSString *)name inContext:(NSManagedObjectContext *)moc;

+ (WBPeopleEntity *)leagueAverageInContext:(NSManagedObjectContext *)moc;
- (BOOL)isLeagueAverage;

+ (WBPeopleEntity *)peopleEntityWithName:(NSString *)name;

- (NSString *)shortName;
- (NSString *)firstName;

@end
