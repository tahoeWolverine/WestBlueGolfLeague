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
	
	return (WBCourse *)[WBCourse findFirstRecordWithPredicate:[NSPredicate predicateWithFormat:@"name = %@", courseName] sortedBy:nil];
}

@end
