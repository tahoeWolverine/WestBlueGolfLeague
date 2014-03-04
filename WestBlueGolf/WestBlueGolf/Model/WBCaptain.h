#import "_WBCaptain.h"

@interface WBCaptain : _WBCaptain {}

+ (WBCaptain *)createCaptainWithId:(NSInteger)captainId
						  username:(NSString *)username
						  password:(NSString *)password
							  name:(NSString *)name
				   currentHandicap:(NSInteger)currentHandicap
							onTeam:(WBTeam *)currentTeam;

- (void)deleteCaptain;

@end
