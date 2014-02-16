#import "WBYear.h"
#import "WBCoreDataManager.h"

@interface WBYear ()

@end

@implementation WBYear

+ (WBYear *)createYearWithValue:(NSInteger)year {
	WBYear *newYear = [NSEntityDescription insertNewObjectForEntityForName:@"WBYear" inManagedObjectContext:[[self class] managedObjectContext]];
	newYear.valueValue = year;
	[[WBCoreDataManager sharedManager] saveContext];
	return newYear;
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

@end
