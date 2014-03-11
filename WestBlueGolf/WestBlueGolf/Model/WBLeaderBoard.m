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
	//TODO: Optimize for single result
	//request.fetchLimit = 1;
	NSArray *sorts = @[[NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES]];
	NSArray *results = [WBBoardData findWithPredicate:pred sortedBy:sorts];
	return [results firstObject];
}

@end
