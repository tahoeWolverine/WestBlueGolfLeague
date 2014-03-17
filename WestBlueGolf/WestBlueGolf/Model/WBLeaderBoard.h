#import "_WBLeaderBoard.h"

@class WBPeopleEntity;

@interface WBLeaderBoard : _WBLeaderBoard {}

+ (WBLeaderBoard *)createLeaderBoardWithName:(NSString *)name
										 key:(NSString *)key
							   tablePriority:(NSInteger)tablePriority
							   isPlayerBoard:(BOOL)isPlayerBoard;

// Lazy accessor
+ (WBLeaderBoard *)leaderBoardWithName:(NSString *)name key:(NSString *)key tablePriority:(NSInteger)tablePriority isPlayerBoard:(BOOL)isPlayerBoard;

- (NSArray *)winnerData;

@end
