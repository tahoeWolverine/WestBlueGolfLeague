// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBCourse.h instead.

#import <CoreData/CoreData.h>
#import "WBManagedObject.h"

extern const struct WBCourseAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *par;
} WBCourseAttributes;

extern const struct WBCourseRelationships {
	__unsafe_unretained NSString *weeks;
} WBCourseRelationships;

extern const struct WBCourseFetchedProperties {
} WBCourseFetchedProperties;

@class WBWeek;




@interface WBCourseID : NSManagedObjectID {}
@end

@interface _WBCourse : WBManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBCourseID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* par;



@property int16_t parValue;
- (int16_t)parValue;
- (void)setParValue:(int16_t)value_;

//- (BOOL)validatePar:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *weeks;

- (NSMutableSet*)weeksSet;





@end

@interface _WBCourse (CoreDataGeneratedAccessors)

- (void)addWeeks:(NSSet*)value_;
- (void)removeWeeks:(NSSet*)value_;
- (void)addWeeksObject:(WBWeek*)value_;
- (void)removeWeeksObject:(WBWeek*)value_;

@end

@interface _WBCourse (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitivePar;
- (void)setPrimitivePar:(NSNumber*)value;

- (int16_t)primitiveParValue;
- (void)setPrimitiveParValue:(int16_t)value_;





- (NSMutableSet*)primitiveWeeks;
- (void)setPrimitiveWeeks:(NSMutableSet*)value;


@end
