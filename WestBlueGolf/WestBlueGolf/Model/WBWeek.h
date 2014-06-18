#import "_WBWeek.h"

@interface WBWeek : _WBWeek {}

+ (WBWeek *)createWeekWithDate:(NSDate *)date
						inYear:(WBYear *)year
						weekId:(NSInteger)weekId
					 forCourse:(WBCourse *)course
				   seasonIndex:(NSInteger)seasonIndex
					   badData:(BOOL)badData
					 inContext:(NSManagedObjectContext *)moc;

+ (WBWeek *)findWeekWithId:(NSInteger)weekId inYear:(WBYear *)year;
+ (WBWeek *)findWeekWithSeasonIndex:(NSInteger)seasonIndex year:(WBYear *)year;

- (NSString *)pairingLabel;

+ (WBWeek *)finalPlayoffWeekInYear:(WBYear *)year;
+ (WBWeek *)firstPlayoffWeekInYear:(WBYear *)year;

@end
