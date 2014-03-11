#import "WBLeaderBoard.h"
#import "WBCoreDataManager.h"
#import "WBBoardData.h"
#import "WBPeopleEntity.h"

@interface WBLeaderBoard ()

@end

@implementation WBLeaderBoard

+ (WBLeaderBoard *)createLeaderBoardWithName:(NSString *)name
										 key:(NSString *)key
							   tablePriority:(NSInteger)tablePriority
							   isPlayerBoard:(BOOL)isPlayerBoard {
	WBLeaderBoard *newBoard = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] context]];
	newBoard.name = name;
	newBoard.key = key;
	newBoard.tablePriorityValue = tablePriority;
	newBoard.isPlayerBoardValue = isPlayerBoard;
	return newBoard;
}

- (WBBoardData *)winnerData {
	NSPredicate *pred = [NSPredicate predicateWithFormat:@"leaderBoard = %@", self];
	NSArray *sorts = @[[NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES]];
	return (WBBoardData *)[WBBoardData findFirstRecordWithPredicate:pred sortedBy:sorts];
}

@end
