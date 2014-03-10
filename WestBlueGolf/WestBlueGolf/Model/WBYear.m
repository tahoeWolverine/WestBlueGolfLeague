#import "WBYear.h"
#import "WBCoreDataManager.h"
#import "WBTeam.h"

@interface WBYear ()

@end

@implementation WBYear

+ (WBYear *)createYearWithValue:(NSInteger)year
					   champion:(WBTeam *)champion {
	WBYear *newYear = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] context]];
	newYear.valueValue = year;
	newYear.champion = champion;
	return newYear;
}

+ (WBYear *)thisYear {
	//TODO: request.fetchLimit = 1;
	NSArray *results = [WBYear findAllSortedBy:@"value" ascending:NO];
	return [results firstObject];
}

@end
