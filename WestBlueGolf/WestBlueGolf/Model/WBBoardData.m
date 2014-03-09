#import "WBBoardData.h"
#import "WBCoreDataManager.h"
#import "WBLeaderBoard.h"

@interface WBBoardData ()
@end

@implementation WBBoardData

+ (WBBoardData *)createBoardDataForEntity:(WBPeopleEntity *)entity
							  leaderBoard:(WBLeaderBoard *)leaderBoard
									value:(NSInteger)value
									 rank:(NSInteger)rank {
	if (!entity) {
		ALog(@"No people sent to boardData contstructor");
		return nil;
	}
	
	WBBoardData *data = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] managedObjectContext]];
	data.valueValue = value;
	data.rankValue = rank;
	
	[entity addBoardDataObject:data];
	[leaderBoard addBoardDataObject:data];
	
	//[WBCoreDataManager saveContext];
	return data;
}

- (void)deleteBoardData {
	[[[self class] managedObjectContext] deleteObject:self];
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

- (NSString *)rankString {
	return [NSString stringWithFormat:@"#%@", self.rank];
}

@end
