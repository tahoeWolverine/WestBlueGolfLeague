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

+ (WBWeek *)weekWithId:(NSInteger)weekId {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"seasonIndex = %@", [NSNumber numberWithInteger:weekId]];
	NSArray *weeks = [[WBCoreDataManager class] findEntity:[[self class] entityName] withPredicate:predicate sorts:nil];
	return [weeks lastObject];
}

@end
