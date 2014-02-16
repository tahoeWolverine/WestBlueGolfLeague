#import "_WBTeam.h"
#import "WBCaptain.h"

@interface WBTeam : _WBTeam {}

+ (WBTeam *)createTeamWithName:(NSString *)name;

- (WBCaptain *)captain;

@end
