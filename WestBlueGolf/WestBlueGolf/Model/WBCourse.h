#import "_WBCourse.h"

@interface WBCourse : _WBCourse {}

+ (WBCourse *)createCourseWithName:(NSString *)name
							   par:(NSInteger)par;

+ (WBCourse *)courseWithName:(NSString *)name par:(NSInteger)par;

@end
