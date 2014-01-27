// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBMatch.h instead.

#import <CoreData/CoreData.h>


extern const struct WBMatchAttributes {
} WBMatchAttributes;

extern const struct WBMatchRelationships {
	__unsafe_unretained NSString *players;
	__unsafe_unretained NSString *results;
	__unsafe_unretained NSString *teamMatchup;
} WBMatchRelationships;

extern const struct WBMatchFetchedProperties {
} WBMatchFetchedProperties;

@class WBPlayer;
@class WBResult;
@class WBTeamMatchup;


@interface WBMatchID : NSManagedObjectID {}
@end

@interface _WBMatch : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBMatchID*)objectID;





@property (nonatomic, strong) NSSet *players;

- (NSMutableSet*)playersSet;




@property (nonatomic, strong) NSSet *results;

- (NSMutableSet*)resultsSet;




@property (nonatomic, strong) WBTeamMatchup *teamMatchup;

//- (BOOL)validateTeamMatchup:(id*)value_ error:(NSError**)error_;





@end

@interface _WBMatch (CoreDataGeneratedAccessors)

- (void)addPlayers:(NSSet*)value_;
- (void)removePlayers:(NSSet*)value_;
- (void)addPlayersObject:(WBPlayer*)value_;
- (void)removePlayersObject:(WBPlayer*)value_;

- (void)addResults:(NSSet*)value_;
- (void)removeResults:(NSSet*)value_;
- (void)addResultsObject:(WBResult*)value_;
- (void)removeResultsObject:(WBResult*)value_;

@end

@interface _WBMatch (CoreDataGeneratedPrimitiveAccessors)



- (NSMutableSet*)primitivePlayers;
- (void)setPrimitivePlayers:(NSMutableSet*)value;



- (NSMutableSet*)primitiveResults;
- (void)setPrimitiveResults:(NSMutableSet*)value;



- (WBTeamMatchup*)primitiveTeamMatchup;
- (void)setPrimitiveTeamMatchup:(WBTeamMatchup*)value;


@end
