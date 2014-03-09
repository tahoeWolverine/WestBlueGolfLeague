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
	WBLeaderBoard *newBoard = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] managedObjectContext]];
	newBoard.name = name;
	newBoard.key = key;
	newBoard.tablePriorityValue = tablePriority;
	newBoard.isPlayerBoardValue = isPlayerBoard;
	[WBCoreDataManager saveContext];
	return newBoard;
}

- (void)deleteLeaderBoard {
	[[[self class] managedObjectContext] deleteObject:self];
}

+ (NSArray *)fetchAllLeaderBoards {
	NSFetchRequest *request = [WBCoreDataManager fetchAllRequestWithEntityName:[[self class] entityName]];
	NSError *error = nil;
	NSArray *results = [[[self class] managedObjectContext] executeFetchRequest:request error:&error];
	if (error) {
		[[WBCoreDataManager class] performSelector:@selector(logError:) withObject:error];
	}
	return results;
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

- (WBBoardData *)winnerData {
	NSFetchRequest *request = [WBCoreDataManager fetchAllRequestWithEntityName:[WBBoardData entityName]];
	[request setPredicate:[NSPredicate predicateWithFormat:@"leaderBoard = %@", self]];
	request.fetchLimit = 1;
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"rank" ascending:YES]];
	
	NSError *error = nil;
	NSArray *results = [[[self class] managedObjectContext] executeFetchRequest:request error:&error];
	if (error) {
		[[WBCoreDataManager class] performSelector:@selector(logError:) withObject:error];
	}
	
	
	return [results firstObject];
}

@end
