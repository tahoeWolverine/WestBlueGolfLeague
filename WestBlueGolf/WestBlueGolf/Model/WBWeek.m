#import "WBWeek.h"
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
						weekId:(NSInteger)weekId
					 forCourse:(WBCourse *)course
				   seasonIndex:(NSInteger)seasonIndex
					   badData:(BOOL)badData
					 inContext:(NSManagedObjectContext *)moc {
	WBWeek *newWeek = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
	newWeek.date = date;
	newWeek.year = year;
	newWeek.idValue = weekId;
	newWeek.seasonIndexValue = seasonIndex;
	newWeek.isBadDataValue = badData;
	
	[course addWeeksObject:newWeek];
	return newWeek;
}

+ (WBWeek *)findWeekWithId:(NSInteger)weekId inYear:(WBYear *)year {
	return (WBWeek *)[WBWeek findFirstRecordWithFormat:@"id = %@ && year = %@", [NSNumber numberWithInteger:weekId], year];
}

+ (WBWeek *)findWeekWithSeasonIndex:(NSInteger)seasonIndex year:(WBYear *)year {
	return (WBWeek *)[WBWeek findFirstRecordWithFormat:@"seasonIndex = %@ && year = %@", [NSNumber numberWithInteger:seasonIndex], year];
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

+ (WBWeek *)finalPlayoffWeekInYear:(WBYear *)year {
    //NSString *format = @"year = %@ && ANY teamMatchups.matchId > 0";
    NSString *format = @"year = %@";
	NSArray *weeks = [WBWeek findWithPredicate:[NSPredicate predicateWithFormat:format, year] sortedBy:@[[NSSortDescriptor sortDescriptorWithKey:@"seasonIndex" ascending:NO]] fetchLimit:1 moc:year.managedObjectContext];
	return weeks && weeks.count > 0 ? weeks[0] : nil;
}

+ (WBWeek *)firstPlayoffWeekInYear:(WBYear *)year {
    //NSString *format = @"year = %@ && ANY teamMatchups.matchId > 0";
    NSString *format = @"year = %@";
	NSArray *weeks = [WBWeek findWithPredicate:[NSPredicate predicateWithFormat:format, year] sortedBy:@[[NSSortDescriptor sortDescriptorWithKey:@"seasonIndex" ascending:NO]] fetchLimit:2 moc:year.managedObjectContext];
	return weeks && weeks.count > 1 ? weeks[1] : nil;
}

- (BOOL)alreadyTookPlace {
    return [self.date timeIntervalSinceNow] < 0;
}

@end
