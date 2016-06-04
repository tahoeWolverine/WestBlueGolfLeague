// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBYear.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "WBManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class WBBoardData;
@class WBPlayerYearData;
@class WBWeek;

@interface WBYearID : NSManagedObjectID {}
@end

@interface _WBYear : WBManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WBYearID *objectID;

@property (nonatomic, strong) NSNumber* dataComplete;

@property (atomic) BOOL dataCompleteValue;
- (BOOL)dataCompleteValue;
- (void)setDataCompleteValue:(BOOL)value_;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int16_t idValue;
- (int16_t)idValue;
- (void)setIdValue:(int16_t)value_;

@property (nonatomic, strong) NSNumber* isComplete;

@property (atomic) BOOL isCompleteValue;
- (BOOL)isCompleteValue;
- (void)setIsCompleteValue:(BOOL)value_;

@property (nonatomic, strong) NSNumber* value;

@property (atomic) uint16_t valueValue;
- (uint16_t)valueValue;
- (void)setValueValue:(uint16_t)value_;

@property (nonatomic, strong, nullable) NSSet<WBBoardData*> *boardData;
- (nullable NSMutableSet<WBBoardData*>*)boardDataSet;

@property (nonatomic, strong, nullable) NSSet<WBPlayerYearData*> *playerYearData;
- (nullable NSMutableSet<WBPlayerYearData*>*)playerYearDataSet;

@property (nonatomic, strong, nullable) NSSet<WBWeek*> *weeks;
- (nullable NSMutableSet<WBWeek*>*)weeksSet;

@end

@interface _WBYear (BoardDataCoreDataGeneratedAccessors)
- (void)addBoardData:(NSSet<WBBoardData*>*)value_;
- (void)removeBoardData:(NSSet<WBBoardData*>*)value_;
- (void)addBoardDataObject:(WBBoardData*)value_;
- (void)removeBoardDataObject:(WBBoardData*)value_;

@end

@interface _WBYear (PlayerYearDataCoreDataGeneratedAccessors)
- (void)addPlayerYearData:(NSSet<WBPlayerYearData*>*)value_;
- (void)removePlayerYearData:(NSSet<WBPlayerYearData*>*)value_;
- (void)addPlayerYearDataObject:(WBPlayerYearData*)value_;
- (void)removePlayerYearDataObject:(WBPlayerYearData*)value_;

@end

@interface _WBYear (WeeksCoreDataGeneratedAccessors)
- (void)addWeeks:(NSSet<WBWeek*>*)value_;
- (void)removeWeeks:(NSSet<WBWeek*>*)value_;
- (void)addWeeksObject:(WBWeek*)value_;
- (void)removeWeeksObject:(WBWeek*)value_;

@end

@interface _WBYear (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveDataComplete;
- (void)setPrimitiveDataComplete:(NSNumber*)value;

- (BOOL)primitiveDataCompleteValue;
- (void)setPrimitiveDataCompleteValue:(BOOL)value_;

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int16_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int16_t)value_;

- (NSNumber*)primitiveIsComplete;
- (void)setPrimitiveIsComplete:(NSNumber*)value;

- (BOOL)primitiveIsCompleteValue;
- (void)setPrimitiveIsCompleteValue:(BOOL)value_;

- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (uint16_t)primitiveValueValue;
- (void)setPrimitiveValueValue:(uint16_t)value_;

- (NSMutableSet<WBBoardData*>*)primitiveBoardData;
- (void)setPrimitiveBoardData:(NSMutableSet<WBBoardData*>*)value;

- (NSMutableSet<WBPlayerYearData*>*)primitivePlayerYearData;
- (void)setPrimitivePlayerYearData:(NSMutableSet<WBPlayerYearData*>*)value;

- (NSMutableSet<WBWeek*>*)primitiveWeeks;
- (void)setPrimitiveWeeks:(NSMutableSet<WBWeek*>*)value;

@end

@interface WBYearAttributes: NSObject 
+ (NSString *)dataComplete;
+ (NSString *)id;
+ (NSString *)isComplete;
+ (NSString *)value;
@end

@interface WBYearRelationships: NSObject
+ (NSString *)boardData;
+ (NSString *)playerYearData;
+ (NSString *)weeks;
@end

NS_ASSUME_NONNULL_END
