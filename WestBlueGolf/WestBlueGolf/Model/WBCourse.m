#import "WBCourse.h"

@interface WBCourse ()

@end

@implementation WBCourse

+ (WBCourse *)createCourseWithName:(NSString *)name
						  courseId:(NSInteger)courseId
							   par:(NSInteger)par
						 inContext:(NSManagedObjectContext *)moc {
	WBCourse *newCourse = [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:moc];
	newCourse.idValue = courseId;
	newCourse.name = name;
	newCourse.parValue = par;
	return newCourse;
}

+ (WBCourse *)courseWithName:(NSString *)name courseId:(NSInteger)courseId par:(NSInteger)par inContext:(NSManagedObjectContext *)moc {
	WBCourse *course = (WBCourse *)[WBCourse findFirstRecordWithFormat:@"name = %@", name];
	if (!course) {
		course = [WBCourse createCourseWithName:name courseId:courseId par:par inContext:moc];
	} else {
        course.name = name;
        course.parValue = par;
    }
	return course;
}

+ (WBCourse *)courseWithId:(NSInteger)courseId {
	return (WBCourse *)[WBCourse findFirstRecordWithFormat:@"id = %@", [NSNumber numberWithInteger:courseId]];
}

- (NSString *)shortName {
	NSString *firstName = [self.name componentsSeparatedByString:@" "][0];
	if ([firstName isEqualToString:self.name]) {
		return [firstName substringToIndex:5];
	}

	NSString *secondName = [self.name componentsSeparatedByString:@" "][1];
	
	NSString *shortFirstName = [NSString stringWithFormat:@"%@", [firstName substringToIndex:2]];
	NSString *shortSecondName = [NSString stringWithFormat:@"%@", [secondName substringToIndex:1]];
	return [NSString stringWithFormat:@"%@-%@", shortFirstName, shortSecondName];
}

@end
