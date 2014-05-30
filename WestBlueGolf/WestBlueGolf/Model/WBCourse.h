#import "_WBCourse.h"

@interface WBCourse : _WBCourse {}

+ (WBCourse *)createCourseWithName:(NSString *)name
						  courseId:(NSInteger)courseId
							   par:(NSInteger)par
						 inContext:(NSManagedObjectContext *)moc;

+ (WBCourse *)courseWithName:(NSString *)name courseId:(NSInteger)courseId par:(NSInteger)par inContext:(NSManagedObjectContext *)moc;

+ (WBCourse *)courseWithId:(NSInteger)courseId;

- (NSString *)shortName;

@end
