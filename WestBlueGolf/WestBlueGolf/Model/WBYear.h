#import "_WBYear.h"

@interface WBYear : _WBYear {}

+ (WBYear *)createYearWithValue:(NSInteger)year
					   champion:(WBTeam *)champion;

// Calls out to AppDelegate who owns the year selection
+ (WBYear *)thisYear;

+ (WBYear *)newestYear;
+ (WBYear *)yearWithValue:(NSInteger)value;

@end
