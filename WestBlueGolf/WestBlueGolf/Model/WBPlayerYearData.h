#import "_WBPlayerYearData.h"

@interface WBPlayerYearData : _WBPlayerYearData {}

+ (WBPlayerYearData *)createPlayerYearDataForPlayer:(WBPlayer *)player
											   year:(WBYear *)year
											 onTeam:(WBTeam *)team
							   withStartingHandicap:(NSInteger)startingHandicap
							  withFinishingHandicap:(NSInteger)finishingHandicap
										   isRookie:(BOOL)isRookie
												moc:(NSManagedObjectContext *)moc;

@end
