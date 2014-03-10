#import "WBBoardData.h"
#import "WBCoreDataManager.h"
#import "WBLeaderBoard.h"

@interface WBBoardData ()
@end

@implementation WBBoardData

+ (WBBoardData *)createBoardDataForEntity:(WBPeopleEntity *)entity
							  leaderBoard:(WBLeaderBoard *)leaderBoard
									value:(double)value
									 rank:(NSInteger)rank {
	if (!entity) {
		ALog(@"No people sent to boardData contstructor");
		return nil;
	}
	
	WBBoardData *data = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] context]];
	data.valueValue = value;
	data.rankValue = rank;
	
	[entity addBoardDataObject:data];
	[leaderBoard addBoardDataObject:data];
	return data;
}

- (NSString *)rankString {
	return [NSString stringWithFormat:@"#%@", self.rank];
}

@end
