#import "_WBLeaderBoard.h"

@class WBPeopleEntity;

@interface WBLeaderBoard : _WBLeaderBoard {}

+ (WBLeaderBoard *)createLeaderBoardWithName:(NSString *)name
										 key:(NSString *)key
							   tablePriority:(NSInteger)tablePriority
							   isPlayerBoard:(BOOL)isPlayerBoard
										 moc:(NSManagedObjectContext *)moc;

// Lazy accessor
+ (WBLeaderBoard *)leaderBoardWithName:(NSString *)name
								   key:(NSString *)key
						 tablePriority:(NSInteger)tablePriority
						 isPlayerBoard:(BOOL)isPlayerBoard
								   moc:(NSManagedObjectContext *)moc;

- (NSArray *)winnerData;

@end
