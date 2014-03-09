// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBPeopleEntity.h instead.

#import <CoreData/CoreData.h>


extern const struct WBPeopleEntityAttributes {
	__unsafe_unretained NSString *name;
} WBPeopleEntityAttributes;

extern const struct WBPeopleEntityRelationships {
	__unsafe_unretained NSString *boardData;
} WBPeopleEntityRelationships;

extern const struct WBPeopleEntityFetchedProperties {
} WBPeopleEntityFetchedProperties;

@class WBBoardData;



@interface WBPeopleEntityID : NSManagedObjectID {}
@end

@interface _WBPeopleEntity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBPeopleEntityID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





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


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (NSMutableSet*)primitiveBoardData;
- (void)setPrimitiveBoardData:(NSMutableSet*)value;


@end
