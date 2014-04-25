#import "_WBWeek.h"

@interface WBWeek : _WBWeek {}

+ (WBWeek *)createWeekWithDate:(NSDate *)date
						inYear:(WBYear *)year
					 forCourse:(WBCourse *)course
				   seasonIndex:(NSInteger)seasonIndex
					 inContext:(NSManagedObjectContext *)moc;

+ (WBWeek *)findWeekWithId:(NSInteger)weekId inYear:(WBYear *)year inContext:(NSManagedObjectContext *)moc;

+ (WBWeek *)findWeekWithSeasonIndex:(NSInteger)seasonIndex year:(WBYear *)year;

- (NSString *)pairingLabel;

+ (WBWeek *)finalPlayoffWeekInYear:(WBYear *)year;
+ (WBWeek *)firstPlayoffWeekInYear:(WBYear *)year;

@end
