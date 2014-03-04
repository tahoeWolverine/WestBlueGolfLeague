#import "_WBPlayer.h"

@interface WBPlayer : _WBPlayer {}

// Function to be used in each variant of player for creation (does not save context, so as to not trip value requirements)
+ (WBPlayer *)baseCreatePlayerWithName:(NSString *)name
					  currentHandicap:(NSInteger)currentHandicap
							   onTeam:(WBTeam *)currentTeam;

// Player specific create function
+ (WBPlayer *)createPlayerWithName:(NSString *)name
				   currentHandicap:(NSInteger)currentHandicap
							onTeam:(WBTeam *)currentTeam;

- (NSString *)shortName;

@end
