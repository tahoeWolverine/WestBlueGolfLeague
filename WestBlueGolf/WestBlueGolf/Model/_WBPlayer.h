// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPlayer.h instead.

#import <CoreData/CoreData.h>


extern const struct WBPlayerAttributes {
	__unsafe_unretained NSString *currentHandicap;
	__unsafe_unretained NSString *name;
} WBPlayerAttributes;

extern const struct WBPlayerRelationships {
	__unsafe_unretained NSString *matches;
	__unsafe_unretained NSString *results;
	__unsafe_unretained NSString *team;
	__unsafe_unretained NSString *yearData;
} WBPlayerRelationships;

extern const struct WBPlayerFetchedProperties {
} WBPlayerFetchedProperties;

@class WBMatch;
@class WBResult;
@class WBTeam;
@class WBPlayerYearData;




@interface WBPlayerID : NSManagedObjectID {}
@end

@interface _WBPlayer : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBPlayerID*)objectID;





@property (nonatomic, strong) NSNumber* currentHandicap;



@property int16_t currentHandicapValue;
- (int16_t)currentHandicapValue;
- (void)setCurrentHandicapValue:(int16_t)value_;

//- (BOOL)validateCurrentHandicap:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *matches;

- (NSMutableSet*)matchesSet;




@property (nonatomic, strong) WBResult *results;

//- (BOOL)validateResults:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) WBTeam *team;

//- (BOOL)validateTeam:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) WBPlayerYearData *yearData;

//- (BOOL)validateYearData:(id*)value_ error:(NSError**)error_;





@end

@interface _WBPlayer (CoreDataGeneratedAccessors)

- (void)addMatches:(NSSet*)value_;
- (void)removeMatches:(NSSet*)value_;
- (void)addMatchesObject:(WBMatch*)value_;
- (void)removeMatchesObject:(WBMatch*)value_;

@end

@interface _WBPlayer (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveCurrentHandicap;
- (void)setPrimitiveCurrentHandicap:(NSNumber*)value;

- (int16_t)primitiveCurrentHandicapValue;
- (void)setPrimitiveCurrentHandicapValue:(int16_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveMatches;
- (void)setPrimitiveMatches:(NSMutableSet*)value;



- (WBResult*)primitiveResults;
- (void)setPrimitiveResults:(WBResult*)value;



- (WBTeam*)primitiveTeam;
- (void)setPrimitiveTeam:(WBTeam*)value;



- (WBPlayerYearData*)primitiveYearData;
- (void)setPrimitiveYearData:(WBPlayerYearData*)value;


@end
