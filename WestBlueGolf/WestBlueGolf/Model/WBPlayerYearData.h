#import "_WBPlayerYearData.h"

@interface WBPlayerYearData : _WBPlayerYearData {}

+ (WBPlayerYearData *)createPlayerYearDataForPlayer:(WBPlayer *)player
							   withStartingHandicap:(NSInteger)startingHandicap
										   isRookie:(BOOL)isRookie;

@end
