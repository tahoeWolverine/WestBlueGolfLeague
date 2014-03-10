#import "_WBYear.h"

@interface WBYear : _WBYear {}

+ (WBYear *)createYearWithValue:(NSInteger)year
					   champion:(WBTeam *)champion;

+ (WBYear *)thisYear;

@end
