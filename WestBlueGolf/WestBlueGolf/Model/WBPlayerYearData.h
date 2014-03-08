#import "_WBPlayerYearData.h"

@interface WBPlayerYearData : _WBPlayerYearData {}

+ (WBPlayerYearData *)createPlayerYearDataForPlayer:(WBPlayer *)player
											   year:(WBYear *)year
							   withStartingHandicap:(NSInteger)startingHandicap
							  withFinishingHandicap:(NSInteger)finishingHandicap
										   isRookie:(BOOL)isRookie;

- (void)deleteYearData;

@end
