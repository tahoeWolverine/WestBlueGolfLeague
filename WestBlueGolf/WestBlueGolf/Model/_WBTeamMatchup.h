// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeamMatchup.h instead.

#import <CoreData/CoreData.h>


extern const struct WBTeamMatchupAttributes {
	__unsafe_unretained NSString *matchComplete;
} WBTeamMatchupAttributes;

extern const struct WBTeamMatchupRelationships {
	__unsafe_unretained NSString *matches;
	__unsafe_unretained NSString *teams;
	__unsafe_unretained NSString *week;
} WBTeamMatchupRelationships;

extern const struct WBTeamMatchupFetchedProperties {
} WBTeamMatchupFetchedProperties;

@class WBMatch;
@class WBTeam;
@class WBWeek;



@interface WBTeamMatchupID : NSManagedObjectID {}
@end

@interface _WBTeamMatchup : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBTeamMatchupID*)objectID;





@property (nonatomic, strong) NSNumber* matchComplete;



@property BOOL matchCompleteValue;
- (BOOL)matchCompleteValue;
- (void)setMatchCompleteValue:(BOOL)value_;

//- (BOOL)validateMatchComplete:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *matches;

- (NSMutableOrderedSet*)matchesSet;




@property (nonatomic, strong) NSSet *teams;

- (NSMutableSet*)teamsSet;




@property (nonatomic, strong) WBWeek *week;

//- (BOOL)validateWeek:(id*)value_ error:(NSError**)error_;





@end

@interface _WBTeamMatchup (CoreDataGeneratedAccessors)

- (void)addMatches:(NSOrderedSet*)value_;
- (void)removeMatches:(NSOrderedSet*)value_;
- (void)addMatchesObject:(WBMatch*)value_;
- (void)removeMatchesObject:(WBMatch*)value_;

- (void)addTeams:(NSSet*)value_;
- (void)removeTeams:(NSSet*)value_;
- (void)addTeamsObject:(WBTeam*)value_;
- (void)removeTeamsObject:(WBTeam*)value_;

@end

@interface _WBTeamMatchup (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveMatchComplete;
- (void)setPrimitiveMatchComplete:(NSNumber*)value;

- (BOOL)primitiveMatchCompleteValue;
- (void)setPrimitiveMatchCompleteValue:(BOOL)value_;





- (NSMutableOrderedSet*)primitiveMatches;
- (void)setPrimitiveMatches:(NSMutableOrderedSet*)value;



- (NSMutableSet*)primitiveTeams;
- (void)setPrimitiveTeams:(NSMutableSet*)value;



- (WBWeek*)primitiveWeek;
- (void)setPrimitiveWeek:(WBWeek*)value;


@end
