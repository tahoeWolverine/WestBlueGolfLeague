#import "WBWeek.h"
#import "WBCoreDataManager.h"
#import "WBCourse.h"
#import "WBYear.h"

@interface WBWeek ()

@end

@implementation WBWeek

+ (WBWeek *)createWeekWithDate:(NSDate *)date
						inYear:(WBYear *)year
					 forCourse:(WBCourse *)course {
	WBWeek *newWeek = [NSEntityDescription insertNewObjectForEntityForName:@"WBWeek" inManagedObjectContext:[[self class] managedObjectContext]];
	newWeek.date = date;
	newWeek.year = year;
	newWeek.seasonIndexValue = [year.weeks count] + 1;
	
	[course addWeeksObject:newWeek];
	
	[[WBCoreDataManager sharedManager] saveContext];
	return newWeek;
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

@end
