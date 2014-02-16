#import "WBPlayerYearData.h"
#import "WBCoreDataManager.h"
#import "WBPlayer.h"

@interface WBPlayerYearData ()

@end


@implementation WBPlayerYearData

+ (WBPlayerYearData *)createPlayerYearDataForPlayer:(WBPlayer *)player
							   withStartingHandicap:(NSInteger)startingHandicap
										   isRookie:(BOOL)isRookie {
	WBPlayerYearData *newData = [NSEntityDescription insertNewObjectForEntityForName:@"WBPlayerYearData" inManagedObjectContext:[[self class] managedObjectContext]];
	newData.startingHandicapValue = startingHandicap;
	newData.isRookieValue = isRookie;
	
	[player addYearDataObject:newData];
	
	[[WBCoreDataManager sharedManager] saveContext];
	return newData;
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

@end
