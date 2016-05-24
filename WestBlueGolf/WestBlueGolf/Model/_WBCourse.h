// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBCourse.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "WBManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class WBWeek;

@interface WBCourseID : NSManagedObjectID {}
@end

@interface _WBCourse : WBManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WBCourseID *objectID;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int16_t idValue;
- (int16_t)idValue;
- (void)setIdValue:(int16_t)value_;

@property (nonatomic, strong) NSString* name;

@property (nonatomic, strong) NSNumber* par;

@property (atomic) uint16_t parValue;
- (uint16_t)parValue;
- (void)setParValue:(uint16_t)value_;

@property (nonatomic, strong) NSSet<WBWeek*> *weeks;
- (NSMutableSet<WBWeek*>*)weeksSet;

@end

@interface _WBCourse (WeeksCoreDataGeneratedAccessors)
- (void)addWeeks:(NSSet<WBWeek*>*)value_;
- (void)removeWeeks:(NSSet<WBWeek*>*)value_;
- (void)addWeeksObject:(WBWeek*)value_;
- (void)removeWeeksObject:(WBWeek*)value_;

@end

@interface _WBCourse (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int16_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int16_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitivePar;
- (void)setPrimitivePar:(NSNumber*)value;

- (uint16_t)primitiveParValue;
- (void)setPrimitiveParValue:(uint16_t)value_;

- (NSMutableSet<WBWeek*>*)primitiveWeeks;
- (void)setPrimitiveWeeks:(NSMutableSet<WBWeek*>*)value;

@end

@interface WBCourseAttributes: NSObject 
+ (NSString *)id;
+ (NSString *)name;
+ (NSString *)par;
@end

@interface WBCourseRelationships: NSObject
+ (NSString *)weeks;
@end

NS_ASSUME_NONNULL_END
