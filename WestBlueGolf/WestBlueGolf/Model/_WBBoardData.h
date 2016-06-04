// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBBoardData.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "WBManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class WBLeaderBoard;
@class WBPeopleEntity;
@class WBYear;

@interface WBBoardDataID : NSManagedObjectID {}
@end

@interface _WBBoardData : WBManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WBBoardDataID *objectID;

@property (nonatomic, strong, nullable) NSString* detailValue;

@property (nonatomic, strong) NSString* displayValue;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int16_t idValue;
- (int16_t)idValue;
- (void)setIdValue:(int16_t)value_;

@property (nonatomic, strong) NSNumber* rank;

@property (atomic) uint16_t rankValue;
- (uint16_t)rankValue;
- (void)setRankValue:(uint16_t)value_;

@property (nonatomic, strong) NSNumber* value;

@property (atomic) double valueValue;
- (double)valueValue;
- (void)setValueValue:(double)value_;

@property (nonatomic, strong, nullable) WBLeaderBoard *leaderBoard;

@property (nonatomic, strong) WBPeopleEntity *peopleEntity;

@property (nonatomic, strong) WBYear *year;

@end

@interface _WBBoardData (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveDetailValue;
- (void)setPrimitiveDetailValue:(NSString*)value;

- (NSString*)primitiveDisplayValue;
- (void)setPrimitiveDisplayValue:(NSString*)value;

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int16_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int16_t)value_;

- (NSNumber*)primitiveRank;
- (void)setPrimitiveRank:(NSNumber*)value;

- (uint16_t)primitiveRankValue;
- (void)setPrimitiveRankValue:(uint16_t)value_;

- (NSNumber*)primitiveValue;
- (void)setPrimitiveValue:(NSNumber*)value;

- (double)primitiveValueValue;
- (void)setPrimitiveValueValue:(double)value_;

- (WBLeaderBoard*)primitiveLeaderBoard;
- (void)setPrimitiveLeaderBoard:(WBLeaderBoard*)value;

- (WBPeopleEntity*)primitivePeopleEntity;
- (void)setPrimitivePeopleEntity:(WBPeopleEntity*)value;

- (WBYear*)primitiveYear;
- (void)setPrimitiveYear:(WBYear*)value;

@end

@interface WBBoardDataAttributes: NSObject 
+ (NSString *)detailValue;
+ (NSString *)displayValue;
+ (NSString *)id;
+ (NSString *)rank;
+ (NSString *)value;
@end

@interface WBBoardDataRelationships: NSObject
+ (NSString *)leaderBoard;
+ (NSString *)peopleEntity;
+ (NSString *)year;
@end

NS_ASSUME_NONNULL_END
