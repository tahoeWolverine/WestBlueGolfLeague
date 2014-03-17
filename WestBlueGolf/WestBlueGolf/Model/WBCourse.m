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

+ (WBCourse *)courseWithName:(NSString *)name par:(NSInteger)par {
	WBCourse *course = (WBCourse *)[WBCourse findFirstRecordWithFormat:@"name = %@", name];
	if (!course) {
		course = [WBCourse createCourseWithName:name par:par];
	}
	return course;
}

@end
