// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBResult.h instead.

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
@class WBPlayer;
@class WBTeam;

@interface WBResultID : NSManagedObjectID {}
@end

@interface _WBResult : WBManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WBResultID *objectID;

@property (nonatomic, strong, nullable) NSNumber* points;

@property (atomic) uint16_t pointsValue;
- (uint16_t)pointsValue;
- (void)setPointsValue:(uint16_t)value_;

@property (nonatomic, strong) NSNumber* priorHandicap;

@property (atomic) int16_t priorHandicapValue;
- (int16_t)priorHandicapValue;
- (void)setPriorHandicapValue:(int16_t)value_;

@property (nonatomic, strong) NSNumber* score;

@property (atomic) uint16_t scoreValue;
- (uint16_t)scoreValue;
- (void)setScoreValue:(uint16_t)value_;

@property (nonatomic, strong) WBMatch *match;

@property (nonatomic, strong) WBPlayer *player;

@property (nonatomic, strong) WBTeam *team;

@end

@interface _WBResult (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitivePoints;
- (void)setPrimitivePoints:(NSNumber*)value;

- (uint16_t)primitivePointsValue;
- (void)setPrimitivePointsValue:(uint16_t)value_;

- (NSNumber*)primitivePriorHandicap;
- (void)setPrimitivePriorHandicap:(NSNumber*)value;

- (int16_t)primitivePriorHandicapValue;
- (void)setPrimitivePriorHandicapValue:(int16_t)value_;

- (NSNumber*)primitiveScore;
- (void)setPrimitiveScore:(NSNumber*)value;

- (uint16_t)primitiveScoreValue;
- (void)setPrimitiveScoreValue:(uint16_t)value_;

- (WBMatch*)primitiveMatch;
- (void)setPrimitiveMatch:(WBMatch*)value;

- (WBPlayer*)primitivePlayer;
- (void)setPrimitivePlayer:(WBPlayer*)value;

- (WBTeam*)primitiveTeam;
- (void)setPrimitiveTeam:(WBTeam*)value;

@end

@interface WBResultAttributes: NSObject 
+ (NSString *)points;
+ (NSString *)priorHandicap;
+ (NSString *)score;
@end

@interface WBResultRelationships: NSObject
+ (NSString *)match;
+ (NSString *)player;
+ (NSString *)team;
@end

NS_ASSUME_NONNULL_END
