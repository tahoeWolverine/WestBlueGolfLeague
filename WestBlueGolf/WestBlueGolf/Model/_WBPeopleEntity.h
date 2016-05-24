// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPeopleEntity.h instead.

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

@interface WBPeopleEntityID : NSManagedObjectID {}
@end

@interface _WBPeopleEntity : WBManagedObject
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) WBPeopleEntityID *objectID;

@property (nonatomic, strong) NSNumber* favorite;

@property (atomic) BOOL favoriteValue;
- (BOOL)favoriteValue;
- (void)setFavoriteValue:(BOOL)value_;

@property (nonatomic, strong) NSNumber* me;

@property (atomic) BOOL meValue;
- (BOOL)meValue;
- (void)setMeValue:(BOOL)value_;

@property (nonatomic, strong) NSString* name;

@property (nonatomic, strong) NSNumber* real;

@property (atomic) BOOL realValue;
- (BOOL)realValue;
- (void)setRealValue:(BOOL)value_;

@property (nonatomic, strong, nullable) NSSet<WBBoardData*> *boardData;
- (nullable NSMutableSet<WBBoardData*>*)boardDataSet;

@end

@interface _WBPeopleEntity (BoardDataCoreDataGeneratedAccessors)
- (void)addBoardData:(NSSet<WBBoardData*>*)value_;
- (void)removeBoardData:(NSSet<WBBoardData*>*)value_;
- (void)addBoardDataObject:(WBBoardData*)value_;
- (void)removeBoardDataObject:(WBBoardData*)value_;

@end

@interface _WBPeopleEntity (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveFavorite;
- (void)setPrimitiveFavorite:(NSNumber*)value;

- (BOOL)primitiveFavoriteValue;
- (void)setPrimitiveFavoriteValue:(BOOL)value_;

- (NSNumber*)primitiveMe;
- (void)setPrimitiveMe:(NSNumber*)value;

- (BOOL)primitiveMeValue;
- (void)setPrimitiveMeValue:(BOOL)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveReal;
- (void)setPrimitiveReal:(NSNumber*)value;

- (BOOL)primitiveRealValue;
- (void)setPrimitiveRealValue:(BOOL)value_;

- (NSMutableSet<WBBoardData*>*)primitiveBoardData;
- (void)setPrimitiveBoardData:(NSMutableSet<WBBoardData*>*)value;

@end

@interface WBPeopleEntityAttributes: NSObject 
+ (NSString *)favorite;
+ (NSString *)me;
+ (NSString *)name;
+ (NSString *)real;
@end

@interface WBPeopleEntityRelationships: NSObject
+ (NSString *)boardData;
@end

NS_ASSUME_NONNULL_END
