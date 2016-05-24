// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBLeaderBoard.h instead.

#if __has_feature(modules)
    @import Foundation;
    @import CoreData;
#else
    #import <Foundation/Foundation.h>
    #import <CoreData/CoreData.h>
#endif

#import "WBManagedObject.h"

NS_ASSUME_NONNULL_BEGIN

@class WBBoardData;

@interface WBLeaderBoardID : NSManagedObjectID {}
@end

@interface _WBLeaderBoard : WBManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WBLeaderBoardID *objectID;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int16_t idValue;
- (int16_t)idValue;
- (void)setIdValue:(int16_t)value_;

@property (nonatomic, strong) NSNumber* isPlayerBoard;

@property (atomic) BOOL isPlayerBoardValue;
- (BOOL)isPlayerBoardValue;
- (void)setIsPlayerBoardValue:(BOOL)value_;

@property (nonatomic, strong) NSString* key;

@property (nonatomic, strong) NSString* name;

@property (nonatomic, strong) NSNumber* tablePriority;

@property (atomic) int16_t tablePriorityValue;
- (int16_t)tablePriorityValue;
- (void)setTablePriorityValue:(int16_t)value_;

@property (nonatomic, strong, nullable) NSSet<WBBoardData*> *boardData;
- (nullable NSMutableSet<WBBoardData*>*)boardDataSet;

@end

@interface _WBLeaderBoard (BoardDataCoreDataGeneratedAccessors)
- (void)addBoardData:(NSSet<WBBoardData*>*)value_;
- (void)removeBoardData:(NSSet<WBBoardData*>*)value_;
- (void)addBoardDataObject:(WBBoardData*)value_;
- (void)removeBoardDataObject:(WBBoardData*)value_;

@end

@interface _WBLeaderBoard (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int16_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int16_t)value_;

- (NSNumber*)primitiveIsPlayerBoard;
- (void)setPrimitiveIsPlayerBoard:(NSNumber*)value;

- (BOOL)primitiveIsPlayerBoardValue;
- (void)setPrimitiveIsPlayerBoardValue:(BOOL)value_;

- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveTablePriority;
- (void)setPrimitiveTablePriority:(NSNumber*)value;

- (int16_t)primitiveTablePriorityValue;
- (void)setPrimitiveTablePriorityValue:(int16_t)value_;

- (NSMutableSet<WBBoardData*>*)primitiveBoardData;
- (void)setPrimitiveBoardData:(NSMutableSet<WBBoardData*>*)value;

@end

@interface WBLeaderBoardAttributes: NSObject 
+ (NSString *)id;
+ (NSString *)isPlayerBoard;
+ (NSString *)key;
+ (NSString *)name;
+ (NSString *)tablePriority;
@end

@interface WBLeaderBoardRelationships: NSObject
+ (NSString *)boardData;
@end

NS_ASSUME_NONNULL_END
