// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPeopleEntity.h instead.

#import <CoreData/CoreData.h>
#import "WBManagedObject.h"

extern const struct WBPeopleEntityAttributes {
	__unsafe_unretained NSString *favorite;
	__unsafe_unretained NSString *me;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *real;
} WBPeopleEntityAttributes;

extern const struct WBPeopleEntityRelationships {
	__unsafe_unretained NSString *boardData;
} WBPeopleEntityRelationships;

extern const struct WBPeopleEntityFetchedProperties {
} WBPeopleEntityFetchedProperties;

@class WBBoardData;






@interface WBPeopleEntityID : NSManagedObjectID {}
@end

@interface _WBPeopleEntity : WBManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBPeopleEntityID*)objectID;





@property (nonatomic, strong) NSNumber* favorite;



@property BOOL favoriteValue;
- (BOOL)favoriteValue;
- (void)setFavoriteValue:(BOOL)value_;

//- (BOOL)validateFavorite:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* me;



@property BOOL meValue;
- (BOOL)meValue;
- (void)setMeValue:(BOOL)value_;

//- (BOOL)validateMe:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* real;



@property BOOL realValue;
- (BOOL)realValue;
- (void)setRealValue:(BOOL)value_;

//- (BOOL)validateReal:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *boardData;

- (NSMutableSet*)boardDataSet;





@end

@interface _WBPeopleEntity (CoreDataGeneratedAccessors)

- (void)addBoardData:(NSSet*)value_;
- (void)removeBoardData:(NSSet*)value_;
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





- (NSMutableSet*)primitiveBoardData;
- (void)setPrimitiveBoardData:(NSMutableSet*)value;


@end
