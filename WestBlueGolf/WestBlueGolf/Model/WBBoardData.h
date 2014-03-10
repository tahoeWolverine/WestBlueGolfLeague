#import "_WBBoardData.h"
#import "WBPeopleEntity.h"

@interface WBBoardData : _WBBoardData {}

+ (WBBoardData *)createBoardDataForEntity:(WBPeopleEntity *)entity
								leaderBoard:(WBLeaderBoard *)leaderBoard
									  value:(double)value
									   rank:(NSInteger)rank;

- (NSString *)rankString;

@end
