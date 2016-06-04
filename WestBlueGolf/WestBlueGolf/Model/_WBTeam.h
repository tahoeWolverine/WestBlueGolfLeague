// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBTeam.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "WBPeopleEntity.h"

NS_ASSUME_NONNULL_BEGIN

@class WBTeamMatchup;
@class WBPlayerYearData;
@class WBResult;

@interface WBTeamID : WBPeopleEntityID {}
@end

@interface _WBTeam : WBPeopleEntity
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WBTeamID *objectID;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int16_t idValue;
- (int16_t)idValue;
- (void)setIdValue:(int16_t)value_;

@property (nonatomic, strong) NSSet<WBTeamMatchup*> *matchups;
- (NSMutableSet<WBTeamMatchup*>*)matchupsSet;

@property (nonatomic, strong) NSSet<WBPlayerYearData*> *playerYearData;
- (NSMutableSet<WBPlayerYearData*>*)playerYearDataSet;

@property (nonatomic, strong, nullable) NSSet<WBResult*> *results;
- (nullable NSMutableSet<WBResult*>*)resultsSet;

@end

@interface _WBTeam (MatchupsCoreDataGeneratedAccessors)
- (void)addMatchups:(NSSet<WBTeamMatchup*>*)value_;
- (void)removeMatchups:(NSSet<WBTeamMatchup*>*)value_;
- (void)addMatchupsObject:(WBTeamMatchup*)value_;
- (void)removeMatchupsObject:(WBTeamMatchup*)value_;

@end

@interface _WBTeam (PlayerYearDataCoreDataGeneratedAccessors)
- (void)addPlayerYearData:(NSSet<WBPlayerYearData*>*)value_;
- (void)removePlayerYearData:(NSSet<WBPlayerYearData*>*)value_;
- (void)addPlayerYearDataObject:(WBPlayerYearData*)value_;
- (void)removePlayerYearDataObject:(WBPlayerYearData*)value_;

@end

@interface _WBTeam (ResultsCoreDataGeneratedAccessors)
- (void)addResults:(NSSet<WBResult*>*)value_;
- (void)removeResults:(NSSet<WBResult*>*)value_;
- (void)addResultsObject:(WBResult*)value_;
- (void)removeResultsObject:(WBResult*)value_;

@end

@interface _WBTeam (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int16_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int16_t)value_;

- (NSMutableSet<WBTeamMatchup*>*)primitiveMatchups;
- (void)setPrimitiveMatchups:(NSMutableSet<WBTeamMatchup*>*)value;

- (NSMutableSet<WBPlayerYearData*>*)primitivePlayerYearData;
- (void)setPrimitivePlayerYearData:(NSMutableSet<WBPlayerYearData*>*)value;

- (NSMutableSet<WBResult*>*)primitiveResults;
- (void)setPrimitiveResults:(NSMutableSet<WBResult*>*)value;

@end

@interface WBTeamAttributes: NSObject 
+ (NSString *)id;
@end

@interface WBTeamRelationships: NSObject
+ (NSString *)matchups;
+ (NSString *)playerYearData;
+ (NSString *)results;
@end

NS_ASSUME_NONNULL_END
