#import "_WBBoardData.h"
#import "WBPeopleEntity.h"

@interface WBBoardData : _WBBoardData {}

+ (WBBoardData *)createBoardDataForEntity:(WBPeopleEntity *)entity
							  leaderBoard:(WBLeaderBoard *)leaderBoard
									value:(CGFloat)value
									 rank:(NSInteger)rank
									 year:(WBYear *)year;

- (NSString *)rankString;

+ (WBBoardData *)findWithBoardKey:(NSString *)key peopleEntity:(WBPeopleEntity *)entity;

@end
