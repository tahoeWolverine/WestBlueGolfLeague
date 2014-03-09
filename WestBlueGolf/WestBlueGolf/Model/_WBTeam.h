// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeam.h instead.

#import <CoreData/CoreData.h>
#import "WBPeopleEntity.h"

extern const struct WBTeamAttributes {
	__unsafe_unretained NSString *teamId;
} WBTeamAttributes;

extern const struct WBTeamRelationships {
	__unsafe_unretained NSString *championYears;
	__unsafe_unretained NSString *matchups;
	__unsafe_unretained NSString *players;
	__unsafe_unretained NSString *results;
} WBTeamRelationships;

extern const struct WBTeamFetchedProperties {
} WBTeamFetchedProperties;

@class WBYear;
@class WBTeamMatchup;
@class WBPlayer;
@class WBResult;



@interface WBTeamID : NSManagedObjectID {}
@end

@interface _WBTeam : WBPeopleEntity {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBTeamID*)objectID;





@property (nonatomic, strong) NSNumber* teamId;



@property int16_t teamIdValue;
- (int16_t)teamIdValue;
- (void)setTeamIdValue:(int16_t)value_;

//- (BOOL)validateTeamId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *championYears;

- (NSMutableSet*)championYearsSet;




@property (nonatomic, strong) NSSet *matchups;

- (NSMutableSet*)matchupsSet;




@property (nonatomic, strong) NSSet *players;

- (NSMutableSet*)playersSet;




@property (nonatomic, strong) NSSet *results;

- (NSMutableSet*)resultsSet;





@end

@interface _WBTeam (CoreDataGeneratedAccessors)

- (void)addChampionYears:(NSSet*)value_;
- (void)removeChampionYears:(NSSet*)value_;
- (void)addChampionYearsObject:(WBYear*)value_;
- (void)removeChampionYearsObject:(WBYear*)value_;

- (void)addMatchups:(NSSet*)value_;
- (void)removeMatchups:(NSSet*)value_;
- (void)addMatchupsObject:(WBTeamMatchup*)value_;
- (void)removeMatchupsObject:(WBTeamMatchup*)value_;

- (void)addPlayers:(NSSet*)value_;
- (void)removePlayers:(NSSet*)value_;
- (void)addPlayersObject:(WBPlayer*)value_;
- (void)removePlayersObject:(WBPlayer*)value_;

- (void)addResults:(NSSet*)value_;
- (void)removeResults:(NSSet*)value_;
- (void)addResultsObject:(WBResult*)value_;
- (void)removeResultsObject:(WBResult*)value_;

@end

@interface _WBTeam (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveTeamId;
- (void)setPrimitiveTeamId:(NSNumber*)value;

- (int16_t)primitiveTeamIdValue;
- (void)setPrimitiveTeamIdValue:(int16_t)value_;





- (NSMutableSet*)primitiveChampionYears;
- (void)setPrimitiveChampionYears:(NSMutableSet*)value;



- (NSMutableSet*)primitiveMatchups;
- (void)setPrimitiveMatchups:(NSMutableSet*)value;



- (NSMutableSet*)primitivePlayers;
- (void)setPrimitivePlayers:(NSMutableSet*)value;



- (NSMutableSet*)primitiveResults;
- (void)setPrimitiveResults:(NSMutableSet*)value;


@end
