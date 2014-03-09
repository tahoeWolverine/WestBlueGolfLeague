#import "WBYear.h"
#import "WBCoreDataManager.h"
#import "WBTeam.h"

@interface WBYear ()

@end

@implementation WBYear

+ (WBYear *)createYearWithValue:(NSInteger)year
					   champion:(WBTeam *)champion {
	WBYear *newYear = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] managedObjectContext]];
	newYear.valueValue = year;
	newYear.champion = champion;
	//[WBCoreDataManager saveContext];
	return newYear;
}

- (void)deleteYear {
	[[[self class] managedObjectContext] deleteObject:self];
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

+ (WBYear *)thisYear {
	NSFetchRequest *request = [WBCoreDataManager fetchAllRequestWithEntityName:[[self class] entityName]];
	request.fetchLimit = 1;
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"value" ascending:NO]];

	NSError *error = nil;
	NSArray *results = [[[self class] managedObjectContext] executeFetchRequest:request error:&error];
	if (error) {
		[[WBCoreDataManager class] performSelector:@selector(logError:) withObject:error];
	}
	return [results lastObject];
}

@end
