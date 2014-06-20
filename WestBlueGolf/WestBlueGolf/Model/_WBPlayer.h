// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPlayer.h instead.

#import <CoreData/CoreData.h>
#import "WBPeopleEntity.h"

extern const struct WBPlayerAttributes {
	__unsafe_unretained NSString *currentHandicap;
	__unsafe_unretained NSString *id;
} WBPlayerAttributes;

extern const struct WBPlayerRelationships {
	__unsafe_unretained NSString *matches;
	__unsafe_unretained NSString *results;
	__unsafe_unretained NSString *yearData;
} WBPlayerRelationships;

extern const struct WBPlayerFetchedProperties {
} WBPlayerFetchedProperties;

@class WBMatch;
@class WBResult;
@class WBPlayerYearData;




@interface WBPlayerID : NSManagedObjectID {}
@end

@interface _WBPlayer : WBPeopleEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBPlayerID*)objectID;





@property (nonatomic, strong) NSNumber* currentHandicap;



@property int16_t currentHandicapValue;
- (int16_t)currentHandicapValue;
- (void)setCurrentHandicapValue:(int16_t)value_;

//- (BOOL)validateCurrentHandicap:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* id;



@property int16_t idValue;
- (int16_t)idValue;
- (void)setIdValue:(int16_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *matches;

- (NSMutableSet*)matchesSet;




@property (nonatomic, strong) NSSet *results;

- (NSMutableSet*)resultsSet;




@property (nonatomic, strong) NSSet *yearData;

- (NSMutableSet*)yearDataSet;





@end

@interface _WBPlayer (CoreDataGeneratedAccessors)

- (void)addMatches:(NSSet*)value_;
- (void)removeMatches:(NSSet*)value_;
- (void)addMatchesObject:(WBMatch*)value_;
- (void)removeMatchesObject:(WBMatch*)value_;

- (void)addResults:(NSSet*)value_;
- (void)removeResults:(NSSet*)value_;
- (void)addResultsObject:(WBResult*)value_;
- (void)removeResultsObject:(WBResult*)value_;

- (void)addYearData:(NSSet*)value_;
- (void)removeYearData:(NSSet*)value_;
- (void)addYearDataObject:(WBPlayerYearData*)value_;
- (void)removeYearDataObject:(WBPlayerYearData*)value_;

@end

@interface _WBPlayer (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveCurrentHandicap;
- (void)setPrimitiveCurrentHandicap:(NSNumber*)value;

- (int16_t)primitiveCurrentHandicapValue;
- (void)setPrimitiveCurrentHandicapValue:(int16_t)value_;




- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int16_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int16_t)value_;





- (NSMutableSet*)primitiveMatches;
- (void)setPrimitiveMatches:(NSMutableSet*)value;



- (NSMutableSet*)primitiveResults;
- (void)setPrimitiveResults:(NSMutableSet*)value;



- (NSMutableSet*)primitiveYearData;
- (void)setPrimitiveYearData:(NSMutableSet*)value;


@end
