#import "_WBTeam.h"
#import "WBCaptain.h"

@interface WBTeam : _WBTeam {}

+ (WBTeam *)createTeamWithName:(NSString *)name;

- (void)deleteTeam;

- (WBCaptain *)captain;

@end
