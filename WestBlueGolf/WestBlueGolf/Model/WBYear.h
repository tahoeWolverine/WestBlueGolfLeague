#import "_WBYear.h"

@interface WBYear : _WBYear {}

+ (WBYear *)createYearWithYearId:(NSInteger)yearId
						   value:(NSInteger)year
					 isComplete:(BOOL)isComplete
					  inContext:(NSManagedObjectContext *)moc;

+ (WBYear *)yearWithYearId:(NSInteger)yearId
					 value:(NSInteger)year
			   isComplete:(BOOL)isComplete
				inContext:(NSManagedObjectContext *)moc;

+ (NSInteger)todayYear;
- (BOOL)isPast;

// Calls out to AppDelegate who owns the year selection
+ (WBYear *)thisYear;
+ (WBYear *)thisYearInContext:(NSManagedObjectContext *)moc;

- (BOOL)isNewestYear;
+ (WBYear *)newestYearInContext:(NSManagedObjectContext *)moc;
+ (WBYear *)findYearWithValue:(NSInteger)value;
+ (WBYear *)findYearWithValue:(NSInteger)value inContext:(NSManagedObjectContext *)moc;

- (BOOL)isIncomplete;
- (BOOL)needsRefresh;

- (NSInteger)maxSeasonIndex;

@end
