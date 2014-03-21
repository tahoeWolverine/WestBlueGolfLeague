#import "_WBCourse.h"

@interface WBCourse : _WBCourse {}

+ (WBCourse *)createCourseWithName:(NSString *)name
							   par:(NSInteger)par
						 inContext:(NSManagedObjectContext *)moc;

+ (WBCourse *)courseWithName:(NSString *)name par:(NSInteger)par inContext:(NSManagedObjectContext *)moc;

- (NSString *)shortName;

@end
