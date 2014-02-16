#import "_WBPlayer.h"

@interface WBPlayer : _WBPlayer {}

+ (WBPlayer *)createPlayerWithName:(NSString *)name
				   currentHandicap:(NSInteger)currentHandicap
							onTeam:(WBTeam *)currentTeam;

@end
