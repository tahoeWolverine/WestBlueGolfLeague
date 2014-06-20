// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeam.h instead.

#import <CoreData/CoreData.h>
#import "WBPeopleEntity.h"

extern const struct WBTeamAttributes {
	__unsafe_unretained NSString *id;
} WBTeamAttributes;

extern const struct WBTeamRelationships {
	__unsafe_unretained NSString *matchups;
	__unsafe_unretained NSString *playerYearData;
	__unsafe_unretained NSString *results;
} WBTeamRelationships;

extern const struct WBTeamFetchedProperties {
} WBTeamFetchedProperties;

@class WBTeamMatchup;
@class WBPlayerYearData;
@class WBResult;



@interface WBTeamID : NSManagedObjectID {}
@end

@interface _WBTeam : WBPeopleEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBTeamID*)objectID;





@property (nonatomic, strong) NSNumber* id;



@property int16_t idValue;
- (int16_t)idValue;
- (void)setIdValue:(int16_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *matchups;

- (NSMutableSet*)matchupsSet;




@property (nonatomic, strong) NSSet *playerYearData;

- (NSMutableSet*)playerYearDataSet;




@property (nonatomic, strong) NSSet *results;

- (NSMutableSet*)resultsSet;





@end

@interface _WBTeam (CoreDataGeneratedAccessors)

- (void)addMatchups:(NSSet*)value_;
- (void)removeMatchups:(NSSet*)value_;
- (void)addMatchupsObject:(WBTeamMatchup*)value_;
- (void)removeMatchupsObject:(WBTeamMatchup*)value_;

- (void)addPlayerYearData:(NSSet*)value_;
- (void)removePlayerYearData:(NSSet*)value_;
- (void)addPlayerYearDataObject:(WBPlayerYearData*)value_;
- (void)removePlayerYearDataObject:(WBPlayerYearData*)value_;

- (void)addResults:(NSSet*)value_;
- (void)removeResults:(NSSet*)value_;
- (void)addResultsObject:(WBResult*)value_;
- (void)removeResultsObject:(WBResult*)value_;

@end

@interface _WBTeam (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int16_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int16_t)value_;





- (NSMutableSet*)primitiveMatchups;
- (void)setPrimitiveMatchups:(NSMutableSet*)value;



- (NSMutableSet*)primitivePlayerYearData;
- (void)setPrimitivePlayerYearData:(NSMutableSet*)value;



- (NSMutableSet*)primitiveResults;
- (void)setPrimitiveResults:(NSMutableSet*)value;


@end
