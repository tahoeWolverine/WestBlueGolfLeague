#import "WBPlayerYearData.h"
#import "WBCoreDataManager.h"
#import "WBPlayer.h"
#import "WBYear.h"

@interface WBPlayerYearData ()

@end


@implementation WBPlayerYearData

+ (WBPlayerYearData *)createPlayerYearDataForPlayer:(WBPlayer *)player
											   year:(WBYear *)year
							   withStartingHandicap:(NSInteger)startingHandicap
							  withFinishingHandicap:(NSInteger)finishingHandicap
										   isRookie:(BOOL)isRookie {
	WBPlayerYearData *newData = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] context]];
	newData.startingHandicapValue = startingHandicap;
	newData.finishingHandicapValue = finishingHandicap;
	newData.isRookieValue = isRookie;
	
	[player addYearDataObject:newData];
	[year addPlayerYearDataObject:newData];
	return newData;
}

@end
