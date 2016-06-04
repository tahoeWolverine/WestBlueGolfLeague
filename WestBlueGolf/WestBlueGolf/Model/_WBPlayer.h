// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPlayer.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "WBPeopleEntity.h"

NS_ASSUME_NONNULL_BEGIN

@class WBMatch;
@class WBResult;
@class WBPlayerYearData;

@interface WBPlayerID : WBPeopleEntityID {}
@end

@interface _WBPlayer : WBPeopleEntity
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WBPlayerID *objectID;

@property (nonatomic, strong) NSNumber* currentHandicap;

@property (atomic) int16_t currentHandicapValue;
- (int16_t)currentHandicapValue;
- (void)setCurrentHandicapValue:(int16_t)value_;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int16_t idValue;
- (int16_t)idValue;
- (void)setIdValue:(int16_t)value_;

@property (nonatomic, strong) NSSet<WBMatch*> *matches;
- (NSMutableSet<WBMatch*>*)matchesSet;

@property (nonatomic, strong, nullable) NSSet<WBResult*> *results;
- (nullable NSMutableSet<WBResult*>*)resultsSet;

@property (nonatomic, strong) NSSet<WBPlayerYearData*> *yearData;
- (NSMutableSet<WBPlayerYearData*>*)yearDataSet;

@end

@interface _WBPlayer (MatchesCoreDataGeneratedAccessors)
- (void)addMatches:(NSSet<WBMatch*>*)value_;
- (void)removeMatches:(NSSet<WBMatch*>*)value_;
- (void)addMatchesObject:(WBMatch*)value_;
- (void)removeMatchesObject:(WBMatch*)value_;

@end

@interface _WBPlayer (ResultsCoreDataGeneratedAccessors)
- (void)addResults:(NSSet<WBResult*>*)value_;
- (void)removeResults:(NSSet<WBResult*>*)value_;
- (void)addResultsObject:(WBResult*)value_;
- (void)removeResultsObject:(WBResult*)value_;

@end

@interface _WBPlayer (YearDataCoreDataGeneratedAccessors)
- (void)addYearData:(NSSet<WBPlayerYearData*>*)value_;
- (void)removeYearData:(NSSet<WBPlayerYearData*>*)value_;
- (void)addYearDataObject:(WBPlayerYearData*)value_;
- (void)removeYearDataObject:(WBPlayerYearData*)value_;

@end

@interface _WBPlayer (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveCurrentHandicap;
- (void)setPrimitiveCurrentHandicap:(NSNumber*)value;

- (int16_t)primitiveCurrentHandicapValue;
- (void)setPrimitiveCurrentHandicapValue:(int16_t)value_;

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int16_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int16_t)value_;

- (NSMutableSet<WBMatch*>*)primitiveMatches;
- (void)setPrimitiveMatches:(NSMutableSet<WBMatch*>*)value;

- (NSMutableSet<WBResult*>*)primitiveResults;
- (void)setPrimitiveResults:(NSMutableSet<WBResult*>*)value;

- (NSMutableSet<WBPlayerYearData*>*)primitiveYearData;
- (void)setPrimitiveYearData:(NSMutableSet<WBPlayerYearData*>*)value;

@end

@interface WBPlayerAttributes: NSObject 
+ (NSString *)currentHandicap;
+ (NSString *)id;
@end

@interface WBPlayerRelationships: NSObject
+ (NSString *)matches;
+ (NSString *)results;
+ (NSString *)yearData;
@end

NS_ASSUME_NONNULL_END
