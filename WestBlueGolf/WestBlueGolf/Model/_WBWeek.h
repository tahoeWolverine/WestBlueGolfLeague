// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBWeek.h instead.

#import <CoreData/CoreData.h>
#import "WBManagedObject.h"

extern const struct WBWeekAttributes {
	__unsafe_unretained NSString *date;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *isBadData;
	__unsafe_unretained NSString *isPlayoff;
	__unsafe_unretained NSString *pairing;
	__unsafe_unretained NSString *seasonIndex;
} WBWeekAttributes;

extern const struct WBWeekRelationships {
	__unsafe_unretained NSString *course;
	__unsafe_unretained NSString *teamMatchups;
	__unsafe_unretained NSString *year;
} WBWeekRelationships;

extern const struct WBWeekFetchedProperties {
} WBWeekFetchedProperties;

@class WBCourse;
@class WBTeamMatchup;
@class WBYear;








@interface WBWeekID : NSManagedObjectID {}
@end

@interface _WBWeek : WBManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBWeekID*)objectID;





@property (nonatomic, strong) NSDate* date;



//- (BOOL)validateDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* id;



@property int16_t idValue;
- (int16_t)idValue;
- (void)setIdValue:(int16_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isBadData;



@property BOOL isBadDataValue;
- (BOOL)isBadDataValue;
- (void)setIsBadDataValue:(BOOL)value_;

//- (BOOL)validateIsBadData:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isPlayoff;



@property BOOL isPlayoffValue;
- (BOOL)isPlayoffValue;
- (void)setIsPlayoffValue:(BOOL)value_;

//- (BOOL)validateIsPlayoff:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* pairing;



@property int16_t pairingValue;
- (int16_t)pairingValue;
- (void)setPairingValue:(int16_t)value_;

//- (BOOL)validatePairing:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* seasonIndex;



@property int16_t seasonIndexValue;
- (int16_t)seasonIndexValue;
- (void)setSeasonIndexValue:(int16_t)value_;

//- (BOOL)validateSeasonIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) WBCourse *course;

//- (BOOL)validateCourse:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *teamMatchups;

- (NSMutableSet*)teamMatchupsSet;




@property (nonatomic, strong) WBYear *year;

//- (BOOL)validateYear:(id*)value_ error:(NSError**)error_;





@end

@interface _WBWeek (CoreDataGeneratedAccessors)

- (void)addTeamMatchups:(NSSet*)value_;
- (void)removeTeamMatchups:(NSSet*)value_;
- (void)addTeamMatchupsObject:(WBTeamMatchup*)value_;
- (void)removeTeamMatchupsObject:(WBTeamMatchup*)value_;

@end

@interface _WBWeek (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;




- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int16_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int16_t)value_;




- (NSNumber*)primitiveIsBadData;
- (void)setPrimitiveIsBadData:(NSNumber*)value;

- (BOOL)primitiveIsBadDataValue;
- (void)setPrimitiveIsBadDataValue:(BOOL)value_;




- (NSNumber*)primitiveIsPlayoff;
- (void)setPrimitiveIsPlayoff:(NSNumber*)value;

- (BOOL)primitiveIsPlayoffValue;
- (void)setPrimitiveIsPlayoffValue:(BOOL)value_;




- (NSNumber*)primitivePairing;
- (void)setPrimitivePairing:(NSNumber*)value;

- (int16_t)primitivePairingValue;
- (void)setPrimitivePairingValue:(int16_t)value_;




- (NSNumber*)primitiveSeasonIndex;
- (void)setPrimitiveSeasonIndex:(NSNumber*)value;

- (int16_t)primitiveSeasonIndexValue;
- (void)setPrimitiveSeasonIndexValue:(int16_t)value_;





- (WBCourse*)primitiveCourse;
- (void)setPrimitiveCourse:(WBCourse*)value;



- (NSMutableSet*)primitiveTeamMatchups;
- (void)setPrimitiveTeamMatchups:(NSMutableSet*)value;



- (WBYear*)primitiveYear;
- (void)setPrimitiveYear:(WBYear*)value;


@end
