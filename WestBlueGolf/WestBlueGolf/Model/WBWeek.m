#import "WBWeek.h"
#import "WBCoreDataManager.h"
#import "WBCourse.h"
#import "WBYear.h"

@interface WBWeek ()

@end

@implementation WBWeek

+ (WBWeek *)createWeekWithDate:(NSDate *)date
						inYear:(WBYear *)year
					 forCourse:(WBCourse *)course
				   seasonIndex:(NSInteger)seasonIndex {
	WBWeek *newWeek = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] context]];
	newWeek.date = date;
	newWeek.year = year;
	newWeek.seasonIndexValue = seasonIndex;
	
	[course addWeeksObject:newWeek];
	return newWeek;
}

+ (WBWeek *)weekWithId:(NSInteger)weekId inYear:(WBYear *)year {
	return (WBWeek *)[WBWeek findFirstRecordWithFormat:@"seasonIndex = %@ && year = %@", [NSNumber numberWithInteger:weekId], year];
}

@end
