// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBLeaderBoard.h instead.

#import <CoreData/CoreData.h>
#import "WBManagedObject.h"

extern const struct WBLeaderBoardAttributes {
	__unsafe_unretained NSString *isPlayerBoard;
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *tablePriority;
} WBLeaderBoardAttributes;

extern const struct WBLeaderBoardRelationships {
	__unsafe_unretained NSString *boardData;
} WBLeaderBoardRelationships;

extern const struct WBLeaderBoardFetchedProperties {
} WBLeaderBoardFetchedProperties;

@class WBBoardData;






@interface WBLeaderBoardID : NSManagedObjectID {}
@end

@interface _WBLeaderBoard : WBManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBLeaderBoardID*)objectID;





@property (nonatomic, strong) NSNumber* isPlayerBoard;



@property BOOL isPlayerBoardValue;
- (BOOL)isPlayerBoardValue;
- (void)setIsPlayerBoardValue:(BOOL)value_;

//- (BOOL)validateIsPlayerBoard:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* key;



//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* tablePriority;



@property int16_t tablePriorityValue;
- (int16_t)tablePriorityValue;
- (void)setTablePriorityValue:(int16_t)value_;

//- (BOOL)validateTablePriority:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *boardData;

- (NSMutableSet*)boardDataSet;





@end

@interface _WBLeaderBoard (CoreDataGeneratedAccessors)

- (void)addBoardData:(NSSet*)value_;
- (void)removeBoardData:(NSSet*)value_;
- (void)addBoardDataObject:(WBBoardData*)value_;
- (void)removeBoardDataObject:(WBBoardData*)value_;

@end

@interface _WBLeaderBoard (CoreDataGeneratedPrimitiveAccessors)


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





- (NSMutableSet*)primitiveBoardData;
- (void)setPrimitiveBoardData:(NSMutableSet*)value;


@end
