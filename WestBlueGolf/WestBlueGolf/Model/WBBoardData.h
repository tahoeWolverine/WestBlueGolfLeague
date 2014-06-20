#import "_WBBoardData.h"
#import "WBPeopleEntity.h"

@interface WBBoardData : _WBBoardData {}

+ (WBBoardData *)createBoardDataForEntity:(WBPeopleEntity *)entity
							  leaderBoard:(WBLeaderBoard *)leaderBoard
                                   dataId:(NSInteger)dataId
									value:(CGFloat)value
							  detailValue:(NSString *)detailValue
									 rank:(NSInteger)rank
									 year:(WBYear *)year
									  moc:(NSManagedObjectContext *)moc;

- (NSString *)rankString;

+ (WBBoardData *)findWithBoardKey:(NSString *)key peopleEntity:(WBPeopleEntity *)entity;

@end
