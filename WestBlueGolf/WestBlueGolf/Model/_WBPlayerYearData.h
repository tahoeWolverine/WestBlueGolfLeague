// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPlayerYearData.h instead.

#import <CoreData/CoreData.h>
#import "WBManagedObject.h"

extern const struct WBPlayerYearDataAttributes {
	__unsafe_unretained NSString *finishingHandicap;
	__unsafe_unretained NSString *isRookie;
	__unsafe_unretained NSString *startingHandicap;
} WBPlayerYearDataAttributes;

extern const struct WBPlayerYearDataRelationships {
	__unsafe_unretained NSString *player;
	__unsafe_unretained NSString *year;
} WBPlayerYearDataRelationships;

extern const struct WBPlayerYearDataFetchedProperties {
} WBPlayerYearDataFetchedProperties;

@class WBPlayer;
@class WBYear;





@interface WBPlayerYearDataID : NSManagedObjectID {}
@end

@interface _WBPlayerYearData : WBManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBPlayerYearDataID*)objectID;





@property (nonatomic, strong) NSNumber* finishingHandicap;



@property int16_t finishingHandicapValue;
- (int16_t)finishingHandicapValue;
- (void)setFinishingHandicapValue:(int16_t)value_;

//- (BOOL)validateFinishingHandicap:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isRookie;



@property BOOL isRookieValue;
- (BOOL)isRookieValue;
- (void)setIsRookieValue:(BOOL)value_;

//- (BOOL)validateIsRookie:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* startingHandicap;



@property int16_t startingHandicapValue;
- (int16_t)startingHandicapValue;
- (void)setStartingHandicapValue:(int16_t)value_;

//- (BOOL)validateStartingHandicap:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) WBPlayer *player;

//- (BOOL)validatePlayer:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) WBYear *year;

//- (BOOL)validateYear:(id*)value_ error:(NSError**)error_;





@end

@interface _WBPlayerYearData (CoreDataGeneratedAccessors)

@end

@interface _WBPlayerYearData (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveFinishingHandicap;
- (void)setPrimitiveFinishingHandicap:(NSNumber*)value;

- (int16_t)primitiveFinishingHandicapValue;
- (void)setPrimitiveFinishingHandicapValue:(int16_t)value_;




- (NSNumber*)primitiveIsRookie;
- (void)setPrimitiveIsRookie:(NSNumber*)value;

- (BOOL)primitiveIsRookieValue;
- (void)setPrimitiveIsRookieValue:(BOOL)value_;




- (NSNumber*)primitiveStartingHandicap;
- (void)setPrimitiveStartingHandicap:(NSNumber*)value;

- (int16_t)primitiveStartingHandicapValue;
- (void)setPrimitiveStartingHandicapValue:(int16_t)value_;





- (WBPlayer*)primitivePlayer;
- (void)setPrimitivePlayer:(WBPlayer*)value;



- (WBYear*)primitiveYear;
- (void)setPrimitiveYear:(WBYear*)value;


@end
