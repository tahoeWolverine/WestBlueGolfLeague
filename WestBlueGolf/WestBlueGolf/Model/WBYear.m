#import "WBYear.h"
#import "WBAppDelegate.h"
#import "WBTeam.h"
#import "WBWeek.h"

@interface WBYear ()

@end

@implementation WBYear

+ (WBYear *)createYearWithYearId:(NSInteger)yearId
						   value:(NSInteger)year
					 isComplete:(BOOL)isComplete
					  inContext:(NSManagedObjectContext *)moc {
	WBYear *newYear = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
	if (year == 0) {
		NSLog(@"wat");
	}
	newYear.idValue = yearId;
	newYear.valueValue = year;
	newYear.isCompleteValue = isComplete;
	return newYear;
}

+ (WBYear *)yearWithYearId:(NSInteger)yearId
					 value:(NSInteger)year
			   isComplete:(BOOL)isComplete
				inContext:(NSManagedObjectContext *)moc {
	WBYear *aYear = [WBYear findYearWithValue:year inContext:moc];
	if (!aYear) {
		aYear = [WBYear createYearWithYearId:yearId value:year isComplete:isComplete inContext:moc];
	}
	return aYear;
}

+ (WBYear *)thisYear {
	return [self thisYearInContext:[self context]];
}

+ (WBYear *)thisYearInContext:(NSManagedObjectContext *)moc {
	NSInteger selectedValue = [[WBAppDelegate sharedDelegate] thisYearValue];
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
