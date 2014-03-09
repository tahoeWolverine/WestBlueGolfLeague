#import "WBCourse.h"
#import "WBCoreDataManager.h"

@interface WBCourse ()

@end

@implementation WBCourse

+ (WBCourse *)createCourseWithName:(NSString *)name
							   par:(NSInteger)par {
	WBCourse *newCourse = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] managedObjectContext]];
	newCourse.name = name;
	newCourse.parValue = par;
	
	//[WBCoreDataManager saveContext];
	return newCourse;
}

- (void)deleteCourse {
	[[[self class] managedObjectContext] deleteObject:self];
}

+ (WBCourse *)courseWithName:(NSString *)courseName {
	if (!courseName) {
		return nil;
	}
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", courseName];
	NSArray *courses = [[WBCoreDataManager class] findWithPredicate:predicate forEntity:[[self class] entityName]];
	return [courses lastObject];
}

+ (NSManagedObjectContext *)managedObjectContext {
	return [[WBCoreDataManager sharedManager] managedObjectContext];
}

@end
