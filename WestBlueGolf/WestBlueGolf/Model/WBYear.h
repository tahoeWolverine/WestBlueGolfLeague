#import "_WBYear.h"

@interface WBYear : _WBYear {}

+ (WBYear *)createYearWithValue:(NSInteger)year
					   champion:(WBTeam *)champion
					  inContext:(NSManagedObjectContext *)moc;

+ (WBYear *)yearWithValue:(NSInteger)year
				 champion:(WBTeam *)champion
				inContext:(NSManagedObjectContext *)moc;

// Calls out to AppDelegate who owns the year selection
+ (WBYear *)thisYear;
+ (WBYear *)thisYearInContext:(NSManagedObjectContext *)moc;

- (BOOL)isNewestYear;
+ (WBYear *)newestYearInContext:(NSManagedObjectContext *)moc;
+ (WBYear *)yearWithValue:(NSInteger)value;
+ (WBYear *)yearWithValue:(NSInteger)value inContext:(NSManagedObjectContext *)moc;

- (BOOL)needsRefresh;

- (NSInteger)maxSeasonIndex;

@end
