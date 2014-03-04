#import "_WBWeek.h"

@interface WBWeek : _WBWeek {}

+ (WBWeek *)createWeekWithDate:(NSDate *)date
						inYear:(WBYear *)year
					 forCourse:(WBCourse *)course;

- (void)deleteWeek;

@end
