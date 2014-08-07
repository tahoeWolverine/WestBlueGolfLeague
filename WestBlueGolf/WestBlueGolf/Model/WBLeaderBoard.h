#import "_WBLeaderBoard.h"

@class WBPeopleEntity;

@interface WBLeaderBoard : _WBLeaderBoard {}

+ (WBLeaderBoard *)createLeaderBoardWithName:(NSString *)name
                                     boardId:(NSInteger)boardId
										 key:(NSString *)key
							   tablePriority:(NSInteger)tablePriority
							   isPlayerBoard:(BOOL)isPlayerBoard
										 moc:(NSManagedObjectContext *)moc;

// Lazy accessor
+ (WBLeaderBoard *)leaderBoardWithName:(NSString *)name
                               boardId:(NSInteger)boardId
								   key:(NSString *)key
						 tablePriority:(NSInteger)tablePriority
						 isPlayerBoard:(BOOL)isPlayerBoard
								   moc:(NSManagedObjectContext *)moc;

- (NSArray *)winnerData;

+ (WBLeaderBoard *)findWithId:(NSInteger)boardId;
+ (WBLeaderBoard *)firstLeaderboard;

@end
