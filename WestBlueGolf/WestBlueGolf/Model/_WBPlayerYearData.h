// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPlayerYearData.h instead.

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
@class WBTeam;
@class WBYear;

@interface WBPlayerYearDataID : NSManagedObjectID {}
@end

@interface _WBPlayerYearData : WBManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WBPlayerYearDataID *objectID;

@property (nonatomic, strong, nullable) NSNumber* finishingHandicap;

@property (atomic) int16_t finishingHandicapValue;
- (int16_t)finishingHandicapValue;
- (void)setFinishingHandicapValue:(int16_t)value_;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int16_t idValue;
- (int16_t)idValue;
- (void)setIdValue:(int16_t)value_;

@property (nonatomic, strong) NSNumber* isRookie;

@property (atomic) BOOL isRookieValue;
- (BOOL)isRookieValue;
- (void)setIsRookieValue:(BOOL)value_;

@property (nonatomic, strong) NSNumber* startingHandicap;

@property (atomic) int16_t startingHandicapValue;
- (int16_t)startingHandicapValue;
- (void)setStartingHandicapValue:(int16_t)value_;

@property (nonatomic, strong) WBPlayer *player;

@property (nonatomic, strong) WBTeam *team;

@property (nonatomic, strong) WBYear *year;

@end

@interface _WBPlayerYearData (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveFinishingHandicap;
- (void)setPrimitiveFinishingHandicap:(NSNumber*)value;

- (int16_t)primitiveFinishingHandicapValue;
- (void)setPrimitiveFinishingHandicapValue:(int16_t)value_;

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int16_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int16_t)value_;

- (NSNumber*)primitiveIsRookie;
- (void)setPrimitiveIsRookie:(NSNumber*)value;

- (BOOL)primitiveIsRookieValue;
- (void)setPrimitiveIsRookieValue:(BOOL)value_;

- (NSNumber*)primitiveStartingHandicap;
- (void)setPrimitiveStartingHandicap:(NSNumber*)value;

- (int16_t)primitiveStartingHandicapValue;
- (void)setPrimitiveStartingHandicapValue:(int16_t)value_;

- (WBPlayer*)primitivePlayer;
- (void)setPrimitivePlayer:(WBPlayer*)value;

- (WBTeam*)primitiveTeam;
- (void)setPrimitiveTeam:(WBTeam*)value;

- (WBYear*)primitiveYear;
- (void)setPrimitiveYear:(WBYear*)value;

@end

@interface WBPlayerYearDataAttributes: NSObject 
+ (NSString *)finishingHandicap;
+ (NSString *)id;
+ (NSString *)isRookie;
+ (NSString *)startingHandicap;
@end

@interface WBPlayerYearDataRelationships: NSObject
+ (NSString *)player;
+ (NSString *)team;
+ (NSString *)year;
@end

NS_ASSUME_NONNULL_END
