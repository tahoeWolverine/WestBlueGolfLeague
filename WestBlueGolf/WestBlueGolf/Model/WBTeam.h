#import "_WBTeam.h"

@interface WBTeam : _WBTeam {}

+ (WBTeam *)createTeamWithName:(NSString *)name id:(NSInteger)teamId;

- (void)deleteTeam;

+ (WBTeam *)teamWithId:(NSInteger)teamId;

@end
