#import "WBYear.h"
#import "WBAppDelegate.h"
#import "WBCoreDataManager.h"
#import "WBTeam.h"
#import "WBWeek.h"

@interface WBYear ()

@end

@implementation WBYear

+ (WBYear *)createYearWithValue:(NSInteger)year
					   champion:(WBTeam *)champion
					  inContext:(NSManagedObjectContext *)moc {
	WBYear *newYear = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
	newYear.valueValue = year;
	newYear.champion = champion;
	return newYear;
}

+ (WBYear *)yearWithValue:(NSInteger)year
				 champion:(WBTeam *)champion
				inContext:(NSManagedObjectContext *)moc {
	WBYear *aYear = [WBYear yearWithValue:year inContext:moc];
	if (!aYear) {
		aYear = [WBYear createYearWithValue:year champion:champion inContext:moc];
	}
	return aYear;
}

+ (WBYear *)thisYear {
	return [self thisYearInContext:[self context]];
}

+ (WBYear *)thisYearInContext:(NSManagedObjectContext *)moc {
	NSInteger selectedValue = [(WBAppDelegate *)[UIApplication sharedApplication].delegate thisYearValue];
	return [self yearWithValue:selectedValue inContext:moc];
}

- (BOOL)isNewestYear {
	return self == [[self class] newestYearInContext:self.managedObjectContext];
}

+ (WBYear *)newestYearInContext:(NSManagedObjectContext *)moc {
	NSArray *sorts = @[[NSSortDescriptor sortDescriptorWithKey:@"value" ascending:NO]];
	return (WBYear *)[self findFirstRecordWithPredicate:nil sortedBy:sorts moc:moc];
}

+ (WBYear *)yearWithValue:(NSInteger)value {
	return [self yearWithValue:value inContext:[self context]];
}

+ (WBYear *)yearWithValue:(NSInteger)value inContext:(NSManagedObjectContext *)moc {
	return (WBYear *)[self findFirstRecordWithPredicate:[NSPredicate predicateWithFormat:@"value = %@", [NSNumber numberWithInteger:value]]
											   sortedBy:@[[NSSortDescriptor sortDescriptorWithKey:@"value" ascending:NO]] moc:moc];
}

- (NSInteger)maxSeasonIndex {
	return [(WBWeek *)[WBWeek findFirstRecordWithPredicate:[NSPredicate predicateWithFormat:@"year = %@", self] sortedBy:@[[NSSortDescriptor sortDescriptorWithKey:@"seasonIndex" ascending:NO]]] seasonIndexValue];
}

@end
