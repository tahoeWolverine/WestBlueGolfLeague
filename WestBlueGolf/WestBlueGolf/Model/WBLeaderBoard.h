#import "_WBLeaderBoard.h"

@class WBPeopleEntity;

@interface WBLeaderBoard : _WBLeaderBoard {}

+ (WBLeaderBoard *)createLeaderBoardWithName:(NSString *)name
										 key:(NSString *)key
							   tablePriority:(NSInteger)tablePriority
							   isPlayerBoard:(BOOL)isPlayerBoard;

- (WBBoardData *)winnerData;

@end
