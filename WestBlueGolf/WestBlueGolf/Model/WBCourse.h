#import "_WBCourse.h"

@interface WBCourse : _WBCourse {}

+ (WBCourse *)createCourseWithName:(NSString *)name
							   par:(NSInteger)par;

- (void)deleteCourse;

+ (WBCourse *)courseWithName:(NSString *)courseName;

@end
