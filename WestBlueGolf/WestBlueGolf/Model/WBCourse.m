#import "WBCourse.h"
#import "WBCoreDataManager.h"

@interface WBCourse ()

@end

@implementation WBCourse

+ (WBCourse *)createCourseWithName:(NSString *)name
							   par:(NSInteger)par {
	WBCourse *newCourse = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:[[self class] context]];
	newCourse.name = name;
	newCourse.parValue = par;
	return newCourse;
}

+ (WBCourse *)courseWithName:(NSString *)courseName {
	if (!courseName) {
		return nil;
	}
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", courseName];
	NSArray *courses = [WBCourse findWithPredicate:predicate];
	return [courses firstObject];
}

@end
