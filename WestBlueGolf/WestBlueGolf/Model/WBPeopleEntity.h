#import "_WBPeopleEntity.h"

@interface WBPeopleEntity : _WBPeopleEntity {}

+ (WBPeopleEntity *)baseCreatePeopleWithName:(NSString *)name;
- (void)deletePlayer;

@end
