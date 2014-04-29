#import "WBYear.h"
#import "WBAppDelegate.h"
#import "WBCoreDataManager.h"
#import "WBTeam.h"
#import "WBWeek.h"

@interface WBYear ()

@end

@implementation WBYear

+ (WBYear *)createYearWithValue:(NSInteger)year
					  inContext:(NSManagedObjectContext *)moc {
	WBYear *newYear = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
	newYear.valueValue = year;
	return newYear;
}

+ (WBYear *)yearWithValue:(NSInteger)year
				inContext:(NSManagedObjectContext *)moc {
	WBYear *aYear = [WBYear findYearWithValue:year inContext:moc];
	if (!aYear) {
		aYear = [WBYear createYearWithValue:year inContext:moc];
	}
	return aYear;
}

+ (WBYear *)thisYear {
	return [self thisYearInContext:[self context]];
}

+ (WBYear *)thisYearInContext:(NSManagedObjectContext *)moc {
	NSInteger selectedValue = [(WBAppDelegate *)[UIApplication sharedApplication].delegate thisYearValue];
	return [self findYearWithValue:selectedValue inContext:moc];
}

- (BOOL)isNewestYear {
	return self == [[self class] newestYearInContext:self.managedObjectContext];
}

+ (WBYear *)newestYearInContext:(NSManagedObjectContext *)moc {
	NSArray *sorts = @[[NSSortDescriptor sortDescriptorWithKey:@"value" ascending:NO]];
	return (WBYear *)[self findFirstRecordWithPredicate:nil sortedBy:sorts moc:moc];
}

+ (WBYear *)findYearWithValue:(NSInteger)value {
	return [self findYearWithValue:value inContext:[self context]];
}

+ (WBYear *)findYearWithValue:(NSInteger)value inContext:(NSManagedObjectContext *)moc {
	return (WBYear *)[self findFirstRecordWithPredicate:[NSPredicate predicateWithFormat:@"value = %@", [NSNumber numberWithInteger:value]]
											   sortedBy:@[[NSSortDescriptor sortDescriptorWithKey:@"value" ascending:NO]] moc:moc];
}

- (NSInteger)maxSeasonIndex {
	return [[self.weeks sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"seasonIndex" ascending:NO]]][0] seasonIndexValue];
}

- (BOOL)needsRefresh {
	return !self.weeks || self.weeks.count == 0;
}

@end
