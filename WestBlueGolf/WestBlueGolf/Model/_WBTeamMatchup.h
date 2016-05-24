// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeamMatchup.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "WBManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class WBMatch;
@class WBTeam;
@class WBWeek;

@interface WBTeamMatchupID : NSManagedObjectID {}
@end

@interface _WBTeamMatchup : WBManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WBTeamMatchupID *objectID;

@property (nonatomic, strong) NSNumber* matchComplete;

@property (atomic) BOOL matchCompleteValue;
- (BOOL)matchCompleteValue;
- (void)setMatchCompleteValue:(BOOL)value_;

@property (nonatomic, strong) NSNumber* matchId;

@property (atomic) int16_t matchIdValue;
- (int16_t)matchIdValue;
- (void)setMatchIdValue:(int16_t)value_;

@property (nonatomic, strong) NSNumber* matchOrder;

@property (atomic) uint16_t matchOrderValue;
- (uint16_t)matchOrderValue;
- (void)setMatchOrderValue:(uint16_t)value_;

@property (nonatomic, strong) NSNumber* playoffType;

@property (atomic) int16_t playoffTypeValue;
- (int16_t)playoffTypeValue;
- (void)setPlayoffTypeValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSSet<WBMatch*> *matches;
- (nullable NSMutableSet<WBMatch*>*)matchesSet;

@property (nonatomic, strong) NSSet<WBTeam*> *teams;
- (NSMutableSet<WBTeam*>*)teamsSet;

@property (nonatomic, strong) WBWeek *week;

@end

@interface _WBTeamMatchup (MatchesCoreDataGeneratedAccessors)
- (void)addMatches:(NSSet<WBMatch*>*)value_;
- (void)removeMatches:(NSSet<WBMatch*>*)value_;
- (void)addMatchesObject:(WBMatch*)value_;
- (void)removeMatchesObject:(WBMatch*)value_;

@end

@interface _WBTeamMatchup (TeamsCoreDataGeneratedAccessors)
- (void)addTeams:(NSSet<WBTeam*>*)value_;
- (void)removeTeams:(NSSet<WBTeam*>*)value_;
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

- (NSNumber*)primitiveMatchOrder;
- (void)setPrimitiveMatchOrder:(NSNumber*)value;

- (uint16_t)primitiveMatchOrderValue;
- (void)setPrimitiveMatchOrderValue:(uint16_t)value_;

- (NSNumber*)primitivePlayoffType;
- (void)setPrimitivePlayoffType:(NSNumber*)value;

- (int16_t)primitivePlayoffTypeValue;
- (void)setPrimitivePlayoffTypeValue:(int16_t)value_;

- (NSMutableSet<WBMatch*>*)primitiveMatches;
- (void)setPrimitiveMatches:(NSMutableSet<WBMatch*>*)value;

- (NSMutableSet<WBTeam*>*)primitiveTeams;
- (void)setPrimitiveTeams:(NSMutableSet<WBTeam*>*)value;

- (WBWeek*)primitiveWeek;
- (void)setPrimitiveWeek:(WBWeek*)value;

@end

@interface WBTeamMatchupAttributes: NSObject 
+ (NSString *)matchComplete;
+ (NSString *)matchId;
+ (NSString *)matchOrder;
+ (NSString *)playoffType;
@end

@interface WBTeamMatchupRelationships: NSObject
+ (NSString *)matches;
+ (NSString *)teams;
+ (NSString *)week;
@end

NS_ASSUME_NONNULL_END
