// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBMatch.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "WBManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class WBPlayer;
@class WBResult;
@class WBTeamMatchup;

@interface WBMatchID : NSManagedObjectID {}
@end

@interface _WBMatch : WBManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WBMatchID *objectID;

@property (nonatomic, strong) NSSet<WBPlayer*> *players;
- (NSMutableSet<WBPlayer*>*)playersSet;

@property (nonatomic, strong, nullable) NSSet<WBResult*> *results;
- (nullable NSMutableSet<WBResult*>*)resultsSet;

@property (nonatomic, strong) WBTeamMatchup *teamMatchup;

@end

@interface _WBMatch (PlayersCoreDataGeneratedAccessors)
- (void)addPlayers:(NSSet<WBPlayer*>*)value_;
- (void)removePlayers:(NSSet<WBPlayer*>*)value_;
- (void)addPlayersObject:(WBPlayer*)value_;
- (void)removePlayersObject:(WBPlayer*)value_;

@end

@interface _WBMatch (ResultsCoreDataGeneratedAccessors)
- (void)addResults:(NSSet<WBResult*>*)value_;
- (void)removeResults:(NSSet<WBResult*>*)value_;
- (void)addResultsObject:(WBResult*)value_;
- (void)removeResultsObject:(WBResult*)value_;

@end

@interface _WBMatch (CoreDataGeneratedPrimitiveAccessors)

- (NSMutableSet<WBPlayer*>*)primitivePlayers;
- (void)setPrimitivePlayers:(NSMutableSet<WBPlayer*>*)value;

- (NSMutableSet<WBResult*>*)primitiveResults;
- (void)setPrimitiveResults:(NSMutableSet<WBResult*>*)value;

- (WBTeamMatchup*)primitiveTeamMatchup;
- (void)setPrimitiveTeamMatchup:(WBTeamMatchup*)value;

@end

@interface WBMatchRelationships: NSObject
+ (NSString *)players;
+ (NSString *)results;
+ (NSString *)teamMatchup;
@end

NS_ASSUME_NONNULL_END
