// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBWeek.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "WBManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class WBCourse;
@class WBTeamMatchup;
@class WBYear;

@interface WBWeekID : NSManagedObjectID {}
@end

@interface _WBWeek : WBManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WBWeekID *objectID;

@property (nonatomic, strong) NSDate* date;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int16_t idValue;
- (int16_t)idValue;
- (void)setIdValue:(int16_t)value_;

@property (nonatomic, strong) NSNumber* isBadData;

@property (atomic) BOOL isBadDataValue;
- (BOOL)isBadDataValue;
- (void)setIsBadDataValue:(BOOL)value_;

@property (nonatomic, strong) NSNumber* isPlayoff;

@property (atomic) BOOL isPlayoffValue;
- (BOOL)isPlayoffValue;
- (void)setIsPlayoffValue:(BOOL)value_;

@property (nonatomic, strong) NSNumber* pairing;

@property (atomic) int16_t pairingValue;
- (int16_t)pairingValue;
- (void)setPairingValue:(int16_t)value_;

@property (nonatomic, strong) NSNumber* seasonIndex;

@property (atomic) uint16_t seasonIndexValue;
- (uint16_t)seasonIndexValue;
- (void)setSeasonIndexValue:(uint16_t)value_;

@property (nonatomic, strong) WBCourse *course;

@property (nonatomic, strong) NSSet<WBTeamMatchup*> *teamMatchups;
- (NSMutableSet<WBTeamMatchup*>*)teamMatchupsSet;

@property (nonatomic, strong) WBYear *year;

@end

@interface _WBWeek (TeamMatchupsCoreDataGeneratedAccessors)
- (void)addTeamMatchups:(NSSet<WBTeamMatchup*>*)value_;
- (void)removeTeamMatchups:(NSSet<WBTeamMatchup*>*)value_;
- (void)addTeamMatchupsObject:(WBTeamMatchup*)value_;
- (void)removeTeamMatchupsObject:(WBTeamMatchup*)value_;

@end

@interface _WBWeek (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveDate;
- (void)setPrimitiveDate:(NSDate*)value;

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int16_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int16_t)value_;

- (NSNumber*)primitiveIsBadData;
- (void)setPrimitiveIsBadData:(NSNumber*)value;

- (BOOL)primitiveIsBadDataValue;
- (void)setPrimitiveIsBadDataValue:(BOOL)value_;

- (NSNumber*)primitiveIsPlayoff;
- (void)setPrimitiveIsPlayoff:(NSNumber*)value;

- (BOOL)primitiveIsPlayoffValue;
- (void)setPrimitiveIsPlayoffValue:(BOOL)value_;

- (NSNumber*)primitivePairing;
- (void)setPrimitivePairing:(NSNumber*)value;

- (int16_t)primitivePairingValue;
- (void)setPrimitivePairingValue:(int16_t)value_;

- (NSNumber*)primitiveSeasonIndex;
- (void)setPrimitiveSeasonIndex:(NSNumber*)value;

- (uint16_t)primitiveSeasonIndexValue;
- (void)setPrimitiveSeasonIndexValue:(uint16_t)value_;

- (WBCourse*)primitiveCourse;
- (void)setPrimitiveCourse:(WBCourse*)value;

- (NSMutableSet<WBTeamMatchup*>*)primitiveTeamMatchups;
- (void)setPrimitiveTeamMatchups:(NSMutableSet<WBTeamMatchup*>*)value;

- (WBYear*)primitiveYear;
- (void)setPrimitiveYear:(WBYear*)value;

@end

@interface WBWeekAttributes: NSObject 
+ (NSString *)date;
+ (NSString *)id;
+ (NSString *)isBadData;
+ (NSString *)isPlayoff;
+ (NSString *)pairing;
+ (NSString *)seasonIndex;
@end

@interface WBWeekRelationships: NSObject
+ (NSString *)course;
+ (NSString *)teamMatchups;
+ (NSString *)year;
@end

NS_ASSUME_NONNULL_END
