// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBResult.h instead.

#import <CoreData/CoreData.h>


extern const struct WBResultAttributes {
	__unsafe_unretained NSString *points;
	__unsafe_unretained NSString *priorHandicap;
	__unsafe_unretained NSString *score;
} WBResultAttributes;

extern const struct WBResultRelationships {
	__unsafe_unretained NSString *match;
	__unsafe_unretained NSString *player;
} WBResultRelationships;

extern const struct WBResultFetchedProperties {
} WBResultFetchedProperties;

@class WBMatch;
@class WBPlayer;





@interface WBResultID : NSManagedObjectID {}
@end

@interface _WBResult : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBResultID*)objectID;





@property (nonatomic, strong) NSNumber* points;



@property int16_t pointsValue;
- (int16_t)pointsValue;
- (void)setPointsValue:(int16_t)value_;

//- (BOOL)validatePoints:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* priorHandicap;



@property int16_t priorHandicapValue;
- (int16_t)priorHandicapValue;
- (void)setPriorHandicapValue:(int16_t)value_;

//- (BOOL)validatePriorHandicap:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* score;



@property int16_t scoreValue;
- (int16_t)scoreValue;
- (void)setScoreValue:(int16_t)value_;

//- (BOOL)validateScore:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) WBMatch *match;

//- (BOOL)validateMatch:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) WBPlayer *player;

//- (BOOL)validatePlayer:(id*)value_ error:(NSError**)error_;





@end

@interface _WBResult (CoreDataGeneratedAccessors)

@end

@interface _WBResult (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitivePoints;
- (void)setPrimitivePoints:(NSNumber*)value;

- (int16_t)primitivePointsValue;
- (void)setPrimitivePointsValue:(int16_t)value_;




- (NSNumber*)primitivePriorHandicap;
- (void)setPrimitivePriorHandicap:(NSNumber*)value;

- (int16_t)primitivePriorHandicapValue;
- (void)setPrimitivePriorHandicapValue:(int16_t)value_;




- (NSNumber*)primitiveScore;
- (void)setPrimitiveScore:(NSNumber*)value;

- (int16_t)primitiveScoreValue;
- (void)setPrimitiveScoreValue:(int16_t)value_;





- (WBMatch*)primitiveMatch;
- (void)setPrimitiveMatch:(WBMatch*)value;



- (WBPlayer*)primitivePlayer;
- (void)setPrimitivePlayer:(WBPlayer*)value;


@end
