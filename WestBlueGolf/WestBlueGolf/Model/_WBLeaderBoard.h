// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to WBLeaderBoard.h instead.

#import <CoreData/CoreData.h>


extern const struct WBLeaderBoardAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *tablePriority;
} WBLeaderBoardAttributes;

extern const struct WBLeaderBoardRelationships {
} WBLeaderBoardRelationships;

extern const struct WBLeaderBoardFetchedProperties {
} WBLeaderBoardFetchedProperties;





@interface WBLeaderBoardID : NSManagedObjectID {}
@end

@interface _WBLeaderBoard : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (WBLeaderBoardID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* tablePriority;



@property int16_t tablePriorityValue;
- (int16_t)tablePriorityValue;
- (void)setTablePriorityValue:(int16_t)value_;

//- (BOOL)validateTablePriority:(id*)value_ error:(NSError**)error_;






@end

@interface _WBLeaderBoard (CoreDataGeneratedAccessors)

@end

@interface _WBLeaderBoard (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveTablePriority;
- (void)setPrimitiveTablePriority:(NSNumber*)value;

- (int16_t)primitiveTablePriorityValue;
- (void)setPrimitiveTablePriorityValue:(int16_t)value_;




@end
