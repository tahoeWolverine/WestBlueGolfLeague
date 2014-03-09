#import "_WBBoardData.h"
#import "WBPeopleEntity.h"

@interface WBBoardData : _WBBoardData {}

+ (WBBoardData *)createBoardDataForEntity:(WBPeopleEntity *)entity
								leaderBoard:(WBLeaderBoard *)leaderBoard
									  value:(NSInteger)value
									   rank:(NSInteger)rank;

- (void)deleteBoardData;

- (NSString *)rankString;

@end
