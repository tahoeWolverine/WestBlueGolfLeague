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
	WBWeek *newWeek = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] managedObjectContext]];
	newWeek.date = date;
	newWeek.year = year;
	newWeek.seasonIndexValue = seasonIndex;
	
	[course addWeeksObject:newWeek];
	
	//[WBCoreDataManager saveContext];
	return newWeek;
}

- (void)deleteWeek {
	[[[self class] managedObjectContext] deleteObject:self];
}

+ (WBWeek *)weekWithId:(NSInteger)weekId {
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"seasonIndex = %@", [NSNumber numberWithInteger:weekId]];
	NSArray *weeks = [[WBCoreDataManager class] findWithPredicate:predicate forEntity:[[self class] entityName]];
	return [weeks lastObject];
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

@end
