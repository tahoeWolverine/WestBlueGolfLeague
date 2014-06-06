// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBYear.h instead.

#import <CoreData/CoreData.h>
#import "WBManagedObject.h"

extern const struct WBYearAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *isComplete;
	__unsafe_unretained NSString *value;
} WBYearAttributes;

extern const struct WBYearRelationships {
	__unsafe_unretained NSString *boardData;
	__unsafe_unretained NSString *playerYearData;
	__unsafe_unretained NSString *weeks;
} WBYearRelationships;

extern const struct WBYearFetchedProperties {
} WBYearFetchedProperties;

@class WBBoardData;
@class WBPlayerYearData;
@class WBWeek;





@interface WBYearID : NSManagedObjectID {}
@end

@interface _WBYear : WBManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBYearID*)objectID;





@property (nonatomic, strong) NSNumber* id;



@property int16_t idValue;
- (int16_t)idValue;
- (void)setIdValue:(int16_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isComplete;



@property BOOL isCompleteValue;
- (BOOL)isCompleteValue;
- (void)setIsCompleteValue:(BOOL)value_;

//- (BOOL)validateIsComplete:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* value;



@property int16_t valueValue;
- (int16_t)valueValue;
- (void)setValueValue:(int16_t)value_;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *boardData;

- (NSMutableSet*)boardDataSet;




@property (nonatomic, strong) NSSet *playerYearData;

- (NSMutableSet*)playerYearDataSet;




@property (nonatomic, strong) NSSet *weeks;

- (NSMutableSet*)weeksSet;





@end

@interface _WBYear (CoreDataGeneratedAccessors)

- (void)addBoardData:(NSSet*)value_;
- (void)removeBoardData:(NSSet*)value_;
- (void)addBoardDataObject:(WBBoardData*)value_;
- (void)removeBoardDataObject:(WBBoardData*)value_;

- (void)addPlayerYearData:(NSSet*)value_;
- (void)removePlayerYearData:(NSSet*)value_;
- (void)addPlayerYearDataObject:(WBPlayerYearData*)value_;
- (void)removePlayerYearDataObject:(WBPlayerYearData*)value_;

- (void)addWeeks:(NSSet*)value_;
- (void)removeWeeks:(NSSet*)value_;
- (void)addWeeksObject:(WBWeek*)value_;
- (void)removeWeeksObject:(WBWeek*)value_;

@end

@interface _WBYear (CoreDataGeneratedPrimitiveAccessors)


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

- (int16_t)primitiveValueValue;
- (void)setPrimitiveValueValue:(int16_t)value_;





- (NSMutableSet*)primitiveBoardData;
- (void)setPrimitiveBoardData:(NSMutableSet*)value;



- (NSMutableSet*)primitivePlayerYearData;
- (void)setPrimitivePlayerYearData:(NSMutableSet*)value;



- (NSMutableSet*)primitiveWeeks;
- (void)setPrimitiveWeeks:(NSMutableSet*)value;


@end
