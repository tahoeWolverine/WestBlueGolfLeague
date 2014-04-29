#import "_WBYear.h"

@interface WBYear : _WBYear {}

+ (WBYear *)createYearWithValue:(NSInteger)year
					  inContext:(NSManagedObjectContext *)moc;

+ (WBYear *)yearWithValue:(NSInteger)year
				inContext:(NSManagedObjectContext *)moc;

// Calls out to AppDelegate who owns the year selection
+ (WBYear *)thisYear;
+ (WBYear *)thisYearInContext:(NSManagedObjectContext *)moc;

- (BOOL)isNewestYear;
+ (WBYear *)newestYearInContext:(NSManagedObjectContext *)moc;
+ (WBYear *)findYearWithValue:(NSInteger)value;
+ (WBYear *)findYearWithValue:(NSInteger)value inContext:(NSManagedObjectContext *)moc;

- (BOOL)needsRefresh;

- (NSInteger)maxSeasonIndex;

@end
