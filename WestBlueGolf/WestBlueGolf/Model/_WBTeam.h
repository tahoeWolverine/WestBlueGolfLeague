// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeam.h instead.

#import <CoreData/CoreData.h>


extern const struct WBTeamAttributes {
	__unsafe_unretained NSString *name;
} WBTeamAttributes;

extern const struct WBTeamRelationships {
	__unsafe_unretained NSString *championYears;
	__unsafe_unretained NSString *matches;
	__unsafe_unretained NSString *players;
} WBTeamRelationships;

extern const struct WBTeamFetchedProperties {
} WBTeamFetchedProperties;

@class WBYear;
@class WBTeamMatchup;
@class WBPlayer;



@interface WBTeamID : NSManagedObjectID {}
@end

@interface _WBTeam : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBTeamID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *championYears;

- (NSMutableSet*)championYearsSet;




@property (nonatomic, strong) NSSet *matches;

- (NSMutableSet*)matchesSet;




@property (nonatomic, strong) NSSet *players;

- (NSMutableSet*)playersSet;





@end

@interface _WBTeam (CoreDataGeneratedAccessors)

- (void)addChampionYears:(NSSet*)value_;
- (void)removeChampionYears:(NSSet*)value_;
- (void)addChampionYearsObject:(WBYear*)value_;
- (void)removeChampionYearsObject:(WBYear*)value_;

- (void)addMatches:(NSSet*)value_;
- (void)removeMatches:(NSSet*)value_;
- (void)addMatchesObject:(WBTeamMatchup*)value_;
- (void)removeMatchesObject:(WBTeamMatchup*)value_;

- (void)addPlayers:(NSSet*)value_;
- (void)removePlayers:(NSSet*)value_;
- (void)addPlayersObject:(WBPlayer*)value_;
- (void)removePlayersObject:(WBPlayer*)value_;

@end

@interface _WBTeam (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveChampionYears;
- (void)setPrimitiveChampionYears:(NSMutableSet*)value;



- (NSMutableSet*)primitiveMatches;
- (void)setPrimitiveMatches:(NSMutableSet*)value;



- (NSMutableSet*)primitivePlayers;
- (void)setPrimitivePlayers:(NSMutableSet*)value;


@end
