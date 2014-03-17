#import "WBYear.h"
#import "WBAppDelegate.h"
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

+ (WBYear *)yearWithValue:(NSInteger)year champion:(WBTeam *)champion {
	WBYear *aYear = [WBYear yearWithValue:year];
	if (!aYear) {
		aYear = [WBYear createYearWithValue:year champion:champion];
	}
	return aYear;
}

+ (WBYear *)thisYear {
	NSInteger selectedValue = [(WBAppDelegate *)[UIApplication sharedApplication].delegate thisYearValue];
	return [self yearWithValue:selectedValue];
}

+ (WBYear *)newestYear {
	NSArray *sorts = @[[NSSortDescriptor sortDescriptorWithKey:@"value" ascending:NO]];
	return (WBYear *)[self findFirstRecordWithPredicate:nil sortedBy:sorts];
}

+ (WBYear *)yearWithValue:(NSInteger)value {
	return (WBYear *)[self findFirstRecordWithPredicate:[NSPredicate predicateWithFormat:@"value = %@", [NSNumber numberWithInteger:value]]
											   sortedBy:@[[NSSortDescriptor sortDescriptorWithKey:@"value" ascending:NO]]];
}

@end
