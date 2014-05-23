#import "WBLeaderBoard.h"
#import "WBBoardData.h"
#import "WBPeopleEntity.h"
#import "WBYear.h"

@interface WBLeaderBoard ()

@end

@implementation WBLeaderBoard

+ (WBLeaderBoard *)createLeaderBoardWithName:(NSString *)name
										 key:(NSString *)key
							   tablePriority:(NSInteger)tablePriority
							   isPlayerBoard:(BOOL)isPlayerBoard
										 moc:(NSManagedObjectContext *)moc {
	WBLeaderBoard *newBoard = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
	newBoard.name = name;
	newBoard.key = key;
	newBoard.tablePriorityValue = tablePriority;
	newBoard.isPlayerBoardValue = isPlayerBoard;
	return newBoard;
}

+ (WBLeaderBoard *)leaderBoardWithName:(NSString *)name
								   key:(NSString *)key
						 tablePriority:(NSInteger)tablePriority
						 isPlayerBoard:(BOOL)isPlayerBoard
								   moc:(NSManagedObjectContext *)moc {
	WBLeaderBoard *board = (WBLeaderBoard *)[WBLeaderBoard findFirstRecordWithFormat:@"key = %@ && isPlayerBoard = %@", key, [NSNumber numberWithBool:isPlayerBoard]];
	if (!board) {
		board = [WBLeaderBoard createLeaderBoardWithName:name key:key tablePriority:tablePriority isPlayerBoard:isPlayerBoard moc:moc];
	}
	return board;
}

- (NSArray *)winnerData {
	return [WBBoardData findWithFormat:@"leaderBoard = %@ && rank = 1 && year = %@", self, [WBYear thisYear]];
}

@end
