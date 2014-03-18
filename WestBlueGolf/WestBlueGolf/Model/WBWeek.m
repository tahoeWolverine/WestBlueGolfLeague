#import "WBWeek.h"
#import "WBCoreDataManager.h"
#import "WBCourse.h"
#import "WBYear.h"

#define PAIRING_FIRST_MATCH		@"1-2, 3-4"
#define PAIRING_SECOND_MATCH	@"1-3, 2-4"
#define PAIRING_THIRD_MATCH		@"1-4, 2-3"

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

+ (WBWeek *)findWeekWithSeasonIndex:(NSInteger)seasonIndex year:(WBYear *)year {
	return (WBWeek *)[WBWeek findFirstRecordWithFormat:@"seasonIndex = %@ && year = %@", [NSNumber numberWithInteger:seasonIndex], [WBYear thisYear]];
}

- (NSString *)pairingLabel {
	NSInteger mod = self.seasonIndexValue % 3;
	switch (mod) {
		case 1:
			return PAIRING_FIRST_MATCH;
		case 2:
			return PAIRING_SECOND_MATCH;
		case 0:
			return PAIRING_THIRD_MATCH;
		default:
			break;
	}
	return @"";
}

@end
