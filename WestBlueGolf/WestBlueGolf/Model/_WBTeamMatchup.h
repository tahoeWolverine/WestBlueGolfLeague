// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeamMatchup.h instead.

#import <CoreData/CoreData.h>
#import "WBManagedObject.h"

extern const struct WBTeamMatchupAttributes {
	__unsafe_unretained NSString *matchComplete;
	__unsafe_unretained NSString *matchId;
	__unsafe_unretained NSString *playoffType;
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

@interface _WBTeamMatchup : WBManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBTeamMatchupID*)objectID;





@property (nonatomic, strong) NSNumber* matchComplete;



@property BOOL matchCompleteValue;
- (BOOL)matchCompleteValue;
- (void)setMatchCompleteValue:(BOOL)value_;

//- (BOOL)validateMatchComplete:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* matchId;



@property int16_t matchIdValue;
- (int16_t)matchIdValue;
- (void)setMatchIdValue:(int16_t)value_;

//- (BOOL)validateMatchId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* playoffType;



@property int16_t playoffTypeValue;
- (int16_t)playoffTypeValue;
- (void)setPlayoffTypeValue:(int16_t)value_;

//- (BOOL)validatePlayoffType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *matches;

- (NSMutableSet*)matchesSet;




@property (nonatomic, strong) NSSet *teams;

- (NSMutableSet*)teamsSet;




@property (nonatomic, strong) WBWeek *week;

//- (BOOL)validateWeek:(id*)value_ error:(NSError**)error_;





@end

@interface _WBTeamMatchup (CoreDataGeneratedAccessors)

- (void)addMatches:(NSSet*)value_;
- (void)removeMatches:(NSSet*)value_;
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




- (NSNumber*)primitiveMatchId;
- (void)setPrimitiveMatchId:(NSNumber*)value;

- (int16_t)primitiveMatchIdValue;
- (void)setPrimitiveMatchIdValue:(int16_t)value_;




- (NSNumber*)primitivePlayoffType;
- (void)setPrimitivePlayoffType:(NSNumber*)value;

- (int16_t)primitivePlayoffTypeValue;
- (void)setPrimitivePlayoffTypeValue:(int16_t)value_;





- (NSMutableSet*)primitiveMatches;
- (void)setPrimitiveMatches:(NSMutableSet*)value;



- (NSMutableSet*)primitiveTeams;
- (void)setPrimitiveTeams:(NSMutableSet*)value;



- (WBWeek*)primitiveWeek;
- (void)setPrimitiveWeek:(WBWeek*)value;


@end
